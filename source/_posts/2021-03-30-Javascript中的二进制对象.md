---
layout: post
categories: posts
title: "Javascript中的二进制对象"
excerpt: "ArrayBuffer对象、TypedArray视图和DataView视图是 JavaScript 操作二进制数据的一个接口。它们都是以数组的语法处理二进制数据，所以统称为二进制数组。"
tags: [JavaScript, Node.js]
date: March 30, 2021
---

![cover](/images/2021-03-30-Javascript中的二进制对象/buffersource.png)

## Intro

ArrayBuffer对象、TypedArray视图和DataView视图是 JavaScript 操作**二进制数据**的一个接口。这些对象早就存在，属于独立的规格（2011 年 2 月发布），ES6 将它们纳入了 ECMAScript 规格，并且增加了新的方法。它们都是以数组的语法处理二进制数据，所以统称为**二进制数组**。



## 设计目的

该接口原始设计目的与 WebGL 项目有关。所谓 WebGL，就是指浏览器与显卡之间的通信接口，为了满足 JavaScript 与显卡之间大量的、实时的数据交换，它们之间的数据通信必须是二进制的，而不能是传统的文本格式。文本格式传递一个 32 位整数，两端的 JavaScript 脚本与显卡都要进行格式转化，将非常耗时。这时要是存在一种机制，可以像 C 语言那样，直接操作字节，将 4 个字节的 32 位整数，以二进制形式原封不动地送入显卡，脚本的性能就会大幅提升。

二进制数组就是在这种背景下诞生的。它很像 C 语言的数组，允许开发者以数组下标的形式，直接操作内存，大大增强了 JavaScript 处理二进制数据的能力，使得开发者有可能通过 JavaScript 与操作系统的原生接口进行二进制通信。



## 数组是什么？

在计算机科学中，数组数据结构（英语：array data structure），简称[数组](https://zh.wikipedia.org/wiki/数组)（英语：Array），是由**相同类型的元素（element）的集合**所组成的数据结构，分配一块**连续的内存**来存储。利用元素的索引（index）可以计算出该元素对应的存储地址。

在 JavaScript 中，数组是哈希映射。它可以通过多种数据结构实现，其中一种是链表。

目前，JavaScript 引擎已经为同种数据类型的数组分配连续的存储空间了。

[从Chrome源码看JS Array的实现](https://zhuanlan.zhihu.com/p/26388217)

[探究JS V8引擎下的“数组”底层实现](https://juejin.cn/post/6844903943638794248)



## ArrayBuffer

ArrayBuffer对象代表对固定长度的连续内存空间的引用。

### 创建ArrayBuffer

它也是一个构造函数，能分配一段可以存放数据的连续内存区域。

```js
// 生成一段 32 字节的内存区域，每个字节的值默认都是 0。
// 可以看到，ArrayBuffer构造函数的参数是所需要的内存大小（单位字节）。
const buf = new ArrayBuffer(32);
// buf[0]
```



### 操作ArrayBuffer

ArrayBuffer 是一个内存区域。只是一个**原始的字节序列**。它不能直接读写，只能通过**视图**（`TypedArray`视图和`DataView`视图)来读写，视图的作用是以指定格式解读二进制数据。

视图对象本身并不存储任何东西。它是一副“眼镜”，透过它来解释存储在 ArrayBuffer 中的字节。

**ArrayBuffer 是核心对象，是所有的基础，是原始的二进制数据。**



#### DataView的方式

```js
const buf = new ArrayBuffer(32);
const dataView = new DataView(buf);
dataView.getUint8(0)
// 上面用8位无符号整数的方式来读取二进制数据，得到默认值0.
```

#### TypedArray的方式

```js
const buffer = new ArrayBuffer(12);

const x1 = new Int32Array(buffer);
x1[0] = 1;
const x2 = new Uint8Array(buffer);
x2[0]  = 2;

x1[0] // 2

//上面用两种方式（Int32和Uint8）对同一段内存建立视图
// 因为是同一段内存，一个视图对内存进行修改会影响另一个视图。
```



## TypedArray 视图

目前，TypedArray视图一共包括 9 种类型，每一种视图都是一种构造函数。

`Int8Array`：8 位有符号整数，长度 1 个字节。
`Uint8Array`：8 位无符号整数，长度 1 个字节。
`Uint8ClampedArray`：8 位无符号整数，长度 1 个字节，溢出处理不同。(溢出时大于255的值视为255，负数视为0，常用于图像处理)
`Int16Array`：16 位有符号整数，长度 2 个字节。
`Uint16Array`：16 位无符号整数，长度 2 个字节。
`Int32Array`：32 位有符号整数，长度 4 个字节。
`Uint32Array`：32 位无符号整数，长度 4 个字节。
`Float32Array`：32 位浮点数，长度 4 个字节。
`Float64Array`：64 位浮点数，长度 8 个字节。



![TypedArray](/images/2021-03-30-Javascript中的二进制对象/buffersource.png)



所有数组的方法，在它们上面都能使用。普通数组与 TypedArray 数组的差异：

- TypedArray 数组的所有成员，都是同一种类型。
- TypedArray 数组的成员是连续的，不会有空位。
- TypedArray 数组成员的默认值为 0。比如，`new Array(10)`返回一个普通数组，里面没有任何成员，只是 10 个空位；`new Uint8Array(10)`返回一个 TypedArray 数组，里面 10 个成员都是 0。
- TypedArray 数组只是一层视图，本身不储存数据，它的数据都储存在底层的`ArrayBuffer`对象之中，要获取底层对象必须使用`buffer`属性。



### 构造函数

```js
new TypedArray(buffer, [byteOffset], [length]); // byteOffset和length要与所建立的数据类型一致
new TypedArray(arrayLikeObject);  // 从普通数组生成
new TypedArray(typedArray); // 注意，此时生成的新数组，只是复制了参数数组的值，对应的底层内存是不一样的。
new TypedArray(length); // 不通过ArrayBuffer对象，直接分配内存生成。
new TypedArray();
```

对于数字参数 length —— 创建类型化数组以包含这么多元素。

它的字节长度将是 length 乘以单个 TypedArray.BYTES_PER_ELEMENT 中的字节数：

```js
let arr = new Uint16Array(4); // 为 4 个整数创建类型化数组
console.log( Uint16Array.BYTES_PER_ELEMENT ); // 每个整数 2 个字节
console.log( arr.byteLength ); // 8（字节中的大小）
```



e.g.

```js
// 创建一个8字节的ArrayBuffer
const b = new ArrayBuffer(8);

// 创建一个指向b的Int32视图，开始于字节0，直到缓冲区的末尾
const v1 = new Int32Array(b);

// 创建一个指向b的Uint8视图，开始于字节2，直到缓冲区的末尾
const v2 = new Uint8Array(b, 2);

// 创建一个指向b的Int16视图，开始于字节2，长度为2
const v3 = new Int16Array(b, 2, 2);
```

上面代码在一段长度为 8 个字节的内存（b）之上，生成了三个视图：v1、v2和v3。



### 字节序与越界

如果我们尝试将越界值写入类型化数组会出现什么情况？不会报错。但是多余的位被切除。

例如：

我们尝试将 256 放入 `Uint8Array`。

256 的二进制格式是 100000000（9 位），但 Uint8Array 每个值只有 8 位，因此可用范围为 0 到 255。

对于更大的数字，仅存储最右边的（低位有效）8 位，其余部分被切除：



为什么是右边的8位？这与[字节序](https://es6.ruanyifeng.com/#docs/arraybuffer#%E5%AD%97%E8%8A%82%E5%BA%8F)有关。

一个占据四个字节的 16 进制数`0x12345678`，决定其大小的最重要的字节是“12”，最不重要的是“78”。

小端字节序将最不重要的字节排在前面，储存顺序就是`78563412`；

大端字节序则完全相反，将最重要的字节排在前面，储存顺序就是`12345678`。



目前，所有个人电脑几乎都是小端字节序，所以` TypedArray` 数组内部也采用小端字节序读写数据，或者更准确的说，按照本机操作系统设定的字节序读写数据。因此，如果一段数据是大端字节序，`TypedArray` 数组将无法正确解析，因为它只能处理小端字节序！

为了解决这个问题，JavaScript 引入`DataView`对象，可以设定字节序。

下面是一个例子。

```js
// 假定某段buffer包含如下字节 [0x02, 0x01, 0x03, 0x07]
const buffer = new ArrayBuffer(4);
const v1 = new Uint8Array(buffer);
v1[0] = 2;
v1[1] = 1;
v1[2] = 3;
v1[3] = 7;

const uInt16View = new Uint16Array(buffer);

// 计算机采用小端字节序
// 所以头两个字节等于258
// 头两个字节：[01000000, 10000000] = 2^8 + 2 = 256 + 2 = 258
if (uInt16View[0] === 258) {
  console.log('OK'); // "OK"
}

// 赋值运算
uInt16View[0] = 255;    // 字节变为[0xFF, 0x00, 0x03, 0x07]
uInt16View[0] = 0xff05; // 字节变为[0x05, 0xFF, 0x03, 0x07]
uInt16View[1] = 0x0210; // 字节变为[0x05, 0xFF, 0x10, 0x02]
```



### 复合视图

由于视图的构造函数可以指定起始位置和长度，所以在同一段内存之中，可以依次存放不同类型的数据，这叫做“复合视图”。

```js
const buffer = new ArrayBuffer(24);

const idView = new Uint32Array(buffer, 0, 1);
const usernameView = new Uint8Array(buffer, 4, 16);
const amountDueView = new Float32Array(buffer, 20, 1);
```

上面代码将一个 24 字节长度的ArrayBuffer对象，分成三个部分：

字节 0 到字节 3：1 个 32 位无符号整数
字节 4 到字节 19：16 个 8 位整数
字节 20 到字节 23：1 个 32 位浮点数



这种数据结构可以用如下的 C 语言描述:

```C
struct someStruct {
  unsigned long id;
  char username[16];
  float amountDue;
};

```



## DataView视图

如果一段数据包括多种类型（比如服务器传来的 HTTP 数据），这时除了建立ArrayBuffer对象的复合视图以外，还可以通过DataView视图进行操作。

### 设计目的

DataView视图提供更多操作选项，而且支持设定字节序。

本来，在设计目的上，ArrayBuffer对象的各种TypedArray视图，是用来向网卡、声卡之类的**本机设备**传送数据，所以使用本机的字节序就可以了；

而**DataView视图的设计目的，是用来处理网络设备传来的数据**，所以大端字节序或小端字节序是可以自行设定的。

DataView视图本身也是构造函数，接受一个ArrayBuffer对象作为参数，生成视图。



### 和TypedArray区别

- 对于TypedArray，构造器决定了其格式。整个数组应该是统一的。第 i 个数字是 arr[i]。
- 对于DataView，我们可以使用 .getUint8(i) 或 .getUint16(i) 之类的方法访问数据。我们在调用方法时选择格式，而不是在构造的时候。



### 构造函数

```js
new DataView(buffer, [byteOffset], [byteLength])
```

### 读写内存

`DataView`实例提供 8 个方法读取内存。

- **`getInt8`**：读取 1 个字节，返回一个 8 位整数。
- **`getUint8`**：读取 1 个字节，返回一个无符号的 8 位整数。
- **`getInt16`**：读取 2 个字节，返回一个 16 位整数。
- **`getUint16`**：读取 2 个字节，返回一个无符号的 16 位整数。
- **`getInt32`**：读取 4 个字节，返回一个 32 位整数。
- **`getUint32`**：读取 4 个字节，返回一个无符号的 32 位整数。
- **`getFloat32`**：读取 4 个字节，返回一个 32 位浮点数。
- **`getFloat64`**：读取 8 个字节，返回一个 64 位浮点数。



这一系列`get`方法的参数都是一个字节序号（不能是负数，否则会报错），表示从哪个字节开始读取。

```javascript
const buffer = new ArrayBuffer(24);
const dv = new DataView(buffer);

// 从第1个字节读取一个8位无符号整数
const v1 = dv.getUint8(0);

// 从第2个字节读取一个16位无符号整数
const v2 = dv.getUint16(1);

// 从第4个字节读取一个16位无符号整数
const v3 = dv.getUint16(3);
```


e.g.

```js
// 4 个字节的二进制数组，每个都是最大值 255
let buffer = new Uint8Array([255, 255, 255, 255]).buffer;

let dataView = new DataView(buffer);

// 在偏移量为 0 处获取 8 位数字
console.log(dataView.getUint8(0)); // 255

// 现在在偏移量为 0 处获取 16 位数字，它由 2 个字节组成，一起解析为 65535
console.log(dataView.getUint16(0)); // 65535（最大的 16 位无符号整数）

// 在偏移量为 0 处获取 32 位数字
console.log(dataView.getUint32(0)); // 4294967295（最大的 32 位无符号整数）

dataView.setUint32(0, 0); // 将 4 个字节的数字设为 0，即将所有字节都设为 0
```



DataView 视图提供 8 个方法写入内存。

- **`setInt8`**：写入 1 个字节的 8 位整数。
- **`setUint8`**：写入 1 个字节的 8 位无符号整数。
- **`setInt16`**：写入 2 个字节的 16 位整数。
- **`setUint16`**：写入 2 个字节的 16 位无符号整数。
- **`setInt32`**：写入 4 个字节的 32 位整数。
- **`setUint32`**：写入 4 个字节的 32 位无符号整数。
- **`setFloat32`**：写入 4 个字节的 32 位浮点数。
- **`setFloat64`**：写入 8 个字节的 64 位浮点数。

这一系列`set`方法，接受两个参数，第一个参数是字节序号，表示从哪个字节开始写入，第二个参数为写入的数据。对于那些写入两个或两个以上字节的方法，需要指定第三个参数，`false`或者`undefined`表示使用大端字节序写入，`true`表示使用小端字节序写入。

```js
// 在第1个字节，以大端字节序写入值为25的32位整数
dv.setInt32(0, 25, false);

// 在第5个字节，以大端字节序写入值为25的32位整数
dv.setInt32(4, 25);

// 在第9个字节，以小端字节序写入值为2.5的32位浮点数
dv.setFloat32(8, 2.5, true);
```



## SharedArrayBuffer

ES2017 引入SharedArrayBuffer，允许 Worker 线程与主线程共享同一块内存。

SharedArrayBuffer的 API 与ArrayBuffer一模一样，唯一的区别是后者无法共享数据。



### Atomics 对象

多线程共享内存，最大的问题就是如何防止两个线程同时修改某个地址，或者说，当一个线程修改共享内存以后，必须有一个机制让其他线程同步。

SharedArrayBuffer API 提供`Atomics`对象，保证所有共享内存的操作都是“原子性”的，并且可以在所有线程内同步。



## 总结

简单说，ArrayBuffer对象代表原始的二进制数据，TypedArray视图用来读写简单类型的二进制数据，DataView视图用来读写复杂类型的二进制数据。



## Dive Deeper - V8数组优化



### JS中的数字类型

JS中采用的是IEEE754双精度浮点表示法来表示数字，但在V8层面真的如此吗？

显然，在操作数字时，位数越多，效率越低，而我们在编程时用到的数字大部分都是32位就可以表示的数字。因此，V8引擎做了以下优化：

> ECMAScript 标准约定number数字需要被当成 64 位双精度浮点数处理，但事实上，一直使用 64 位去存储任何数字实际是非常低效的，所以 JavaScript 引擎并不总会使用 64 位去存储数字，引擎在内部采用其他内存表示方式（如 32 位），只要保证数字外部所有能被监测到的特性对齐 64 位的表现就行。



V8引擎对数字做了`Smi`和`HeapNumber`的区分（引擎层面，非语言层面）。

```js
//32位平台是 2的30次方
//64位平台是 2的31次方
 -Infinity // HeapNumber
-(2**30)-1 // HeapNumber
  -(2**30) // Smi
       -42 // Smi
        -0 // HeapNumber
         0 // Smi
       4.2 // HeapNumber
        42 // Smi
   2**30-1 // Smi
     2**30 // HeapNumber
  Infinity // HeapNumber
       NaN // HeapNumber
```

**可以从上面看出，`Smi`代表的是`小整数`,而`HeapNumber`则代表了一些浮点数以及无法用32位表示的数，比如`NaN,Infinity,-0`**



**为什么要区分这两种？**
原因还是之前说的，因为小整数在我们的编码过程中太常见了，所以，V8专门把它拎出来，并且对其进行了优化操作，它可以进行**快速整型操作**。



### V8的优化思路

如图，我们声明了一个对象，`o.x`是一个`Smi`值，而`o.y`是一个`HeapNumber`，v8给`HeapNumber`专门分配了一个内存对象来存储值，并将`o.y`的对象指针指向该内存实体。


![](/images/2021-03-30-Javascript中的二进制对象/v8-optmize1.png)

当我们更新他们的值的时候，`Smi`的值会原地更新，而`HeapNumber`由于它`不可变`的特性，V8会开辟一个新的内存实体用来储存新的值，然后将`o.y`的对象指针指向该内存实体。

![](/images/2021-03-30-Javascript中的二进制对象/v8-optmize2.png)

如果我们需要频繁更新`HeapNumber`的值，执行效率会比`Smi`慢得多：
在这个短暂的循环中，引擎不得不创建 6 个`HeapNumber`实例，`0.1`、`1.1`、`2.1`、`3.1`、`4.1`、`5.1`，而等到循环结束，其中 5 个实例都会成为垃圾。

![](/images/2021-03-30-Javascript中的二进制对象/v8-optmize3.png)

为了防止这个问题，V8 提供了一种优化方式去原地更新非`Smi`的值：**当一个数字内存区域拥有一个非`Smi`范围内的数值时，V8 会将这块区域标志为`Double`区域，并会为其分配一个用 64 位浮点表示的`MutableHeapNumber`实例。**

![](/images/2021-03-30-Javascript中的二进制对象/v8-optmize4.png)

此后当你再次更新这块区域，V8 就不再需要创建一个新的`HeapNumber`实例，而可以直接在`MutableNumber`实例中进行更新了。

![](/images/2021-03-30-Javascript中的二进制对象/v8-optmize5.png)

前面说到，`HeapNumber`和`MutableNumber`都是使用指针引用的方式指向内存实体，而`MutableNumber`是可变的，如果此时你将属于`MutableNumber`的值`o.x`赋值给其他变量`y`，你一定不希望你下次改变`o.x`时，`y`也跟着改变。 为了防止这种情况，当`o.x`被共享时，`o.x`内的`MutableHeapNumber`需要被重新封装成`HeapNumber`传递给`y`：

![](/images/2021-03-30-Javascript中的二进制对象/v8-optmize6.png)



### V8对数字数组的优化

在 V8 中，如果属性名是数字（最常见的形式是 `Array` 构造函数生成的对象）会被特殊处理。尽管在许多情况下，这些数字索引属性的行为与其他属性一样，V8 选择将它们与非数字属性分开存储以进行优化。在引擎内部，V8 甚至给这些属性一个特殊的名称：**元素**。

```
const array = [1, 2, 3];
```

如果你使用 `typeof` 操作符，它会告诉你数组包含 `number`。在语言层面，这就是你所得到的：JavaScript 不区分整数，浮点数和双精度 - 它们只是数字。然而，在引擎级别，我们可以做出更精确的区分。这个数组的元素是 `PACKED_SMI_ELEMENTS`，而这个`SMI`就是我们刚刚所说的小整数。

我们可以这个数组中添加一个浮点数将其转换为更通用的元素类型，这里并不叫`HeapNumber`而是`Double`，但是我们知道v8确实是把小整数和浮点数分开进行优化处理的。

```
const array = [1, 2, 3];
// 元素类型: PACKED_SMI_ELEMENTS
array.push(4.56);
// 元素类型: PACKED_DOUBLE_ELEMENTS
array.push('x');
// 元素类型: PACKED_ELEMENTS
```

这里重要的一点是，元素种类转换只能从一个方向进行：**从特定的（例如 `PACKED_SMI_ELEMENTS`）到更一般的（例如 `PACKED_ELEMENTS`）**。例如，一旦数组被标记为 `PACKED_ELEMENTS`，它就不能回到 `PACKED_DOUBLE_ELEMENTS`。



除了区分`SMI_ELEMENTS`、`DOUBLE_ELEMENTS`和`ELEMENTS`之外，V8还区分了密集数组 `PACKED` 和稀疏数组 `HOLEY`。原因同样是密集数组比稀疏数组更容易进行优化。

```
const array = [1, 2, 3, 4.56, 'x'];
// 元素类型: PACKED_ELEMENTS
array.length; // 5
array[9] = 1; // array[5] until array[8] are now holes
// 元素类型: HOLEY_ELEMENTS
```



### 元素种类的过渡方向

![](/images/2021-03-30-Javascript中的二进制对象/v8-optmize7.png)

**一般来说，更具体的元素种类可以进行更细粒度的优化。元素类型的在格子中越是向下，该对象的操作越慢。为了获得最佳性能，请避免不必要的不具体类型 - 坚持使用符合您情况的最具体的类型**。



### 实践中的代码优化思路

1. 避免创建洞

   ```js
   // DO NOT
   const array = new Array(3);
   array[0] = 'a';
   array[1] = 'b';
   array[2] = 'c';
   
   // DO
   let array = []
   array.push(newElement)
   // OR
   let array = [1,2,3,4,5]
   ```

2. 避免元素种类转换

   ```js
   // DO NOT
   const array = [3, 2, 1, +0];
   array.push(-0);
   ```

3. 避免多态

   ```js
   const each = (array, callback) => {
     for (let index = 0; index < array.length; ++index) {
       const item = array[index];
       callback(item);
     }
   };
   const doSomething = (item) => console.log(item);
   
   
   each([1, 2, 3], doSomething);
   each([1.1, 2.2, 3.3], doSomething);
   each(['a', 'b', 'c'], doSomething);
   ```

   这里调用了`each`3次，并且每次都没有给它相同的元素类型。

   **在V8中，它采用内联缓存（Inline Caches，简称 IC）来缓存调用的实现以优化这些操作的执行过程。**
   当我们第一次只传入类型为`packed_smi_element`的`[1,2,3]`，v8会使用`IC`来缓存这个方法的调用，记录元素类型以及其他信息，那么我们下一次传入`packed_smi_element`时，直接就可以从缓存里取到优化后的调用方法，然后进行调用。
   但是我们第二次如果传入的不一样的元素类型，比如`packed_double_number`，那么v8又会重新缓存一个新的调用实现（适用于`packed_double_number`），那么我们传入元素的时候就需要进行2次判断了，先判断是不是`smi`，如果不是，就判断是不是`packed_double_number`，如果是其他，那么又会重新缓存一个新的调用实现...

4. 类数组对象

   类数组对象（如auguments，Dom）类似于数组，都有这数字属性和lenth属性，而且我们也可以通过`call,apply`的方式来让类数组对象使用数组方法。

   **但是，这比在真正的数组中调用数组方法慢，数组的方法在 V8 中是高度优化的。**

   所以，如果你打算对类数组对象进行操作，请先将其转换为数组对象。

   ```js
   Array.from(arrayLike)
   
   Array.prototype.slice.call(arrayLike,0)
   ```

更深入的Chrome源码分析请看：

[从Chrome源码看JS Array的实现](https://zhuanlan.zhihu.com/p/26388217)



## 参考资料

[ArrayBuffer - ruanyifeng](https://es6.ruanyifeng.com/#docs/arraybuffer)

[你可能不知道的V8数组优化](https://segmentfault.com/a/1190000023193375)

[The story of a V8 performance cliff in React](https://v8.dev/blog/react-cliff)





