# LeetCode刷题

### 206 反转链表

问题：https://leetcode-cn.com/problems/reverse-linked-list/description/

解：

```javascript
/**
 * Definition for singly-linked list.
 * function ListNode(val, next) {
 *     this.val = (val===undefined ? 0 : val)
 *     this.next = (next===undefined ? null : next)
 * }
 */
/**
 * @param {ListNode} head
 * @return {ListNode}
 */
var reverseList = function(head) {
  let cur = head
  let prev = null
  while (cur !== null) {
    let next = cur.next
    cur.next = prev
    prev = cur
    cur = next
  }
  return prev
};
```



### 24 两两交换链表中的节点

问题：https://leetcode-cn.com/problems/swap-nodes-in-pairs/description/

解：

```javascript
/**
 * Definition for singly-linked list.
 * function ListNode(val, next) {
 *     this.val = (val===undefined ? 0 : val)
 *     this.next = (next===undefined ? null : next)
 * }
 */
/**
 * @param {ListNode} head
 * @return {ListNode}
 */
var swapPairs = function(head) {
  // 还不知道dummyHead的时候写的版本
  // let cur = head, prev = null
  // while (cur !== null && cur.next !== null) {
  //   if (prev === null) {
  //     head = cur.next
  //   } else {
  //     prev.next = cur.next
  //   }
  //   prev = cur
  //   let temp = cur.next.next
  //   cur.next.next = cur
  //   cur.next = temp
  //   cur = temp
  // }
  // return head
  
  // dummyHead
  const dummyHead = new ListNode()
  let cur = head, prev = dummyHead
  dummyHead.next = head
  while (cur !== null && cur.next !== null) {
    prev.next = cur.next
    prev = cur
    const temp = cur.next.next
    cur.next.next = cur
    cur.next = temp
    cur = temp
  }
  return dummyHead.next
};
```



### 141 环形链表

问题：https://leetcode-cn.com/problems/linked-list-cycle/

解：

```javascript
/**
 * @param {ListNode} head
 * @return {boolean}
 */

// 1. 使用Set，时间复杂度O(n)，空间复杂度O(n)
var hasCycle = function(head) {
  const set = new Map()
  let cur = head
  while (cur !== null) {
    if (set.has(cur)) {
      return true
    }
    set.add(cur)
    cur = cur.next
  }
  return false
};

// 2. 快慢指针 - 快慢相遇，则存在环
// 时间复杂度O(n), 空间复杂度O(1)
var hasCycle = function(head) {
  let slow = head, fast = head
  while (slow && fast && fast.next) {
    slow = slow.next
    fast = fast.next.next
    if (slow === fast) return true
  }
  return false
};
```



### 142 环形链表2

题目：https://leetcode-cn.com/problems/linked-list-cycle-ii/

解：

```javascript
// 1. 使用Set，与141相同，此处略过。
// 2. 快慢指针，类似141.
```



### 25 K个一组反转链表

题目：https://leetcode-cn.com/problems/reverse-nodes-in-k-group/



### 20 有效的括号

