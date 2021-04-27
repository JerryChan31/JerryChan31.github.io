---
layout: post
categories: posts
title: "Javascript中的二进制对象"
excerpt: ""
tags: [JavaScript, Node.js]
date: March 30, 2021
---

![cover](/images/2021-03-30-Javascript中的二进制对象/buffersource.png)

## Intro

ArrayBuffer对象、TypedArray视图和DataView视图是 JavaScript 操作**二进制数据**的一个接口。这些对象早就存在，属于独立的规格（2011 年 2 月发布），ES6 将它们纳入了 ECMAScript 规格，并且增加了新的方法。它们都是以数组的语法处理二进制数据，所以统称为**二进制数组**。



