```@raw html
---
authors:
  - name: Jane Smith
  - name: John Doe
    platform: bluesky
  - name: Lazaro
    avatar: https://avatars.githubusercontent.com/u/19525261?v=4
    platform: github
    link: https://github.com/lazarusA

---

## Badges via the frontmatter

<Authors />

```

**Input**

````md

```@raw html
---
authors:
  - name: Jane Smith
  - name: John Doe
    platform: bluesky
  - name: Lazaro
    avatar: https://avatars.githubusercontent.com/u/19525261?v=4
    platform: github
    link: https://github.com/lazarusA

---

## Badges via the frontmatter

<Authors />
```

````

## `AuthorBadge` and platform icons

You can include an `AuthorBadge` directly anywhere. See examples below.

```@raw html
<AuthorBadge
  author="John Doe 2"
/>

<AuthorBadge
  author="Isaac"
  platform="x"
/>

<AuthorBadge
  author="Marie"
  platform="gitlab"
/>

<AuthorBadge
  author="Nikola"
  platform="github"
/>

<AuthorBadge
  author="Galileo"
  platform="linkedin"
/>

<AuthorBadge
  author="Ada"
  platform="bluesky"
/>

<AuthorBadge
  author="Jane"
  platform="mastodon"
  link="#"
/>
```

**Input**

:::tabs

== default

````md
```@raw html
<AuthorBadge
  author="John Doe 2"
/>
```
````

== X

````md
```@raw html
<AuthorBadge
  author="Isaac"
  platform="x"
/>
```
````

== gitlab

````md
```@raw html
<AuthorBadge
  author="Marie"
  platform="gitlab"
/>
```
````

== github

````md
```@raw html
<AuthorBadge
  author="Nikola"
  platform="github"
/>
```
````

== linkedin

````md
```@raw html
<AuthorBadge
  author="Galileo"
  platform="linkedin"
/>
```
````

== bluesky

````md
```@raw html
<AuthorBadge
  author="Ada"
  platform="bluesky"
/>
```
````

== mastodon

````md
```@raw html
<AuthorBadge
  author="Jane"
  platform="mastodon"
  link="#"
/>
```
````

:::

Icons by [icons8](https://icons8.com).

::: details icons8 license

If you use the default icons, you should provide attribution. Something like:

```md
Icons by [icons8](https://icons8.com).
```

see https://icons8.com/license for more info.

:::