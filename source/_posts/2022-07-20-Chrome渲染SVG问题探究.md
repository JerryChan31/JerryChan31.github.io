---
layout: post
categories: posts
title: 当SVG defs遇上`display:none`
date: JULY 20, 2022
excerpt: 看起来Chrome的SVG渲染实现和规范有些许出入……
tags: [SVG, Chrome]
---

## 问题再现

最近在工作中，遇到了这么一个需求：

- 渲染一个列表；
- 列表的每一项，都有一个SVG图标；
- hover这个列表项时，切换为另外一个SVG图标；

于是我写出了这样的代码：

> 这里有[CodePen示例](https://codepen.io/JerryChan31/pen/MWVjGzy)，如果失效，你也可以直接将下面这段代码粘贴到一个HTML文件中然后打开。

```html
<h1>灰色为可hover区域</h1>
<p>两个一样的svg，写一样的样式：不hover时display:none，hover时display: block;</p>
<p>奇怪的点在于：hover样式只对第一个有效</p>
<ul>
  <!-- 每个li包含的SVG是完全相同的 -->
  <li>
    <svg width="48" height="48" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
      <rect width="16" height="16" rx="8" fill="url(#paint0_linear_60_59804)"></rect>
      <path d="M6.28564 9.05087V7.60388C6.28564 6.17343 6.28564 5.4582 6.72901 5.21404C7.17238 4.96989 7.74566 5.36942 8.89227 6.16847L9.97984 6.92641C10.9521 7.60397 11.4383 7.94277 11.4284 8.41522C11.4185 8.88772 10.9186 9.20437 9.91892 9.83777L8.83131 10.5268C7.70414 11.2409 7.14059 11.598 6.71311 11.3501C6.28564 11.1023 6.28564 10.4185 6.28564 9.05087Z" fill="url(#paint1_linear_60_59804)" stroke="url(#paint2_linear_60_59804)" stroke-width="1.28571" stroke-linecap="round" stroke-linejoin="round"></path>
      <defs>
        <linearGradient id="paint0_linear_60_59804" x1="0" y1="0" x2="17.6554" y2="2.10305" gradientUnits="userSpaceOnUse">
          <stop stop-color="#3F85FF"></stop>
          <stop offset="1" stop-color="#186EFC"></stop>
        </linearGradient>
        <linearGradient id="paint1_linear_60_59804" x1="8.85707" y1="5.14282" x2="8.78982" y2="16.8987" gradientUnits="userSpaceOnUse">
          <stop stop-color="white"></stop>
          <stop offset="1" stop-color="#D9D9D9" stop-opacity="0"></stop>
        </linearGradient>
        <linearGradient id="paint2_linear_60_59804" x1="8.85707" y1="5.14282" x2="8.78982" y2="15.3844" gradientUnits="userSpaceOnUse">
          <stop stop-color="white"></stop>
          <stop offset="1" stop-color="white" stop-opacity="0"></stop>
        </linearGradient>
      </defs>
    </svg>
  </li>
  <li>
    <svg width="48" height="48" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
      <rect width="16" height="16" rx="8" fill="url(#paint0_linear_60_59804)"></rect>
      <path d="M6.28564 9.05087V7.60388C6.28564 6.17343 6.28564 5.4582 6.72901 5.21404C7.17238 4.96989 7.74566 5.36942 8.89227 6.16847L9.97984 6.92641C10.9521 7.60397 11.4383 7.94277 11.4284 8.41522C11.4185 8.88772 10.9186 9.20437 9.91892 9.83777L8.83131 10.5268C7.70414 11.2409 7.14059 11.598 6.71311 11.3501C6.28564 11.1023 6.28564 10.4185 6.28564 9.05087Z" fill="url(#paint1_linear_60_59804)" stroke="url(#paint2_linear_60_59804)" stroke-width="1.28571" stroke-linecap="round" stroke-linejoin="round"></path>
      <defs>
        <linearGradient id="paint0_linear_60_59804" x1="0" y1="0" x2="17.6554" y2="2.10305" gradientUnits="userSpaceOnUse">
          <stop stop-color="#3F85FF"></stop>
          <stop offset="1" stop-color="#186EFC"></stop>
        </linearGradient>
        <linearGradient id="paint1_linear_60_59804" x1="8.85707" y1="5.14282" x2="8.78982" y2="16.8987" gradientUnits="userSpaceOnUse">
          <stop stop-color="white"></stop>
          <stop offset="1" stop-color="#D9D9D9" stop-opacity="0"></stop>
        </linearGradient>
        <linearGradient id="paint2_linear_60_59804" x1="8.85707" y1="5.14282" x2="8.78982" y2="15.3844" gradientUnits="userSpaceOnUse">
          <stop stop-color="white"></stop>
          <stop offset="1" stop-color="white" stop-opacity="0"></stop>
        </linearGradient>
      </defs>
    </svg>
  </li>
  <style>
  li {
    width: 200px;
    height: 60px;
    background-color: rgba(0,0,0,.2);
    margin-top: 10px;
  }
  li svg {
    display: none;
  }

  li:hover svg {
    display: block;
  }
  </style>
</ul>
```

这里解释一下上面的代码：`<ul>`元素里面有两个`<li>`元素，这两个元素各自包含一个完全相同的`<SVG>`元素。然后写两个对所有`<SVG>`元素都生效的样式：
1. 鼠标没有hover`<li>`元素时，对`<SVG>`元素应用`display: none`；
2. 鼠标hover`<li>`元素时，对`<SVG>`元素应用`display: block`。

按照正常预期，上面这段代码的效果应该是：hover第一个`<li>`元素时，第一个SVG图标应该展示；hover第二个`<li>`元素时，第二个SVG图标也应该展示。

然而，实际的效果并非如此——在Chrome浏览器（目前版本为103.0.5060.114）中，hover第一个`<li>`元素时，第一个SVG图标正常展示；但是hover第二个`<li>`元素时，第二个图标**没有展示**！

深入研究之后，还发现了更离奇的事情——在调试器中对第一个元素设置`force: hover`后，第二个元素的hover行为也恢复正常了！

而按照我编写的代码来看，这两个`<li>`元素的行为应该完全一致才是，但现在则产生了差异。这是最让人感到困惑的地方。

## 什么是`<defs>`

要解释这个问题，首先要了解一下SVG标准中的`<defs>`。你可以查看它的[MDN文档](https://developer.mozilla.org/zh-CN/docs/Web/SVG/Element/defs)来更加深入地了解。

`<defs>`可以让我们定义需要重复使用的图形，并在需要使用它的地方直接引用。在上面的例子里，我们定义的`<defs>`中定义了三个线性渐变（`linearGradient`）元素，它们的id分别是：`paint0_linear_60_59804`, `paint1_linear_60_59804`, `paint2_linear_60_59804`；这三个线性渐变元素被定义后，分别在`<rect>`和`<path>`的`fill`和`stroke`属性中被引用。

这样做的目的，是为了让SVG有更好的易读性和可访问性。

## 问题探索

在一番上网搜索后，发现了这一篇[文章](https://blog.patw.me/archives/1820/inline-svg-same-id-and-display-none-issue/)，文中的情景二提到的，跟我遇到的问题是一致的。沿着这篇文章，我又查阅了许多资料，对这个问题大概有了一个更加全面的了解，下面容我慢慢分说。

简单来说就是，这个作者发现在渲染多个完全一致且带有渐变的SVG时，如果对第一个SVG应用`display: none`，会连带着让后面的SVG也失效；


