---
layout: post
categories: posts
title: "Javascript Obfuscator 前端代码混淆方案"
tags: [Javascript, webpack]
date-string: June 1, 2020
---
# Javascript Obfuscator 前端代码混淆方案
## 简介

> JavaScript Obfuscator is a powerful free obfuscator for JavaScript, containing a variety of features which provide protection for your source code.

Javascript Obfuscator 是一个JS的代码混淆库，主要的功能有：

- variables renaming 变量重命名
- strings extraction and encryption 字符串抽取和加密
- dead code injection 死代码注入
- control flow flattening 展开控制流
- various code transformations 多种代码转换方式

Github 地址：

[javascript-obfuscator/javascript-obfuscator](https://github.com/javascript-obfuscator/javascript-obfuscator)

## 配置方式

### Webpack plugin

**安装**

```jsx
$ npm install --save-dev webpack-obfuscator
```

W**ebpack 配置**

```jsx
var JavaScriptObfuscator = require('webpack-obfuscator');

// ...

// webpack plugins array
plugins: [
	new JavaScriptObfuscator ({
      rotateStringArray: true
  }, ['excluded_bundle_name.js'])
]
```

对于`Nuxt.js`项目，`plugins`配置在`nuxt.config.js`的`build`选项下。

### Webpack Loader

**安装**

```jsx
$ npm install --save-dev obfuscator-loader
```

**Webpack 配置**

```jsx
module.exports = {
  module: {
    rules: [
      {
        test: /\.js$/,
        include: [ path.resolve(__dirname, "justMySources") ],
        enforce: 'post',
        use: { loader: 'obfuscator-loader', options: {/* options here */} }
      },
    ]
  }
};
```

对于`Nuxt.js`项目，使用`extend`函数进行扩展。

```jsx
extend(config, ctx) {
  config.module.rules.push(
    {
      test: /util(.*)\.js$/,
      include: [ path.resolve(__dirname, 'util')  ],
      enforce: 'post',
      use: { loader: 'obfuscator-loader', options: {/* options here */}
    }
  )
}

```

## Javascript Obfuscator选项简介

选项文档地址：

[javascript-obfuscator/javascript-obfuscator](https://github.com/javascript-obfuscator/javascript-obfuscator#javascript-obfuscator-options)

这里简单介绍几个核心的选项：

**controlFlowFlattening**：会将代码的控制流展开，大大降低代码可读性。对性能影响非常大，加入此选项是需要配置`controlFlowFlatteningThreshold`以控制对性能的影响。

**deadCodeInjection**：死代码注入，会大幅增加代码体积。只在代码体积不太重要的时候打开，打开时也务必要使用`deadCodeInjectionThreshold`来控制体积。

**debugProtection**： 打开DevTool后会自动进入断点，增加调试难度

**selfDefending**：代码自检，代码被格式化之后就无法运行，设置为`true`的话`compact`选项也会被设置为`true`

**stringArray**：将代码中的常量抽取到一个数组中，降低代码可读性。可通过`stringArrayEncoding, rotateStringArray, shuffleStringArray`这几个选项配合加大混淆程度。

## Webpack Plugin 的匹配方式

Javascript Obfuscator 的 Webpack 插件的 API 长这样：

```jsx
new JavaScriptObfuscator ({ 
  /* obfuscator options */
}, [
  'excluded_bundle_name.js'
])
```

可以看到，它的API本身只提供了`exclude`选项，那么需要指定特定的bundle进行混淆，需要include的时候应该怎么办呢？

Javascript Obfuscator 使用了 `multimatch` 这个库来进行`exclude`的匹配，我们来看一下这个库的文档：[https://github.com/sindresorhus/multimatch](https://github.com/sindresorhus/multimatch)，里面有一句：

`Positive patterns (e.g. foo or *) add to the results, while negative patterns (e.g. !foo) subtract from the results.`

那么我们可以用这样的方式来实现`include`：

```jsx
[
  '**',
  '!app',
  '!pages/routeA/**',
  '!pages/routeB/**',
  '!pages/routeC/**'
]
```

看不懂的时候可以参考一下`multimatch`的测试用例：

[sindresorhus/multimatch](https://github.com/sindresorhus/multimatch/blob/master/test/test.js)

## 什么时候使用Plugin，什么时候使用Loader？

`loader`混淆的单位是文件，`plugin`混淆的单位是`bundle`。

文件先通过`loader`进行转换，Webpack将`loader`处理过的模块进行分块打包，之后再执行`plugin`操作。

如果你需要对同一个`bundle`内的部分代码进行混淆，请使用`loader`。

## 关于SourceMap

Javascript Obfuscator的主库是支持生成sourcemap的，但是webpack插件和loader暂未支持。

## Presets

官方的预设配置，根据混淆程度/性能影响选择方案。

### **High obfuscation, low performance**

Performance will 50-100% slower than without obfuscation

```jsx
{
    compact: true,
    controlFlowFlattening: true,
    controlFlowFlatteningThreshold: 1,
    deadCodeInjection: true,
    deadCodeInjectionThreshold: 1,
    debugProtection: true,
    debugProtectionInterval: true,
    disableConsoleOutput: true,
    identifierNamesGenerator: 'hexadecimal',
    log: false,
    renameGlobals: false,
    rotateStringArray: true,
    selfDefending: true,
    shuffleStringArray: true,
    splitStrings: true,
    splitStringsChunkLength: 5,
    stringArray: true,
    stringArrayEncoding: 'rc4',
    stringArrayThreshold: 1,
    transformObjectKeys: true,
    unicodeEscapeSequence: false
}
```

### **Medium obfuscation, optimal performance**

Performance will 30-35% slower than without obfuscation

```jsx
{
    compact: true,
    controlFlowFlattening: true,
    controlFlowFlatteningThreshold: 0.75,
    deadCodeInjection: true,
    deadCodeInjectionThreshold: 0.4,
    debugProtection: false,
    debugProtectionInterval: false,
    disableConsoleOutput: true,
    identifierNamesGenerator: 'hexadecimal',
    log: false,
    renameGlobals: false,
    rotateStringArray: true,
    selfDefending: true,
    shuffleStringArray: true,
    splitStrings: true,
    splitStringsChunkLength: 10,
    stringArray: true,
    stringArrayEncoding: 'base64',
    stringArrayThreshold: 0.75,
    transformObjectKeys: true,
    unicodeEscapeSequence: false
}
```

### **Low obfuscation, High performance**

Performance will slightly slower than without obfuscation

```jsx
{
    compact: true,
    controlFlowFlattening: false,
    deadCodeInjection: false,
    debugProtection: false,
    debugProtectionInterval: false,
    disableConsoleOutput: true,
    identifierNamesGenerator: 'hexadecimal',
    log: false,
    renameGlobals: false,
    rotateStringArray: true,
    selfDefending: true,
    shuffleStringArray: true,
    splitStrings: false,
    stringArray: true,
    stringArrayEncoding: false,
    stringArrayThreshold: 0.75,
    unicodeEscapeSequence: false
}
```

## Benchmark

```jsx
  compact: true,
  controlFlowFlattening: false,
  deadCodeInjection: false,
  debugProtection: true,
  debugProtectionInterval: false,
  disableConsoleOutput: true,
  identifierNamesGenerator: 'hexadecimal',
  log: false,
  renameGlobals: false,
  rotateStringArray: true,
  selfDefending: true,
  shuffleStringArray: true,
  splitStrings: false,
  stringArray: true,
  stringArrayEncoding: false,
  stringArrayThreshold: 0.75,
  unicodeEscapeSequence: false
```

未混淆：

`pages/routeB/index.js` 11.6 KiB 100%

`pages/routeA/index.js` 18.5 KiB 100%

`pages/routeC/index.js` 8.02 KiB 100%

混淆，关闭死代码注入和flatten：

`pages/routeB/index.js` 26.6 KiB 229%

`pages/routeA/index.js` 38.2 KiB 206%

`pages/routeC/index.js` 19.9 KiB 248%

混淆，打开死代码注入，threshold设置为0.5：

`pages/routeB/index.js` 40 KiB 344%

`pages/routeA/index.js` 57.9 KiB 312%

`pages/routeC/index.js` 29.5 KiB 367%

混淆，打开死代码注入，threshold设置为1：

`pages/routeB/index.js` 48.1 KiB 414%

`pages/routeA/index.js` 67.5 KiB 364%

`pages/routeC/index.js` 36.8 KiB 460%

混淆，打开逻辑展开，threshold设置为0.5：

`pages/routeB/index.js` 36.2 KiB 312%

`pages/routeA/index.js` 50 KiB 270%

`pages/routeC/index.js` 26.5 KiB 331%

混淆，打开逻辑展开，threshold设置为1:

`pages/routeB/index.js` 45.7 KiB 393%

`pages/routeA/index.js` 64.7 KiB 349%

`pages/routeC/index.js` 32.7 KiB 408%

混淆，打开死代码注入和逻辑展开，threshold设置为0.5：

`pages/routeB/index.js` 61.7 KiB 531%

`pages/routeA/index.js` 71.7 KiB 384%

`pages/routeC/index.js` 43.8 KiB  547%

混淆，打开死代码注入和逻辑展开，threshold设置为1：

`pages/routeB/index.js` 104 KiB 873%

`pages/routeA/index.js` 138 KiB 745%

`pages/routeC/index.js` 74.2 KiB 927%