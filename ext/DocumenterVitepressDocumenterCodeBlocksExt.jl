module DocumenterVitepressDocumenterCodeBlocksExt

using DocumenterCodeBlocks
using DocumenterVitepress
import DocumenterVitepress as DV
using Documenter: Documenter, MarkdownAST

mutable struct PageState
    seen::Dict{String, Int}
    tips::Dict{String, Any}
    counter::Int
    named::Dict{String, Int}
end
PageState() = PageState(Dict{String, Int}(), Dict{String, Any}(), 0, Dict{String, Int}())

const _PAGE_STATES = IdDict{Tuple{Documenter.Document, Documenter.Page}, PageState}()

function _get_page_state(doc::Documenter.Document, page::Documenter.Page)
    return get!(_PAGE_STATES, (doc, page)) do
        PageState()
    end
end

function _process_shiki_directives(html::AbstractString)
    marker = "<span class=\"code-lines\""
    idx = findfirst(marker, html)
    idx === nothing && return (html, false)

    gt = findnext('>', html, last(idx))
    gt === nothing && return (html, false)
    prefix = html[1:gt]

    closing = findlast("</span>", html)
    closing === nothing && return (html, false)
    code_lines_inner = html[nextind(html, gt):prevind(html, first(closing))]
    suffix = html[first(closing):end]

    parts = split(code_lines_inner, r"<span class=\"line(?=[\s\>\"])")
    length(parts) <= 1 && return (html, false)

    nlines = length(parts) - 1
    extra_classes = [String[] for _ in 1:nlines]
    cleaned_parts = Vector{Tuple{String, String, String}}(undef, nlines)
    has_focus_container = false

    directive_regex = r"[\u200e\s]*\[!code\s+([^\s:\]]+)(?::(\d+))?\]"

    for i in 1:nlines
        part = parts[i+1]
        first_gt = findfirst('>', part)
        if first_gt === nothing
            cleaned_parts[i] = ("", part, "")
            continue
        end
        tag_attr = part[1:prevind(part, first_gt)]
        body = part[nextind(part, first_gt):end]
        last_span = findlast("</span>", body)
        if last_span === nothing
            cleaned_parts[i] = (tag_attr, body, "")
            continue
        end
        line_content = body[1:prevind(body, first(last_span))]
        trailing = body[nextind(body, last(last_span)):end]

        for dm in eachmatch(directive_regex, line_content)
            kind = dm.captures[1]
            count_str = dm.captures[2]
            count = count_str === nothing ? 1 : something(tryparse(Int, count_str), 1)

            if kind == "highlight" || kind == "hl"
                for k in i:min(i + count - 1, nlines)
                    push!(extra_classes[k], "highlighted")
                end
            elseif kind == "focus"
                has_focus_container = true
                for k in i:min(i + count - 1, nlines)
                    push!(extra_classes[k], "has-focus")
                end
            elseif kind == "--" || kind == "-"
                push!(extra_classes[i], "diff", "remove")
            elseif kind == "++" || kind == "+"
                push!(extra_classes[i], "diff", "add")
            elseif kind == "error"
                push!(extra_classes[i], "error")
            elseif kind == "warning"
                push!(extra_classes[i], "warning")
            end
        end

        cleaned = replace(line_content, r"\s*<span class=\"julia-comment\">\s*#[\u200e\s]*(?:\[!code\s+[^\s:\]]+(?::\d+)?\][\u200e\s]*)+\s*</span>" => "")
        cleaned = replace(cleaned, directive_regex => "")
        cleaned_parts[i] = (tag_attr, cleaned, trailing)
    end

    io = IOBuffer()
    print(io, prefix, parts[1])
    for i in 1:nlines
        tag_attr, cleaned, trailing = cleaned_parts[i]
        if isempty(extra_classes[i])
            print(io, "<span class=\"line", tag_attr, ">", cleaned, "</span>", trailing)
        else
            existing = strip(tag_attr)
            if startswith(existing, "\"")
                existing = strip(existing, '"')
            end
            cls_set = unique(vcat(split(existing), extra_classes[i]))
            cls_str = isempty(cls_set) ? "" : " " * join(cls_set, " ")
            print(io, "<span class=\"line", cls_str, "\">", cleaned, "</span>", trailing)
        end
    end
    print(io, suffix)

    return (String(take!(io)), has_focus_container)
end

function _format_block_html(html::AbstractString)
    # Sanitize any link fragments in generated HTML to match VitePress's sanitized_anchor_label
    html = replace(html, r"(href=\"[^\"]*#)([^\" >]+)(\")" => function (m)
        matched = match(r"(href=\"[^\"]*#)([^\" >]+)(\")", m)
        prefix, frag, suffix = matched.captures
        return prefix * replace(frag, r"[\[\]\(\)*]" => "") * suffix
    end)

    # Process VitePress/Shiki code directives (line highlights, focus, diffs, error, warning)
    html, has_focus = _process_shiki_directives(html)

    # Add v-pre and wrap in <article class="documenter-code-block">
    if startswith(html, "<pre ")
        pre = "<pre v-pre " * SubString(html, 6)
    elseif startswith(html, "<pre>")
        pre = "<pre v-pre>" * SubString(html, 6)
    else
        pre = replace(html, "<pre " => "<pre v-pre ", count = 1)
    end
    article_cls = has_focus ? "documenter-code-block has-focused-lines" : "documenter-code-block"
    return "<article class=\"" * article_cls * "\">" * pre * "</article>"
end

# 1. Assets hook: point directly to the assets bundled with DocumenterCodeBlocks
function DV.vitepress_assets(plugin::DocumenterCodeBlocks.CodeBlocks)
    return [DocumenterCodeBlocks.ASSET_DIR]
end

# 2. Config transform hook: inject styles and SPA-aware scripts into config.mts head
function DV.vitepress_config_transform(plugin::DocumenterCodeBlocks.CodeBlocks, config::String)
    tags = String[]
    if "julia" in plugin.languages
        push!(tags, "    ['link', { rel: 'stylesheet', href: `\${baseTemp.base}juliasyntax-tokens.css` }],")
        if plugin.line_numbers
            push!(tags, "    ['link', { rel: 'stylesheet', href: `\${baseTemp.base}line-numbers.css` }],")
        end
        if plugin.reference_links && plugin.popups
            push!(tags, "    ['link', { rel: 'stylesheet', href: `\${baseTemp.base}ref-popup.css` }],")
        end

        # Comprehensive VitePress-native CSS styling for DocumenterCodeBlocks
        style_block = """
    ['style', {}, `
      /* Responsive & Layout Containment for CodeBlocks in VitePress */
      article.documenter-code-block {
        position: relative;
        margin: 16px 0;
        background-color: var(--vp-code-block-bg, #f6f8fa);
        border: 1px solid var(--vp-c-divider, rgba(60, 60, 67, 0.12));
        border-radius: 8px;
        overflow: hidden;
        max-width: 100%;
        box-sizing: border-box;
      }
      article.documenter-code-block > pre {
        position: relative;
        margin: 0;
        padding: 16px 0;
        background-color: transparent !important;
        overflow-x: auto;
        max-width: 100%;
        box-sizing: border-box;
        font-family: var(--vp-font-family-mono, monospace);
        font-size: var(--vp-code-font-size, 14px);
        line-height: var(--vp-code-line-height, 1.5);
      }
      article.documenter-code-block > pre > code.line-numbers {
        display: block;
        padding-left: 0 !important;
        padding-right: 4.5rem !important;
        background-color: transparent !important;
        box-sizing: border-box;
        font-family: inherit;
        font-size: inherit;
      }
      article.documenter-code-block code.line-numbers > .code-lines {
        display: block;
        width: max-content;
        min-width: 100%;
      }
      article.documenter-code-block code.line-numbers .line-num {
        background: var(--vp-code-block-bg, #f6f8fa);
      }

      /* Shiki / VitePress-compatible Line Highlighting in DocumenterCodeBlocks */
      article.documenter-code-block .line.highlighted {
        background-color: var(--vp-code-line-highlight-color, rgba(0, 0, 0, 0.05));
      }
      html.dark article.documenter-code-block .line.highlighted {
        background-color: var(--vp-code-line-highlight-color, rgba(255, 255, 255, 0.05));
      }

      /* Diff lines: -- / ++ */
      article.documenter-code-block .line.diff.remove {
        background-color: var(--vp-code-line-diff-remove-color, rgba(244, 63, 94, 0.14));
      }
      article.documenter-code-block .line.diff.remove .line-num {
        color: var(--vp-code-line-diff-remove-symbol-color, #f43f5e);
      }
      article.documenter-code-block .line.diff.add {
        background-color: var(--vp-code-line-diff-add-color, rgba(16, 185, 129, 0.14));
      }
      article.documenter-code-block .line.diff.add .line-num {
        color: var(--vp-code-line-diff-add-symbol-color, #10b981);
      }

      /* Error & Warning lines */
      article.documenter-code-block .line.error {
        background-color: var(--vp-code-line-error-color, rgba(244, 63, 94, 0.14));
      }
      article.documenter-code-block .line.warning {
        background-color: var(--vp-code-line-warning-color, rgba(234, 179, 8, 0.14));
      }

      /* Focused lines (blurs non-focused lines until hovered) */
      article.documenter-code-block.has-focused-lines .line:not(.has-focus) {
        filter: blur(0.095rem);
        opacity: 0.4;
        transition: filter 0.35s ease, opacity 0.35s ease;
      }
      article.documenter-code-block.has-focused-lines:hover .line:not(.has-focus) {
        filter: blur(0);
        opacity: 1;
      }

      /* Fixed right-aligned action buttons (Copy + Link) */
      article.documenter-code-block .code-block-actions {
        position: absolute;
        top: 8px;
        right: 8px;
        display: flex;
        align-items: center;
        gap: 4px;
        z-index: 10;
        opacity: 0.35;
        transition: opacity 0.2s ease;
      }
      article.documenter-code-block:hover .code-block-actions,
      article.documenter-code-block .code-block-actions:focus-within {
        opacity: 1;
      }
      article.documenter-code-block .code-block-actions button,
      article.documenter-code-block .code-block-actions a {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 28px;
        height: 28px;
        padding: 4px;
        border-radius: 4px;
        background: var(--vp-code-block-bg, #f6f8fa);
        border: 1px solid var(--vp-c-divider, rgba(60, 60, 67, 0.12));
        color: var(--vp-c-text-2, #888);
        cursor: pointer;
        text-decoration: none;
        box-sizing: border-box;
        transition: color 0.15s, background-color 0.15s, border-color 0.15s;
      }
      article.documenter-code-block .code-block-actions button:hover,
      article.documenter-code-block .code-block-actions a:hover {
        color: var(--vp-c-brand-1, #0890df);
        border-color: var(--vp-c-brand-1, #0890df);
        background-color: var(--vp-c-bg-soft, #f0f2f5);
      }
      article.documenter-code-block .code-block-actions button.copied,
      article.documenter-code-block .code-block-actions a.copied {
        color: var(--ln-copied, #259a12);
        border-color: var(--ln-copied, #259a12);
      }
      article.documenter-code-block .code-block-actions svg {
        width: 14px;
        height: 14px;
      }

      /* Hide old static block-link if present in DOM */
      article.documenter-code-block pre > .block-link {
        display: none !important;
      }

      /* Dark Mode Palette Tokens */
      html.dark article.documenter-code-block {
        background-color: var(--vp-code-block-bg, #161618);
        border-color: var(--vp-c-divider, rgba(84, 84, 84, 0.48));
      }
      html.dark article.documenter-code-block code.line-numbers .line-num {
        background: var(--vp-code-block-bg, #161618);
      }
      html.dark article.documenter-code-block .code-block-actions button,
      html.dark article.documenter-code-block .code-block-actions a {
        background: var(--vp-code-block-bg, #161618);
        border-color: var(--vp-c-divider, rgba(84, 84, 84, 0.48));
      }
      html.dark article.documenter-code-block .code-block-actions button:hover,
      html.dark article.documenter-code-block .code-block-actions a:hover {
        background-color: var(--vp-c-bg-soft, #282f2f);
      }
      html.dark {
        --jl-keyword: #ff7b72;
        --jl-string: #a5d6ff;
        --jl-comment: #8b949e;
        --jl-number: #79c0ff;
        --jl-macro: #d2a8ff;
        --jl-function: #61afef;
        --jl-type: #e5c07b;
        --jl-prompt: #56d364;
        --ln-bg: var(--vp-code-block-bg, #161618);
        --ln-fg: #5e6d6f;
        --ln-fg-hover: #6eb0e8;
        --ln-border: var(--vp-c-divider, #5e6d6f);
        --ln-hl-bg: rgba(255, 208, 42, 0.10);
        --ln-hl-gutter-bg: #46442e;
        --ln-hl-fg: #d8c56a;
        --ln-btn: #fff;
        --ln-btn-hover: #1abc9c;
        --ln-btn-hover-bg: rgba(255, 255, 255, 0.1);
        --refpop-bg: var(--vp-c-bg-elv, #1f2424);
        --refpop-fg: var(--vp-c-text-1, #fff);
        --refpop-border: var(--vp-c-divider, #5e6d6f);
        --refpop-accent: var(--vp-c-brand-1, #4c9aff);
        --refpop-hover-bg: var(--vp-c-bg-soft, #282f2f);
        --refpop-shadow: 0 6px 24px rgba(0, 0, 0, 0.5);
      }
    `],"""
        push!(tags, style_block)

        # Injected SPA-aware client-side runtime for VitePress
        js_runtime = """
    ['script', {}, `
      (function() {
        "use strict";
        const HASH_RE = /^#(c-[0-9a-f]+(?:-[0-9]+)?)(?:-L([0-9]+)(?:-L([0-9]+))?)?\$/;
        const LINK_SVG = '<svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path></svg>';
        const COPY_SVG = '<svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>';
        const CHECK_SVG = '<svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>';

        let anchor = null;
        let drag = null;

        function lnStart(pre) {
          const wrap = pre.querySelector(".code-lines");
          const start = wrap && wrap.dataset.lnStart ? parseInt(wrap.dataset.lnStart, 10) : 1;
          return isNaN(start) ? 1 : start;
        }

        function rangeHash(pre, a, b) {
          const off = lnStart(pre) - 1;
          a += off;
          b += off;
          return a === b ? "#" + pre.id + "-L" + a : "#" + pre.id + "-L" + a + "-L" + b;
        }

        function selectedRange(pre) {
          const m = HASH_RE.exec(location.hash);
          if (!(m && m[1] === pre.id && m[2])) return null;
          const off = lnStart(pre) - 1;
          const n = pre.querySelectorAll(".line").length;
          const a = Math.max(Math.min(+m[2], m[3] ? +m[3] : +m[2]) - off, 1);
          const b = Math.min(Math.max(+m[2], m[3] ? +m[3] : +m[2]) - off, n);
          return a <= b ? { a: a, b: b } : null;
        }

        function clearHighlights() {
          document.querySelectorAll(".line.hl").forEach(function(el) { el.classList.remove("hl"); });
          document.querySelectorAll("pre.hl-block").forEach(function(el) { el.classList.remove("hl-block"); });
        }

        function highlightRange(pre, a, b) {
          clearHighlights();
          const lines = pre.querySelectorAll(".line");
          for (let n = Math.max(a, 1); n <= b && n <= lines.length; n++) {
            lines[n - 1].classList.add("hl");
          }
        }

        function setHash(hash) {
          history.replaceState(null, "", hash);
          applyHash(hash, false);
        }

        function applyHash(hash, scroll) {
          clearHighlights();
          const m = HASH_RE.exec(hash || location.hash || "");
          if (!m) return;
          const pre = document.getElementById(m[1]);
          if (!pre) return;
          if (!m[2]) {
            pre.classList.add("hl-block");
            if (scroll) pre.scrollIntoView({ block: "center" });
            return;
          }
          const off = lnStart(pre) - 1;
          const a = Math.min(+m[2], m[3] ? +m[3] : +m[2]) - off;
          const b = Math.max(+m[2], m[3] ? +m[3] : +m[2]) - off;
          highlightRange(pre, a, b);
          const lines = pre.querySelectorAll(".line");
          if (scroll && lines[a - 1]) lines[a - 1].scrollIntoView({ block: "center" });
        }

        function writeClipboard(text) {
          if (navigator.clipboard && window.isSecureContext) {
            return navigator.clipboard.writeText(text);
          }
          return new Promise(function (resolve, reject) {
            const ta = document.createElement("textarea");
            ta.value = text;
            ta.style.position = "fixed";
            ta.style.opacity = "0";
            document.body.appendChild(ta);
            ta.select();
            try {
              document.execCommand("copy") ? resolve() : reject(new Error("execCommand"));
            } catch (err) {
              reject(err);
            } finally {
              ta.remove();
            }
          });
        }

        function copyText(text, link) {
          const origHTML = link.innerHTML;
          writeClipboard(text).then(function () {
            link.innerHTML = CHECK_SVG;
            link.classList.add("copied");
            clearTimeout(link._copiedTimer);
            link._copiedTimer = setTimeout(function () {
              link.innerHTML = origHTML;
              link.classList.remove("copied");
            }, 1500);
          }).catch(function () {});
        }

        function ensureActionButtons() {
          document.querySelectorAll("article.documenter-code-block").forEach(function (article) {
            const pre = article.querySelector('pre[id^="c-"], pre');
            if (!pre) return;
            if (article.querySelector(".code-block-actions")) return;
            const actions = document.createElement("div");
            actions.className = "code-block-actions";

            if (pre.id) {
              const link = document.createElement("a");
              link.className = "block-link";
              link.setAttribute("aria-label", "Copy link to this code block");
              link.title = "Copy link to this code block";
              link.href = "#" + pre.id;
              link.innerHTML = LINK_SVG;
              actions.appendChild(link);
            }

            const copyBtn = document.createElement("button");
            copyBtn.className = "copy-button";
            copyBtn.setAttribute("type", "button");
            copyBtn.setAttribute("aria-label", "Copy code");
            copyBtn.title = "Copy code";
            copyBtn.innerHTML = COPY_SVG;
            actions.appendChild(copyBtn);

            article.appendChild(actions);
          });
        }

        function lineFromPointer(wrap, clientY) {
          const children = wrap.children;
          if (!children || children.length === 0) return 1;
          if (clientY <= children[0].getBoundingClientRect().top) return 1;
          for (let i = 0; i < children.length; i++) {
            if (clientY < children[i].getBoundingClientRect().bottom) return i + 1;
          }
          return children.length;
        }

        function onCopyButtonClick(btn) {
          const article = btn.closest("article.documenter-code-block");
          const pre = article ? article.querySelector("pre") : null;
          if (!pre) return;
          const r = selectedRange(pre);
          let text = "";
          if (r) {
            const lines = Array.prototype.slice.call(pre.querySelectorAll(".line"), r.a - 1, r.b);
            text = lines.map(function(l) { return l.textContent; }).join(String.fromCharCode(10));
          } else {
            const lines = pre.querySelectorAll(".line");
            if (lines && lines.length > 0) {
              text = Array.prototype.map.call(lines, function(l) { return l.textContent; }).join(String.fromCharCode(10));
            } else {
              text = pre.textContent || "";
            }
          }
          copyText(text, btn);
        }

        // Delegated Gutter & Block Interactions
        document.addEventListener("mousedown", function(e) {
          if (e.button !== 0) return;
          const num = e.target.closest(".line-num");
          if (!num) return;
          const span = num.parentElement;
          const pre = span && span.closest("pre");
          const wrap = span && span.parentElement;
          if (!pre || !wrap) return;
          const line = Array.prototype.indexOf.call(wrap.children, span) + 1;
          if (e.shiftKey && anchor && anchor.pre === pre) {
            const a = Math.min(anchor.line, line);
            const b = Math.max(anchor.line, line);
            setHash(rangeHash(pre, a, b));
          } else {
            drag = { pre: pre, wrap: wrap, start: line };
            highlightRange(pre, line, line);
          }
          e.preventDefault();
        });

        document.addEventListener("mousemove", function(e) {
          if (!drag) return;
          const line = lineFromPointer(drag.wrap, e.clientY);
          highlightRange(drag.pre, Math.min(drag.start, line), Math.max(drag.start, line));
        });

        document.addEventListener("mouseup", function(e) {
          if (!drag) return;
          const line = lineFromPointer(drag.wrap, e.clientY);
          const a = Math.min(drag.start, line);
          const b = Math.max(drag.start, line);
          anchor = { pre: drag.pre, line: drag.start };
          setHash(rangeHash(drag.pre, a, b));
          drag = null;
        });

        document.addEventListener("click", function(e) {
          const link = e.target.closest(".block-link");
          if (link) {
            if (e.ctrlKey || e.metaKey || e.shiftKey || e.altKey || e.button !== 0) return;
            e.preventDefault();
            const article = link.closest("article.documenter-code-block");
            const pre = article ? article.querySelector("pre") : null;
            if (pre && !selectedRange(pre)) setHash("#" + pre.id);
            copyText(location.href, link);
            return;
          }

          const copyBtn = e.target.closest(".copy-button");
          if (copyBtn) {
            e.preventDefault();
            onCopyButtonClick(copyBtn);
            return;
          }

          // Clicks inside any code block do NOT deselect lines
          if (e.target.closest("article.documenter-code-block") || e.target.closest(".ref-popup")) {
            return;
          }

          // Clicks outside clear active line/block selection
          const m = HASH_RE.exec(location.hash);
          if (!m) return;
          clearHighlights();
          anchor = null;
          history.replaceState(null, "", location.pathname + location.search);
        });

        // Tooltip Popup Logic (Delegated)
        const SHOW_DELAY = 150;
        const HIDE_DELAY = 300;
        let popup = null;
        let showTimer = null;
        let hideTimer = null;

        function getPopup() {
          if (!popup) {
            popup = document.createElement("div");
            popup.className = "ref-popup";
            popup.addEventListener("mouseenter", cancelHide);
            popup.addEventListener("mouseleave", scheduleHide);
            document.body.appendChild(popup);
          }
          return popup;
        }

        function cancelHide() {
          if (hideTimer) {
            clearTimeout(hideTimer);
            hideTimer = null;
          }
        }

        function scheduleHide() {
          cancelHide();
          hideTimer = setTimeout(hidePopup, HIDE_DELAY);
        }

        function hidePopup() {
          if (popup) {
            popup.style.display = "none";
            popup.innerHTML = "";
          }
        }

        function tipClone(href) {
          if (!href) return null;
          const tip = document.querySelector('.ref-tips .ref-tip[data-for="' + CSS.escape(href) + '"]');
          if (!tip) return null;
          const clone = tip.cloneNode(true);
          clone.removeAttribute("data-for");
          return clone;
        }

        function parseTargets(link) {
          const raw = link.getAttribute("data-ref-targets");
          if (!raw) return null;
          try {
            const t = JSON.parse(raw);
            return Array.isArray(t) && t.length > 1 ? t : null;
          } catch (e) {
            return null;
          }
        }

        function positionPopup(link) {
          const p = getPopup();
          const r = link.getBoundingClientRect();
          const margin = 8;
          const pw = p.offsetWidth;
          const ph = p.offsetHeight;
          let left = Math.max(margin, Math.min(r.left, window.innerWidth - pw - margin));
          let top = r.bottom + 6;
          if (top + ph > window.innerHeight - margin && r.top - 6 - ph > margin) {
            top = r.top - 6 - ph;
          }
          p.style.left = left + window.scrollX + "px";
          p.style.top = top + window.scrollY + "px";
        }

        function selectTarget(list, li, detail, href, link) {
          list.querySelectorAll("li").forEach(function(x) { x.classList.remove("selected"); });
          li.classList.add("selected");
          detail.innerHTML = "";
          const clone = tipClone(href);
          if (clone) {
            detail.appendChild(clone);
            positionPopup(link);
          }
        }

        function showPopupFor(link) {
          const targets = parseTargets(link);
          const p = getPopup();
          p.innerHTML = "";

          if (targets) {
            const list = document.createElement("ul");
            list.className = "ref-popup-targets";
            const detail = document.createElement("div");
            detail.className = "ref-popup-detail";
            targets.forEach(function (t, i) {
              const li = document.createElement("li");
              const a = document.createElement("a");
              a.textContent = t[0];
              a.href = new URL(t[1], location.href).href;
              li.appendChild(a);
              li.addEventListener("mouseenter", function () {
                selectTarget(list, li, detail, t[1], link);
              });
              list.appendChild(li);
              if (i === 0) selectTarget(list, li, detail, t[1], link);
            });
            p.appendChild(list);
            p.appendChild(detail);
          } else {
            const href = link.getAttribute("data-ref-tip") || link.getAttribute("href");
            const clone = tipClone(href);
            if (!clone) return;
            p.appendChild(clone);
          }
          p.style.display = "block";
          positionPopup(link);
        }

        document.addEventListener("mouseover", function(e) {
          const link = e.target.closest("a.julia-ref");
          if (!link) return;
          cancelHide();
          if (showTimer) clearTimeout(showTimer);
          showTimer = setTimeout(function () {
            showPopupFor(link);
          }, SHOW_DELAY);
        });

        document.addEventListener("mouseout", function(e) {
          const link = e.target.closest("a.julia-ref");
          if (!link) return;
          if (e.relatedTarget && link.contains(e.relatedTarget)) return;
          if (showTimer) {
            clearTimeout(showTimer);
            showTimer = null;
          }
          scheduleHide();
        });

        document.addEventListener("focusin", function(e) {
          const link = e.target.closest("a.julia-ref");
          if (!link) return;
          cancelHide();
          if (showTimer) clearTimeout(showTimer);
          showTimer = setTimeout(function () {
            showPopupFor(link);
          }, SHOW_DELAY);
        });

        document.addEventListener("focusout", function(e) {
          const link = e.target.closest("a.julia-ref");
          if (!link) return;
          if (e.relatedTarget && link.contains(e.relatedTarget)) return;
          if (showTimer) {
            clearTimeout(showTimer);
            showTimer = null;
          }
          scheduleHide();
        });

        document.addEventListener("keydown", function(e) {
          if (e.key === "Escape") hidePopup();
        });

        window.addEventListener("hashchange", function() {
          applyHash(location.hash, true);
        });
        window.addEventListener("popstate", function() {
          applyHash(location.hash, true);
        });

        // Dynamic SPA / MutationObserver sync
        const observer = new MutationObserver(function() {
          ensureActionButtons();
          if (location.hash) applyHash(location.hash, false);
        });
        observer.observe(document.documentElement, { childList: true, subtree: true });

        // Initial setup
        if (document.readyState === "loading") {
          document.addEventListener("DOMContentLoaded", function() {
            ensureActionButtons();
            applyHash(location.hash, true);
          });
        } else {
          ensureActionButtons();
          applyHash(location.hash, true);
        }
      })();
    `],"""
        push!(tags, js_runtime)
    end
    isempty(tags) && return config
    injection = join(tags, "\n")
    return replace(config, r"(head:\s*\[)" => (m -> m * "\n" * injection))
end

# 3. CodeBlock render hook
function DV.vitepress_render_codeblock(
    plugin::DocumenterCodeBlocks.CodeBlocks,
    io::IO,
    mime::MIME"text/plain",
    node::MarkdownAST.Node,
    code::MarkdownAST.CodeBlock,
    page,
    doc;
    kwargs...
)
    "julia" in plugin.languages || return false
    kind = DocumenterCodeBlocks._block_kind(code)
    kind === nothing && return false

    st = _get_page_state(doc, page)
    meta = DocumenterCodeBlocks._consume_blockmeta!(plugin, doc, page, kind, code.code)
    mod = meta === nothing ? nothing : meta.mod

    self_ids = get(kwargs, :docstring_ids, nothing)
    docstring = self_ids !== nothing

    if kind === :block && get(kwargs, :is_signature, false)
        sig_html = DocumenterCodeBlocks.transform_signature_block(
            code.code, plugin, doc, page, st.tips, self_ids, mod
        )
        println(io, "\n", _format_block_html(sig_html), "\n")
        return true
    end

    start = if meta === nothing || docstring
        1
    elseif meta.line_counter === :continue
        st.counter + 1
    elseif meta.line_counter === :named && meta.name !== nothing
        get(st.named, meta.name, 0) + 1
    else
        1
    end

    block_html, nlines = if kind === :block
        DocumenterCodeBlocks.transform_block(
            code.code, plugin, doc, page, st.seen, st.tips, self_ids, mod, start
        )
    else # :repl
        DocumenterCodeBlocks.transform_repl_block(
            code.code, plugin, doc, page, st.seen, st.tips, self_ids, mod, start
        )
    end

    if !docstring
        st.counter = start + nlines - 1
        meta !== nothing && meta.name !== nothing &&
            (st.named[meta.name] = start + nlines - 1)
    end

    println(io, "\n", _format_block_html(block_html), "\n")
    return true
end

# 4. MultiCodeBlock render hook (e.g. executed @repl blocks)
function DV.vitepress_render_multicodeblock(
    plugin::DocumenterCodeBlocks.CodeBlocks,
    io::IO,
    mime::MIME"text/plain",
    node::MarkdownAST.Node,
    mcb::Documenter.MultiCodeBlock,
    page,
    doc;
    kwargs...
)
    "julia" in plugin.languages || return false
    codeblocks = [n.element::MarkdownAST.CodeBlock for n in node.children]
    first_repl = findfirst(cb -> startswith(cb.info, "julia-repl"), codeblocks)
    first_repl === nothing && return false

    st = _get_page_state(doc, page)
    source = codeblocks[first_repl].code
    meta = DocumenterCodeBlocks._consume_blockmeta!(plugin, doc, page, :multi, source)
    mod = meta === nothing ? nothing : meta.mod

    self_ids = get(kwargs, :docstring_ids, nothing)
    docstring = self_ids !== nothing

    start = if meta === nothing || docstring
        1
    elseif meta.line_counter === :continue
        st.counter + 1
    elseif meta.line_counter === :named && meta.name !== nothing
        get(st.named, meta.name, 0) + 1
    else
        1
    end

    inner_io = IOBuffer()
    for (i, cb) in enumerate(codeblocks)
        i > 1 && startswith(cb.info, "julia-repl") && print(inner_io, "<br/>")
        if startswith(cb.info, "julia-repl")
            print(inner_io, "<code class=\"language-julia-repl\" style=\"display:block;\">", Documenter.DOM.escapehtml(cb.code), "</code>")
        else
            print(inner_io, "<code class=\"nohighlight hljs ansi\" style=\"display:block;\">", Documenter.DOM.escapehtml(cb.code), "</code>")
        end
    end
    inner = String(take!(inner_io))

    block_html, nlines = DocumenterCodeBlocks.transform_multirepl_block(
        inner, plugin, doc, page, st.seen, st.tips, self_ids, mod, start
    )

    if !docstring
        st.counter = start + nlines - 1
        meta !== nothing && meta.name !== nothing &&
            (st.named[meta.name] = start + nlines - 1)
    end

    println(io, "\n", _format_block_html(block_html), "\n")
    return true
end

# 5. Page footer hook: emit deduplicated tooltips payload
function DV.vitepress_page_footer(
    plugin::DocumenterCodeBlocks.CodeBlocks,
    io::IO,
    page,
    doc;
    kwargs...
)
    st = get(_PAGE_STATES, (doc, page), nothing)
    if st !== nothing && plugin.popups && !isempty(st.tips)
        println(io, "\n", DocumenterCodeBlocks.tips_html(st.tips), "\n")
    end
    delete!(_PAGE_STATES, (doc, page))
    return nothing
end

end # module
