import type { ShikiTransformer } from "shiki"
import type { Element, ElementContent } from "hast"

type PromptKind = "julia" | "pkg" | null

export function juliaReplTransformer(): ShikiTransformer {
  let promptInfoByLine: Array<{ len: number; kind: PromptKind }> = []
  let isJuliaBlock = false
  const rules: Array<{ kind: PromptKind; re: RegExp }> = [
    { kind: "julia", re: /^julia>/ },
    { kind: "pkg", re: /^(\([^)]*\)\s*)?pkg>/ },  // handles (@v1.9) pkg>
  ]

  function classify(line: string): { len: number; kind: PromptKind } {
    for (const r of rules) {
      const m = line.match(r.re)
      if (m) return { len: m[0].length, kind: r.kind }
    }

    return { len: 0, kind: null }
  }

  // The object is captured in `self` so the `code` hook can pass the transformer
  // to its own recursive highlighting calls (see below).
  const self: ShikiTransformer = {
    name: "julia-repl-prompts",

    preprocess(code, options) {
      isJuliaBlock = options.lang === "julia"
      return code
    },

    tokens(tokens) {
      if (!isJuliaBlock) {
        promptInfoByLine = []
        return
      }

      promptInfoByLine = tokens.map((lineTokens) => {
        const line = lineTokens.map((t) => t.content).join("")
        return classify(line)
      })
    },

    span(node, line, col) {
      if (!isJuliaBlock) return

      const info = promptInfoByLine[line - 1]
      if (!info || !info.kind || info.len <= 0) return

      if (col < info.len) {
        this.addClassToHast(node, "repl-prompt")
        this.addClassToHast(node, `repl-prompt-${info.kind}`)
      }
    },

    // A Documenter `@repl` block whose output carries ANSI color codes is
    // emitted by DocumenterVitepress as a single `ansi` fence annotated with a
    // `julia-repl-runs=<lang:linecount,...>` meta (see `join_multiblock` in
    // `src/writer.jl`).  A code fence can only carry one Shiki grammar, but we
    // want Julia-syntax-highlighted input *and* ANSI-colored output in one box
    // -- like Documenter's HTML output.  So we take over rendering: split the
    // source into the runs described by the meta, re-highlight each run with its
    // own grammar (`julia` or `ansi`), and stitch the resulting lines back into a
    // single `<pre>`.  The julia runs are highlighted with this same transformer
    // so the `julia>` prompt styling above still applies; the recursive calls
    // carry empty meta, so this hook is a no-op for them (no infinite recursion).
    code(node) {
      const raw = (this.options.meta as { __raw?: string } | undefined)?.__raw ?? ""
      const match = raw.match(/julia-repl-runs=(\S+)/)
      if (!match) return

      const srcLines = this.source.replace(/\n$/, "").split("\n")
      const children: ElementContent[] = []
      let cursor = 0
      for (const spec of match[1].split(",")) {
        const [lang, countStr] = spec.split(":")
        const count = Number(countStr)
        const text = srcLines.slice(cursor, cursor + count).join("\n")
        cursor += count

        const hast = this.codeToHast(text, {
          ...this.options,
          lang,
          meta: {},
          // Re-apply prompt styling to julia input; ansi output needs nothing.
          transformers: lang === "julia" ? [self] : [],
        })
        const pre = hast.children[0] as Element
        const codeEl = pre.children.find(
          (c): c is Element => c.type === "element" && c.tagName === "code",
        )
        if (!codeEl) continue
        for (const lineEl of codeEl.children) {
          if (lineEl.type === "element" && lineEl.tagName === "span") {
            children.push(lineEl)
            children.push({ type: "text", value: "\n" })
          }
        }
      }
      if (children.length > 0) children.pop() // drop the trailing newline
      node.children = children
    },
  }

  return self
}
