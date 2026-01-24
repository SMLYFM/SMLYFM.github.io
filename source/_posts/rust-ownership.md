---
title: Rust所有权系统详解
date: 2026-01-25 01:27:00
updated: 2026-01-25 01:27:00
categories:
  - rust
tags:
  - Rust
  - 内存安全
  - 所有权
highlight_shrink: false
---

## 简介

Rust 的所有权系统是其最独特的特性，它使 Rust 能够在没有垃圾回收的情况下保证内存安全。

<!-- more -->

## 所有权规则

Rust 的所有权规则：

1. 每个值都有一个**所有者**（owner）
2. 同一时刻只能有一个所有者
3. 当所有者离开作用域时，值会被丢弃

## 代码示例

```rust
fn main() {
    // 💡 s 拥有这个 String
    let s = String::from("hello");
    
    // 💡 所有权转移给 s2
    let s2 = s;
    
    // ❌ 编译错误：s 已经无效
    // println!("{}", s);
    
    // ✅ 只有 s2 可以使用
    println!("{}", s2);
}
```

## 借用与引用

```rust
fn calculate_length(s: &String) -> usize {
    // 💡 只借用，不获取所有权
    s.len()
}

fn main() {
    let s = String::from("hello");
    let len = calculate_length(&s);
    // ✅ s 仍然有效
    println!("Length of '{}' is {}", s, len);
}
```

## 可变引用

```rust
fn main() {
    let mut s = String::from("hello");
    
    // 💡 可变引用
    change(&mut s);
    
    println!("{}", s); // 输出 "hello, world"
}

fn change(s: &mut String) {
    s.push_str(", world");
}
```

## 总结

所有权系统是 Rust 的核心特性，理解它对于编写安全高效的 Rust 代码至关重要。

## 参考资料

- [The Rust Programming Language](https://doc.rust-lang.org/book/)
