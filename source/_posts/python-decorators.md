---
title: Python装饰器深入理解
date: 2026-01-25 01:27:00
updated: 2026-01-25 01:27:00
categories:
  - 编程语言
  - Python
tags:
  - Python
  - 装饰器
  - 函数式编程
highlight_shrink: false
---

## 简介

装饰器是 Python 中强大而优雅的特性，它允许你在不修改原函数代码的情况下扩展函数的功能。

<!-- more -->

## 基本概念

装饰器本质上是一个接受函数并返回新函数的高阶函数。

```python
def my_decorator(func):
    def wrapper(*args, **kwargs):
        print("函数调用前")
        result = func(*args, **kwargs)
        print("函数调用后")
        return result
    return wrapper

@my_decorator
def say_hello(name):
    print(f"Hello, {name}!")

say_hello("World")
```

## 带参数的装饰器

```python
def repeat(times):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for _ in range(times):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(3)
def greet(name):
    print(f"Hi, {name}!")

greet("Python")  # 输出 3 次
```

## 保留原函数信息

使用 `functools.wraps` 保留原函数的元信息：

```python
from functools import wraps

def my_decorator(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper
```

## 类装饰器

```python
class CountCalls:
    def __init__(self, func):
        self.func = func
        self.count = 0
    
    def __call__(self, *args, **kwargs):
        self.count += 1
        print(f"调用次数: {self.count}")
        return self.func(*args, **kwargs)

@CountCalls
def say_hello():
    print("Hello!")
```

## 总结

装饰器是 Python 中实现 AOP（面向切面编程）的重要工具。

## 参考资料

- [Python 官方文档 - 装饰器](https://docs.python.org/3/glossary.html#term-decorator)
