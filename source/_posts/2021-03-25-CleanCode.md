---
layout: post
categories: posts
title: Clean Code阅读笔记
date: MARCH 25, 2021
excerpt: 代码简洁之道
tags: [engineering, booknote]
---

# Clean Code阅读笔记



## 为什么要写简洁代码？

### 1.3 混乱的代价

你当然曾为糟糕的代码所困扰过。那么——为什么要写糟糕的代码呢？是想快点完成吗？是要赶时间吗？有可能。或许你觉得自己要干好所需的时间不够；假使花时间清理代码，老板就会大发雷霆。或许你只是不耐烦再搞这套程序，期望早点结束。或许你看了看自己承诺要做的其他事，意识到得赶紧弄完手上的东西，好接着做下一件工作。这种事我们都干过。

我们都曾经瞟一眼自己亲手造成的混乱，决定弃之而不顾，走向新一天。我们都曾经看到自己的烂程序居然能运行，然后断言能运行的烂程序总比什么都没有强。我们都曾经说过有朝一日再回头清理。当然，在那些日子里，我们都没听过**勒布朗（LeBlanc）法则：稍后等于永不（Later equals never）**。

混乱的代价只要你干过两三年编程，就有可能曾被某人的糟糕的代码绊倒过。如果你编程不止两三年，也有可能被这种代码拖过后腿。进度延缓的程度会很严重。有些团队在项目初期进展迅速，但有那么一两年的时间却慢如蜗行。对代码的每次修改都影响到其他两三处代码。修改无小事。每次添加或修改代码，都得对那堆扭纹柴了然于心，这样才能往上扔更多的扭纹柴。这团乱麻越来越大，再也无法理清，最后束手无策。随着混乱的增加，团队生产力也持续下降，趋向于零。当生产力下降时，管理层就只有一件事可做了：增加更多人手到项目中，期望提升生产力。可是新人并不熟悉系统的设计。他们搞不清楚什么样的修改符合设计意图，什么样的修改违背设计意图。而且，他们以及团队中的其他人都背负着提升生产力的可怕压力。于是，他们制造更多的混乱，驱动生产力向零那端不断下降。如图11所示。

<img src="https://tva1.sinaimg.cn/large/008eGmZEgy1gpaem2m0cij30wg0g6aep.jpg" style="zoom:50%;" />

程序员面临着一种基础价值谜题。有那么几年经验的开发者都知道，之前的混乱拖了自己的后腿。但开发者们背负期限的压力，只好制造混乱。简言之，他们没花时间让自己做得更快！真正的专业人士明白，这道谜题的第二部分说错了。制造混乱无助于赶上期限。混乱只会立刻拖慢你，叫你错过期限。**赶上期限的唯一方法——做得快的唯一方法——就是始终尽可能保持代码整洁。**



### How？

假设你相信混乱的代码是祸首，假设你接受做得快的唯一方法是保持代码整洁的说法，你一定会自问：“我怎么才能写出整洁的代码？”不过，如果你不明白整洁对代码有何意义，尝试去写整洁代码就毫无所益！坏消息是写整洁代码很像是绘画。多数人都知道一幅画是好还是坏。但能分辨优劣并不表示懂得绘画。能分辨整洁代码和肮脏代码，也不意味着会写整洁代码！写整洁代码，需要遵循大量的小技巧，贯彻刻苦习得的“整洁感”。这种“代码感”就是关键所在。有些人生而有之。有些人费点劲才能得到。它不仅让我们看到代码的优劣，还予我们以借戒规之力化劣为优的攻略。



## 命名

### 名副其实

```javascript
// e.g.
function getItem () {
	return this.list.filter(i => i.status === 0)
}

// 1. this.list 是什么？
// 2. getItem 的目的是什么？/ status为0的含义是什么？

const auditStatus = {
  AUDIT_PASS: 0,
  AUDIT_INVALID: 1,
  AUDIT_UNKNOWN: 2
}

function getAuditPassFiles () {
	return this.fileList.filter(i => i.status === auditStatus.AUDIT_PASS)
}
```

只要简单改一下名称，就能轻易知道发生了什么。这就是选用好名称的力量。



### 避免误导

```javascript
const accountList = { // accountArray 
  '12345678':  { username: 'aaa', mobile: '138****8888'}
}
// List?
// List 一词对程序员有特殊意义，如果包纳账号的容器不是真的 list，会引起误会。
// 只叫 accounts 都比脚 accountList 好

const accounts = {
  '12345678':  { username: 'aaa', mobile: '138****8888'}
}
```



### 做有意义的区分

```javascript
function copyFile (a1, a2) { ... } // bad
function copyFile (source, destination) { ... } // good
function copyFile (from, to) { ... } // good

// 这样的名称纯属误导——完全没有提供正确信息；没有提供导向作者意图的线索。

// 废话是另一种没意义的区分。
function getActiveAccount();
function getActiveAccounts();
function getActiveAccountInfo();
function getActiveAccountObject();

// 如果缺少明确约定，变量moneyAmount就与money没区别，customerInfo与customer没区别，accountData与account没区别，theMessage也与message没区别。要区分名称，就要以读者能鉴别不同之处的方式来区分。
// 明确是王道。

```



### 使用读得出来的名字

```javascript
function genymdhms () { ... } // bad
function modymdhms () { ... } // bad

function generationTimestamp () { ... } // good
function modificationTimestamp () { ... } // good

```



### 使用可搜索的名称

```javascript
// 搜索200 - 困难
// 搜索 PLATIUM_VOLUME - 容易
const PLATIUM_VOLUME = 200
const BYTES_IN_GB = 1 * 1024 * 1024 * 1024
const BYTES_IN_MB = 1 * 1024 * 1024

// 单字母名称仅用于短方法中的本地变量。名称长短应与其作用域大小相对应。
// 若变量或常量可能在代码中多处使用，则应赋其以便于搜索的名称。

```



### 每个概念对应一个词

```
task / task ?
localTask / driveTask ?

```



### 使用解决方案领域名称

```javascript
const jobQueue // FIFO
const tokenStack // FILO
```



### 添加有意义的语境

设想你有名为firstName、lastName、street、houseNumber、city、state和zipcode的变量。当它们搁一块儿的时候，很明确是构成了一个地址。不过，假使只是在某个方法中看见孤零零一个state变量呢？你会理所当然推断那是某个地址的一部分吗？



可以添加前缀addrFirstName、addrLastName、addrState等，以此提供语境。至少，读者会明白这些变量是某个更大结构的一部分。当然，更好的方案是创建名为Address的类。



### 不要添加无意义的语境

```
// movie.xunlei.com
XlMovie.vue
XlChange.vue
XlDialog.vue
```

只要短名称足够清楚，就要比长名称好。别给名称添加不必要的语境。



### 最后的话

我们有时会怕其他开发者反对重命名。如果讨论一下就知道，如果名称改得更好，那大家真的会感激你。多数时候我们并不记忆类名和方法名。我们使用现代工具对付这些细节，好让自己集中精力于把代码写得就像词句篇章、至少像是表和数据结构（词句并非总是呈现数据的最佳手段）。



## 函数

怎么才能让函数表达其意图？该给函数赋予哪些属性，好让读者一看就明白函数是属于怎样的程序？



### 短小

函数的第一规则是要短小。第二条规则是还要更短小。

### 只做一件事

函数应该做一件事。做好这件事。只做这一件事。

要判断函数是否不止做了一件事，还有一个方法，就是看是否能再拆出一个函数，该函数不仅只是单纯地重新诠释其实现。

 

### 每个函数一个抽象层级 

要确保函数只做一件事，函数中的语句都要在同一抽象层级上。



### 无副作用

副作用是一种谎言。函数承诺只做一件事，但还是会做其他被藏起来的事。有时，它会对自己类中的变量做出未能预期的改动。有时，它会把变量搞成向函数传递的参数或是系统全局变量。无论哪种情况，都是具有破坏性的，会导致古怪的时序性耦合及顺序依赖。



### 不要重复自己

重复会导致问题，因为代码因此而臃肿，且当算法改变时需要修改4处地方。而且也会增加4次放过错误的可能性。

重复可能是软件中一切邪恶的根源。许多原则与实践规则都是为控制与消除重复而创建。例如，全部考德（Codd）[14]数据库范式都是为消灭数据重复而服务。再想想看，面向对象编程是如何将代码集中到基类，从而避免了冗余。面向方面编程（AspectOrientedProgramming）、面向组件编程（ComponentOrientedProgramming）多少也都是消除重复的一种策略。看来，自子程序发明以来，软件开发领域的所有创新都是在不断尝试从源代码中消灭重复。



```typescript
// 例子：PC端云盘的播放函数
async play (mode: VideoPlayMode, file: IMediaFiles, playfrom: string, dlna?: boolean): Promise<void> {
    if (this.$store.state['media-player'].isPlayButtonDisabled) {
      return
    }
    if (file.trashed) {
      this.$emit('restore', { fromPlay: true })
      return
    }
    if (this.checkIsLinkExpired(file)) {
      log.info('REFRESH video link')
      await this.initData()
      file = this.fileDetail
    }
    if ((this.isCloudAdding || this.isLocalUploading) && (!Array.isArray(file.medias) || !(file.medias.length > 0))) {
      this.$eventTrack('yunpan_play_fail_toast', { type: 'adding' })
      this.$message({
        message: '云播失败，请稍后重试',
        id: 'pending_task',
        unique: true,
        type: 'error',
        position: 'middle',
        duration: 2000
      })
      return
    }
    if (file.web_content_link) {
      try {
        if (this.cancelableRetry !== null) { // 已有解冻任务则先取消再开始下一个
          this.cancelRetry()
        }
        await this.checkIsFreezed(mode, file.web_content_link, Number(file.size))
      } catch (error) {
        if (error.message === 'cancel') {
          console.warn('cancel')
          return
        }
        this.$message({
          message: '该视频读取时间长，请稍后再看',
          type: 'error',
          position: 'middle',
          duration: 5000
        })
      }
    }
    if (!file.web_content_link) {
      if (this.isLocalUploading) {
        this.$eventTrack('yunpan_play_fail_toast', { type: 'upload' })
      }
      this.$message({
        message: '该文件暂时无法播放',
        id: 'no link',
        unique: true,
        type: 'error',
        position: 'middle',
        duration: 2000
      })
      return
    }
    try {
      this.$store.commit('media-player/setIsPlayButtonDisabled', true)
      log.info('play file:', file.name, mode)
      const element = document.getElementById('pan-preview')
      if (element) {
        const rect = element.getBoundingClientRect()
        log.info('dlna', dlna)
        updateXmpPosition(rect)
      }
      if (!file.changeRect) {
        await playWithXmp(
          {
            playUrl: file.web_content_link,
            fileName: file.name || '',
            isEmbed: mode !== 'independent',
            openFrom: 'ThunderPanPlugin',
            panFileId: file.id,
            gcid: file.hash,
            medias: file.medias,
            dlnaPlay: dlna,
            playType: 'server_xlpan',
            playFrom: playfrom,
            mimeType: file.mime_type
          })
        this.$store.commit('media-player/setIsPlayButtonDisabled', false)
        window.addEventListener('resize', this.onResize.bind(this))
      }
    } catch (err) {
      this.$store.commit('media-player/setIsPlayButtonDisabled', false)
      log.error(err)
      this.$message({
        message: '播放失败',
        type: 'error',
        position: 'middle',
        duration: 3000
      })
    }
  }
```

## 注释

### 注释不能美化糟糕的代码

写注释的常见动机之一是糟糕的代码的存在。我们编写一个模块，发现它令人困扰、乱七八糟。我们知道，它烂透了。我们告诉自己：“喔，最好写点注释！”不！最好是把代码弄干净！带有少量注释的整洁而有表达力的代码，要比带有大量注释的零碎而复杂的代码像样得多。与其花时间编写解释你搞出的糟糕的代码的注释，不如花时间清洁那堆糟糕的代码。



### 用代码来阐述

有时，代码本身不足以解释其行为。不幸的是，许多程序员据此以为代码很少——如果有的话——能做好解释工作。这种观点纯属错误。你愿意看到这个：

```java
// Check to see if the employee is eligible for full benefits
if((employee.flags&HOURLY_FLAG) && (employee.age>65))
```

还是这个？

```java
if(employee.isEligibleForFullBenefits())
```

只要想上那么几秒钟，就能用代码解释你大部分的意图。很多时候，简单到只需要创建一个描述与注释所言同一事物的函数即可。




### 好注释

- 提供基本信息的注释

- 对意图的解释

  - 注释不仅提供了有关实现的有用信息，而且还提供了某个决定后面的意图。

- 阐释

  - 注释把某些晦涩难明的参数或返回值的意义翻译为某种可读形式，也会是有用的。

  ```typescript
  // fmt: MMddhhmmss 构成的格式字符串
  export function formatTime (
    dateObj: Date,
    fmt: string
  ) {
    type OType = {
      'M+': number;
      'd+': any;
      'h+': any;
      'm+': any;
      's+': any;
      'q+': number;
      S: any;
      [prop: string]: any;
    };
    const o: OType = {
      'M+': dateObj.getMonth() + 1, // 月份
      'd+': dateObj.getDate(), // 日
      'h+': dateObj.getHours(), // 小时
      'm+': dateObj.getMinutes(), // 分
      's+': dateObj.getSeconds(), // 秒
      'q+': Math.floor((dateObj.getMonth() + 3) / 3), // 季度
      S: dateObj.getMilliseconds() // 毫秒
    }
    if (/(y+)/.test(fmt)) {
      fmt = fmt.replace(
        RegExp.$1,
        (dateObj.getFullYear() + '').substr(4 - RegExp.$1.length)
      )
    }
    for (const k in o) {
      if (new RegExp('(' + k + ')').test(fmt)) {
        fmt = fmt.replace(
          RegExp.$1,
          RegExp.$1.length === 1
            ? o[k]
            : ('00' + o[k]).substr(String(o[k]).length)
        )
      }
    }
    return fmt
  }
  ```
  
- 警示

  ```javascript
      async getGlobalConfig () {
        /**
         * 此处天坑，注意！
         * 除了手雷搜索页以外，还有一个网盘SDK也用了本搜索页。
         * sdk的xlConfig会返回空，所以全局配置相关的属性访问都需要更严谨的合法判断。
         * 另外测试时最好把sdk的情况也过一下。
         */
        let [sniff, xlConfig] = await Promise.all([
          this.getSniff(),
          this.getXlConfig()
        ])
  
  ```

  

- 放大

  - 放大、解释某些不合理细节



### 坏注释

- 误导性注释

- 多余的注释 / 废话注释

  - ```javascript
    class Example {
    	/*　Defaultconstructor.*/
    	constructor () {
    		...
      }
    }
    
    ```

    

- 括号后面的注释

  - 有时，程序员会在括号后面放置特殊的注释。尽管这对于含有深度嵌套结构的长函数可能有意义，但只会给我们更愿意编写的短小、封装的函数带来混乱。如果你发现自己想标记右括号，其实应该做的是缩短函数。

- 注释掉的代码

- 归属与署名

  ```
  /* AddedbyRick　*/
  ```

	- 源代码控制系统非常善于记住是谁在何时添加了什么。没必要用那些小小的签名搞脏代码。你也许会认为，这种注释大概有助于他人了解应该和谁讨论这段代码。不过，事实却是注释在那儿放了一年又一年，越来越不准确，越来越和原作者没关系。重申一下，源代码控制系统是这类信息最好的归属地。