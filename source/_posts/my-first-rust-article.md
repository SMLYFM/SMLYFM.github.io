---
title: My First Rust Article
date: 2023-10-01 17:01:30  # 修改为当前或过去日期
categories:
  - Computer-Science  # 父级分类（与菜单中的分类名称一致）
  - Rust             # 子分类（与菜单中的路径一致）
tags:
  - Rust
  - Programming
---



---

# 🦀 学习 Rust：从零开始的编程之旅  
## —— 安装指南 + 第一个程序 + 基础概念速览  

---

## 🧠 为什么选择 Rust？

Rust 是一门现代的系统级编程语言，专注于安全性、性能和并发。它通过独特的 **所有权（Ownership）** 和 **借用（Borrowing）** 机制，在编译期避免空指针、数据竞争等常见错误，同时保持接近 C/C++ 的性能。  
**适用场景**：  
- 系统编程（操作系统、驱动）  
- 区块链开发（Solana、Polkadot）  
- Web 后端（Actix、Rocket）  
- 嵌入式开发  

---

## 🚀 第一步：安装 Rust

### 📌 使用 `rustup` 安装（官方推荐）  
`rustup` 是 Rust 的官方工具链管理器，支持多平台安装和版本切换。

### ✅ Linux/macOS 安装步骤  
打开终端，运行以下命令：  
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
- 按提示输入 `1` 选择默认安装路径（通常为 `~/.cargo/bin`）。  
- 安装完成后，执行以下命令加载环境变量：  
  ```bash
  source $HOME/.cargo/env
  ```

### ✅ Windows 安装步骤  
1. 下载 [Rust 安装程序](https://www.rust-lang.org/tools/install)。  
2. 双击运行，选择默认选项（安装 `rustup` 和工具链）。  
3. 使用 **PowerShell** 或 **CMD** 验证安装。

### 🧪 验证安装  
运行以下命令检查 Rust 版本：  
```bash
rustc --version
# 输出示例：rustc 1.70.0 (example-hash 2023-06-29)
```
同时验证 `Cargo`（Rust 的包管理器）：  
```bash
cargo --version
# 输出示例：cargo 1.70.0 (example-hash 2023-06-29)
```

---

## 🧱 编写你的第一个 Rust 程序

### 📁 步骤 1：创建项目目录  
```bash
mkdir ~/rust-projects
cd ~/rust-projects
```

### 📄 步骤 2：编写代码  
创建文件 `main.rs`（Rust 的源码扩展名）：  
```bash
nano hello.rs  # 或使用 VS Code 等编辑器
```
粘贴以下代码：  
```rust
fn main() {
    println!("Hello, Rustaceans! 🦀");
}
```
保存并退出（`Ctrl+O` 写入，`Ctrl+X` 退出 Nano）。

### 🔨 步骤 3：编译并运行  
```bash
rustc hello.rs
./hello
# 输出：Hello, Rustaceans! 🦀
```

> 📝 **代码解析**  
> - `fn main()`：程序入口函数。  
> - `println!`：宏（macro），用于输出文本。  
> - `!` 表示这是一个宏调用，而非普通函数。

---

## 🧰 使用 Cargo 管理项目（推荐）

### 📌 创建新项目  
```bash
cargo new hello_cargo
cd hello_cargo
```
生成的目录结构：  
```
hello_cargo/
├── Cargo.toml      # 项目配置文件
└── src/
    └── main.rs     # 默认主程序文件
```

### 📦 构建并运行  
```bash
cargo build        # 编译（生成可执行文件在 target/debug/）
./target/debug/hello_cargo
# 输出：Hello, world!
```
或直接运行：  
```bash
cargo run
```

---

## 📚 基础概念速览

### 📌 变量与不可变性  
Rust 默认变量是不可变的（immutable），需显式使用 `mut` 声明可变变量：  
```rust
let x = 5;          // 不可变变量
let mut y = 10;     // 可变变量
y = 15;             // 合法
```

### 📌 数据类型  
- **标量类型**：整数（`i32`, `u64`）、浮点数（`f32`, `f64`）、布尔值（`bool`）、字符（`char`）。  
- **复合类型**：元组（`tuple`）、数组（`array`）。  

### 📌 控制流  
```rust
if y > 10 {
    println!("y is greater than 10");
} else {
    println!("y is 10 or less");
}

for number in 1..=5 {
    println!("{}", number);
}
```

---

## 📖 进阶学习资源推荐

1. **官方文档**：  
   - [The Rust Programming Language（中文版）](https://kaisery.github.io/trpl-zh-cn/)  
   - [Rust By Example](https://doc.rust-lang.org/rust-by-example/)  
2. **社区与论坛**：  
   - [Rust 中文社区](https://rustlang-cn.org/)  
   - [Rust 语言中文论坛](https://bbs.rustlang.org.cn/)  
3. **实战项目**：  
   - [Rustlings](https://github.com/rust-lang/rustlings)：官方练习项目  
   - [Rust Cookbook](https://rust-lang-nursery.github.io/rust-cookbook/)：常见任务代码示例  

---

## ⚠️ 常见问题与解决方案

| 问题                          | 解决方案                                                     |
| ----------------------------- | ------------------------------------------------------------ |
| `rustc` 或 `cargo` 命令未找到 | 确保 `~/.cargo/bin` 已加入 `PATH` 环境变量                   |
| 安装过程中网络超时            | 使用国内镜像（如中科大源）：`RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static` |
| 编译报错 `cannot find crate`  | 使用 `cargo build` 替代 `rustc`，依赖管理更简单              |
| 版本冲突                      | 更新工具链：`rustup update`                                  |

---

## 🎉 总结

通过本文，你已掌握：  
✅ Rust 的安装与验证  
✅ 编写并运行第一个程序  
✅ 使用 Cargo 管理项目  
✅ 基础语法速览  
下一步，尝试阅读《Rust 圣经》或参与开源项目，深入探索这门安全高效的现代语言吧！

如果遇到问题，欢迎在评论区留言，或前往 [Rust 中文社区](https://rustlang-cn.org/) 寻求帮助。祝你编程愉快！🦀
