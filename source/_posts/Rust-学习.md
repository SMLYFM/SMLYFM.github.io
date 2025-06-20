---
title: Rust 学习
date: 2025-04-16 19:35:34
tags:
  - "学习rust"
---

# Rust学习之路

# 🦀 Rust 学习之路：第一天  
## —— 项目创建与编译指南（Linux & Windows 双平台详解）

---

## 🧩 一、安装 Rust 开发环境

### ✅ Linux/macOS 安装步骤  
1. **安装 `rustup` 工具链管理器**  
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```
   - 按提示输入 `1` 选择默认安装路径（通常为 `~/.cargo/bin`）。  
   - 加载环境变量：  
     ```bash
     source $HOME/.cargo/env
     ```

2. **验证安装**  
   ```bash
   rustc --version  # 查看 Rust 编译器版本
   cargo --version  # 查看 Cargo 包管理器版本
   ```

### ✅ Windows 安装步骤  
1. **下载官方安装程序**  
   访问 [Rust 安装页面](https://www.rust-lang.org/tools/install) 下载 `rustup-init.exe`。  
2. **运行安装程序**  
   - 选择默认选项（安装 `rustup` 和工具链）。  
   - 确保勾选 "Add Rust to PATH"（自动配置环境变量）。  

3. **验证安装**  
   在 **PowerShell 或 CMD** 中运行：  
   ```powershell
   rustc --version
   cargo --version
   ```

---

## 📁 二、创建你的第一个 Rust 项目

### 📌 方法 1：使用 Cargo 创建项目（推荐）  
Cargo 是 Rust 的包管理器和构建工具，自动化处理依赖管理和编译流程。

#### 🔧 Linux/macOS  
```bash
cargo new myproject
cd myproject
```

#### 🔧 Windows  
```powershell
cargo new myproject
cd myproject
```

#### 📁 生成的目录结构  
```
myproject/
├── Cargo.toml      # 项目配置文件（元数据、依赖）
└── src/
    └── main.rs     # 主程序文件（默认入口）
```

#### 📄 `main.rs` 默认内容  
```rust
fn main() {
    println!("Hello, world!");
}
```

---

## 🛠️ 三、编译与运行项目

### 🧪 方法 1：使用 Cargo 编译与运行（推荐）  
Cargo 提供了一站式命令，适合日常开发。

#### 🔧 Linux/macOS & Windows  
```bash
cargo build        # 编译项目（生成可执行文件在 target/debug/）
./target/debug/myproject  # 运行程序（Linux/macOS）
.\target\debug\myproject.exe  # 运行程序（Windows）
```

#### 🚀 一键运行  
```bash
cargo run          # 直接编译并运行（适合快速测试）
```

### 🧪 方法 2：手动使用 `rustc` 编译（仅限简单项目）  
适用于单文件项目，不涉及复杂依赖。

#### 🔧 Linux/macOS  
```bash
rustc src/main.rs -o myprogram
./myprogram
```

#### 🔧 Windows  
```powershell
rustc src\main.rs -o myprogram.exe
.\myprogram.exe
```

---

## 🧱 四、手动编译的局限性  
- **无法处理多文件项目**：复杂项目需依赖 Cargo 管理模块和依赖。  
- **无自动依赖管理**：需手动下载并链接库文件。  

---

## 🧰 五、常见问题与解决方案

| 问题                       | 解决方案                                                     |
| -------------------------- | ------------------------------------------------------------ |
| `command not found: rustc` | 确保 `~/.cargo/bin`（Linux）或 `C:\Users\用户名\.cargo\bin`（Windows）已加入系统 `PATH` 环境变量。 |
| `failed to download rustc` | 使用国内镜像加速：                                           |
  ```bash
  RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup cargo build
  ```
| `linker not found`（Windows） | 安装 C++ 构建工具：  
  下载 [Build Tools for Visual Studio](https://visualstudio.microsoft.com/visual-cpp-build-tools/) 并安装。 |
| `error[E0460]: found possibly newer version of crate 'std'` | 更新工具链：  
  ```bash
  rustup update
  ``` |

---

## 📝 六、小贴士

- **查看目录结构**（Linux/macOS）：  
  ```bash
  tree
  ```
- **使用代码编辑器打开项目**：  
  - VS Code：  
    ```bash
    code .
    ```
  - Vim/VSCode 内置终端直接运行命令。  
- **清理构建文件**：  
  ```bash
  cargo clean
  ```

---

## 📚 七、下一步学习建议

1. **深入学习 Cargo**：  
   - 添加依赖：修改 `Cargo.toml` 中的 `[dependencies]` 部分。  
   - 构建发布版本：`cargo build --release`（优化编译，生成在 `target/release/`）。  
2. **探索官方文档**：  
   - [Rust 中文社区](https://rustlang-cn.org/)  
   - [Rust By Example](https://doc.rust-lang.org/rust-by-example/)  
3. **实战练习**：  
   - [Rustlings](https://github.com/rust-lang/rustlings)：官方练习项目  
   - [Rust Cookbook](https://rust-lang-nursery.github.io/rust-cookbook/)：常见任务代码示例  

---

通过本指南，你已掌握：  
✅ Rust 的安装与验证  
✅ 使用 Cargo 创建和管理项目  
✅ Linux 和 Windows 下的编译与运行方法  
✅ 常见问题的排查技巧  

接下来，尝试编写一个包含变量、函数和控制流的小程序，巩固基础语法吧！
