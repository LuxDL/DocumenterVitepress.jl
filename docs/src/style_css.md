# CSS Styling

You can customize the appearance of your site by modifying the `style.css` file: 

```
docs
└── src
    └── .vitepress
        └── theme
            └── style.css
```

## Layout options

For example, the following settings can be adjusted to increase the available space for your content.

::: warning

To restore the default options, copy and paste the `style.css` file into `docs/src/.vitepress/theme/` and delete the following lines:

:::

```css

.VPDoc.has-aside .content-container {
  max-width: 100% !important;
}
.aside {
  max-width: 200px !important;
  padding-left: 0 !important;
}
.VPDoc {
  padding-top: 15px !important;
  padding-left: 5px !important;

}
/* This one does the right menu */

.VPDocOutlineItem li {
  text-overflow: ellipsis;
  overflow: hidden;
  white-space: nowrap;
  max-width: 200px;
}

.VPNavBar .title {
  text-overflow: ellipsis;
  overflow: hidden;
  white-space: nowrap;
}

@media (max-width: 960px) {
  .VPDoc {
    padding-left: 25px !important;  
  }
}

```

## All available space

The following settings allows your content to fill out all available space on screen.

```css
/* https://bddxg.top/article/note/vitepress优化/一些细节上的优化.html#文档页面调整-加宽 */

@media (min-width: 1440px) {
  .VPSidebar {
    padding-left: 20px !important;
    width: 250px !important;
  }
  .VPNavBar .title {
    padding-left: 15px !important;
    width: 230px !important;
  }
  .VPContent.has-sidebar {
    padding-left: 250px !important;
    padding-right: 5vw !important;
  }
  .VPNavBar .curtain {
    width: 100% !important;
  }
  .VPDoc {
    padding: 32px 0 0 !important;
  }
  .VPNavBar.has-sidebar .content {
    padding-left: 250px !important;
    padding-right: 20px !important;
  }
  
  .VPNavBar .divider {
    padding-left: 250px !important;
  }
}

@media (min-width: 960px) {
  .VPDoc {
    padding: 32px 32px 0 10 !important;
  }
  .VPContent.has-sidebar {
    padding-left: 255px !important;
  }
}

.VPNavBar {
  padding-right: 0px !important;
}

.VPDoc.has-aside .content-container {
  max-width: 100% !important;
}
.aside {
  max-width: 200px !important;
  padding-left: 0 !important;
}

/* This one does the right menu */

.VPDocOutlineItem li {
  text-overflow: ellipsis;
  overflow: hidden;
  white-space: nowrap;
  max-width: 200px;
}

.VPNavBar .title {
  text-overflow: ellipsis;
  overflow: hidden;
  white-space: nowrap;
}

```

## More

Other attributes can also be modified there, i.e., text colors, link colors, font family, etc.