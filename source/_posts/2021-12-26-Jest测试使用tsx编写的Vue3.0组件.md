---
layout: post
categories: posts
title: Jest测试使用tsx编写的Vue3.0组件
Tags: [Test]
date: December 26, 2021
excerpt: "Jest测试使用tsx编写的Vue3.0组件，提供最小配置样例可供参考。"
---

## 背景
最近在研究和开发基于Vue3.0的组件库。组件是使用tsx编写的，在配置单元测试的过程中遇到一些问题，特此记录。

### ts-jest 还是 babel-jest？
想要在Jest中运行TS代码的单元测试，目前（2021-12-26）有两种方案可供选择：
1. 使用`@babel/preset-typescript`，配合`babel-jest`，`@babel/core`和`@babel/preset-env`。
2. 使用`ts-jest`。

主要对比的地方如下：
1. `@babel/preset-typescript`提供的Typescript支持是**纯转译**的，也就是说使用Babel作为Jest的transformer，在运行单元测试时不会检查类型是否正确。而使用`ts-jest`运行单元测试时，文件在编译过程中会一并检查类型。
2. `@babel/preset-typescript`方案还有一些小缺点，例如不支持`namespace`，不支持`const enum`，不能做declaration merging，等等。

因此，站在面向未来的视角，使用`ts-jest`是更合适的选择。当然，如果你的项目不是纯Typescript编写，那么你仍需使用`babel-jest`。

参考资料：[Babel7 or TypeScript](https://kulshekhar.github.io/ts-jest/docs/babel7-or-ts)

## 如何配置
下面介绍如何给一个基于tsx编写的Vue 3项目配置Jest单元测试框架。

### 1. 安装依赖。
```bash
pnpm i -D jest ts-jest @types/jest @vue/test-utils
```
  - `jest`：测试框架本体
  - `ts-jest`：Typescript transformer，将Typescript代码转为Jest能读懂的Javascript代码。同时检查类型。
  - `@types/jest`：Jest的类型声明。
  - `@vue/test-utils`：vue的测试套件库。


### 2. 在`tsconfig.json`的默认配置上进行修改。
```json
{
  ...,
  "compilerOptions": {
    ...,
    "jsx": "react",
    "jsxFactory": "h",
    "jsxFragmentFactory": "Fragment",
  }
}
```
  - `jsx`选项指示Typescript编译器遇到JSX代码时应该如何处理；默认为`preserve`，原样保留JSX代码。但因为Jest无法运行JSX代码，因此需要配置为`react`进行转译。  
  - `jsxFactory`选项可以修改编译JSX时使用的工厂函数。这里需要修改为`h`，这样才能使用Vue自带的h函数来将JSX代码编译成Vue Runtime可运行的代码。否则默认会使用`createElements`，这是React的函数。
  - `jsxFragmentFactory`选项和`jsxFactory`同理，但处理的是Fragment的情况。参考[React Fragment](https://zh-hans.reactjs.org/docs/fragments.html)和[Vue Fragments](https://v3.vuejs.org/guide/migration/fragments.html#_2-x-syntax)。




### 3. 生成`jest.config.js`并进行修改。
```bash
npx ts-jest config:init
```
你可以根据你的需求选择预置的配置模版。查看[ts-jest 文档](https://kulshekhar.github.io/ts-jest/docs/getting-started/presets)获取更多信息。

根据你的需要配置`testEnvironment`选项。如果你测试的是前端项目，配置成`jsdom`。默认是`node`。


## 最小配置Demo
这里提供了一个（尽量）最小配置的Demo，以供参考。
[vue3-tsx-jest-minimal-config - Github](https://github.com/JerryChan31/vue3-tsx-jest-minimal-config)