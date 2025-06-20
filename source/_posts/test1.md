---
title: Bash 等终端美化
date: 2024-10-01 17:01:30  # 修改为当前或过去日期
categories:
  - Computer-Science  # 父级分类（与菜单中的分类名称一致）
  - Rust             # 子分类（与菜单中的路径一致）
tags:
  - Rust
  - Programming
---



s

测试网站：内容来自于[https://strider1230.cn](https://strider1230.cn) 

## 软件介绍

**Oh-My-Posh** 是一款终端个性化工具，支持 Windows、Linux(WSL)、macOS 系统上的 PowerShell、bash、zsh 等终端，可以配置不同主题达到个性化的效果。

## 软件特点

**平台和 Shell 无关**：可以在多种操作系统和终端环境中使用。

**易于配置**：用户可以根据需求轻松调整配置。

**极高的可配置性：**提供多种配置选项，比市面上大多数提示工具更加灵活。

**速度快**：兼顾性能，提高了使用体验。

**支持次级提示**：不仅限于主提示，还提供次级提示支持。

**右侧提示**：在终端界面中可以显示右侧提示。

**瞬态提示**：提供瞬态提示功能，让界面更简洁。

##  效果图

![](https://picx.zhimg.com/v2-0b67dfe3fb6bb374c4b2c8614162774f_1440w.jpg)

![](https://pic2.zhimg.com/v2-35cb58a2fb76a40d1c17ac17474702e5_1440w.jpg)

## 二、准备工作

### 2.1 包管理器——[Scoop](https://zhida.zhihu.com/search?content_id=254952184&content_type=Article&match_order=1&q=Scoop&zhida_source=entity)

**2.1.1 为何使用 Scoop 安装**

A：使用 Scoop 作为包管理器来安装开发工具，比如 `git`、`clink`，相比直接从微软商店安装或下载安装包，有几个明显的优势：

**更便捷的安装和更新**

-   Scoop 一行命令就能完成安装，既不需要手动下载安装包，也不必逐个步骤操作。安装完成后可以直接运行，更新时也同样简单，只需运行 `scoop update <package_name>` 即可完成。

**自动配置环境变量**

-   Scoop 会将所有已安装软件的快捷方式放在 `Scoop\shims` 文件夹中，并将该文件夹路径自动加入用户的环境变量 `PATH` 中。因此，安装完成后可以直接在终端中使用这些命令，而无需手动配置路径。

**轻量又优雅**

-   Scoop 将所有软件都集中在用户目录下管理，不会修改系统目录。这种优雅的管理方式避免了对系统的影响，也更易于管理和卸载。

简洁的依赖管理

-   Scoop 能自动安装软件的依赖项，避免了手动下载和配置的麻烦，极大简化了安装过程。

因此，使用 Scoop 不仅能简化安装和更新操作，还减少了配置环境变量的繁琐步骤，是一种方便又优雅的安装方式。

**2.1.2 安装 Scoop**

1\. 设置 PowerShell 执行策略

在安装 Scoop 之前，需允许 PowerShell 执行脚本。可以在 PowerShell 中执行以下命令：

```text
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser      
```

2\. 安装 Scoop

在 PowerShell 中运行以下命令：

```text
irm get.scoop.sh | iex
```

Scoop 安装完成后将自动配置环境变量。在本文中，我们将使用 Scoop 安装相关工具（包括 git 和 clink），使整个安装过程更加高效流畅。

![](https://pic3.zhimg.com/v2-8e7ec06257bf237844eed3b0d3af9c14_1440w.jpg)

确保 `scoop\shims` 路径已添加到环境变量中（正常情况下会自动添加）：

![](https://pic4.zhimg.com/v2-0b759a8257f9609b26e063d61c72e0ef_1440w.jpg)

> 关于 shims 文件夹：scoop 创建的 shims 文件夹用于存放所有已安装应用的快捷方式，使得在命令行中可以直接调用这些程序，而无需指定完整路径。

### 2.2 字体

为了在 oh-my-posh 中正确显示各类图标，我们需要安装支持 [Nerd Fonts](https://zhida.zhihu.com/search?content_id=254952184&content_type=Article&match_order=1&q=Nerd+Fonts&zhida_source=entity) 的字体。安装方法如下：

1\. 前往 Nerd Fonts 官方 GitHub 页面 或访问 Nerd Fonts 下载页面 下载 Meslo 或其他字体包；

2\. 解压下载的文件，并右键安装所有`.ttf`字体文件；

3.在 **[Windows Terminal](https://zhida.zhihu.com/search?content_id=254952184&content_type=Article&match_order=1&q=Windows+Terminal&zhida_source=entity)** 的设置中选择安装的 Nerd Fonts 字体（例如 MesloLGM NF），确保字体正常显示图标。

最后推荐使用`MesloLGM Nerd Font`字体，因为这个间距适中，连续两个回车换行后命令的显示不会挤在一起。

### 2.3 终端

推荐使用 **Windows Terminal** 作为默认终端。作为 Windows 11 自带的终端，它在多标签、个性化配置和多终端支持上表现得非常不错，完全能满足日常使用需求。

如果你使用的是 Windows 10 或LTSC(老坛酸菜)等精简版系统，可能没有预装 Windows Terminal，这种情况下，可以通过微软商店在线安装。

![](https://pic4.zhimg.com/v2-63219c372c8b2b286611ec2247498e8f_1440w.jpg)

**Win11 24H2 LTSC 版本没有微软商店怎么办**，以管理员模式打开 PowerShell，执行以下命令即可安装。

```text
wsreset -i
```

### 2.4 配置 Windows Terminal

找到 PowerShell 的外观设置

![](https://picx.zhimg.com/v2-a8528fa7a0d2b74a652f6cf615efa3fd_1440w.jpg)

设置文本样式。

![](https://picx.zhimg.com/v2-5f9ca6ef1dd3fd36f0dc7b24a0852e6b_1440w.jpg)

设置背景图，透明度等。

![](https://pic3.zhimg.com/v2-531ca464c2acf208e85b052fb4eb644a_1440w.jpg)

添加启动参数 `-nologo` 来隐藏 PowerShell 启动时的欢迎信息。这样，启动 PowerShell 时就不会显示欢迎信息。请注意，这个设置仅适用于 PowerShell，而不适用于 CMD。

![](https://pic1.zhimg.com/v2-b8ec887d12352094fa654bcc4b36243c_1440w.jpg)

同样，你可以设置 CMD 的外观，甚至将 CMD 设置为默认启动的终端（倒反天罡）。

![](https://pic1.zhimg.com/v2-7c96207593178044be79fce0b1a7ffda_1440w.jpg)

![](https://pic3.zhimg.com/v2-50f97edf0b49c13307911c21dc9533de_1440w.jpg)

## **三、配置美化 PowerShell**

### **3.1 安装 oh-my-posh**

通过微软商店直接下载 **oh-my-posh。**

**

![](https://pica.zhimg.com/v2-73201b5d409ba3fcd3af60dd481f7306_1440w.jpg)



**

### 3.2 **激活 oh-my-posh**

为了让 oh-my-posh 在 PowerShell 启动时自动激活，需编辑 PowerShell 配置文件。

打开配置文件：

```text
notepad $PROFILE
```

如果找不到 $PROFILE 文件，可以使用以下命令创建：

```text
New-Item -Path $PROFILE -Type File -Force
```

在配置文件中添加以下内容以初始化：

```text
oh-my-posh init pwsh | Invoke-Expression
```

配置文件的路径如下图所示：

![](https://picx.zhimg.com/v2-4e0d2a792a9adc5d039629205504a87f_1440w.jpg)

### 3.3 配置主题

**3.3.1 查看主题列表**

**oh-my-posh** 提供了多种美观的预设主题。使用以下命令查看所有可用的主题：

```text
Get-PoshThemes
```

运行该命令后，会显示很多的主题，每个主题的名称会显示在主题的上方。

3.3.2 使用自定义主题

可以在初始化命令中指定自定义主题路径，即在初始化代码后添加`--config "$env:POSH_THEMES_PATH\<主题名>.omp.json"`。

以下为完整配置：

```text
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\montys.omp.json" | Invoke-Expression
```

### 3.4 图标美化

**Terminal-Icons** 是一个 PowerShell 模块，用于在 Windows 终端中为文件和文件夹添加图标。它基于文件名称或扩展名自动分配图标，若找不到相应的图标，则使用通用图标。

执行以下命令安装该模块：

```text
Install-Module -Name Terminal-Icons -Repository PSGallery
```

安装后，在 PowerShell 配置文件 ($PROFILE) 中添加以下行以启用该插件：

```text
Import-Module Terminal-Icons
```

效果展示：

![](https://pic1.zhimg.com/v2-a954af12e27c1fd6aa9df1da01f5b278_1440w.jpg)

### 3.5 安装插件模块

完成3.1-3.4以上操作后，PowerShell 中已启用 **oh-my-posh** 的美化效果。接下来是一些进阶操作，旨在进一步提升 PowerShell 的使用体验，使其具备类似 **Mac** 上的 **oh-my-zsh** 功能，涵盖语法高亮、错误提示、多行编辑、快捷键绑定、自动补全、历史搜索及 Git 扩展显示等：

**3.5.1 安装 PSReadLine**

**PSReadLine** 提供语法高亮、错误提示、多行编辑、键绑定、历史记录搜索等功能，提升命令行体验。

```text
Install-Module PSReadLine
```

**3.5.2 安装 posh-git**

**posh-git** 可以在 PowerShell 中显示 Git 状态信息，并提供 Git 命令的自动补全。

安装命令：

```text
Install-Module posh-git
```

在 PowerShell 配置文件 (`$PROFILE`) 中添加以下行以启用该插件：

```text
Import-Module posh-git
```

**3.5.3 安装 ZLocation**

**ZLocation** 插件类似于 `autojump`或 `Zsh-z`，通过关键字直接跳转到指定目录，提升效率。

1\. 安装 ZLocation 插件：

```text
Install-Module ZLocation 
```

2\. 修改配置文件：

打开 PowerShell 配置文件：

```text
notepad $PROFILE
```

在文件末尾添加：

```text
Import-Module ZLocation
```

**ZLocation 使用示例**

-   查看已知的目录：

```text
z
```

-   跳转到包含指定字串的目录（支持 Tab 补全）：

```text
z doc
```

-   回到上一个访问的目录：

```text
z -
```

### **3.6 编辑 PowerShell 配置文件**

配置文件的作用是在 PowerShell 启动时运行一些自定义的设置，比如导入模块、设置别名、定义函数等。

以下是我的配置文件，大家可以参考注释根据自己需求修改或者删除：

```text
# 初始化 oh-my-posh
C:\\Users\\Strider（改为你自己的用户名）\\AppData\\Local\\Programs\\oh-my-posh\\bin\\oh-my-posh.exe init pwsh --config $env:POSH_THEMES_PATH\cloud-native-azuree.json | Invoke-Expression
# 引入所需模块
Import-Module posh-git # 引入 posh-git
Import-Module PSReadLine # 历史命令联想
Import-Module Terminal-Icons
Import-Module ZLocation
# 设置 PSReadLine 的生效场景
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
# 设置预测文本来源为历史记录 
Set-PSReadLineOption -PredictionSource History 
# 设置 Tab 为菜单补全和 Intellisense 
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete 
# 每次回溯输入历史，光标定位于输入内容末尾 
Set-PSReadLineOption -HistorySearchCursorMovesToEnd 
# 设置向上键为后向搜索历史记录 
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward 
# 设置向下键为前向搜索历史纪录 
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
```

## 四、配置美化 CMD

### 4.1 什么是clink？

**clink** 是一款增强 CMD 功能的小工具，支持自动补全、命令历史等功能，极大提升了 CMD 的使用体验。

### 4.2 安装 clink

在 CMD 中直接使用 scoop 安装 clink：

```text
scoop install clink
```

### 4.3 激活 clink

可以通过 `autorun` 命令设置 clink 自动运行，并使用 `quiet` 参数。这样每次启动 CMD 时，clink 会自动启用并禁用启动提示信息：

```text
clink autorun install -- --quiet
```

使用 `quiet` 参数前后的效果如下：

（使用前）

![](https://pic1.zhimg.com/v2-2e90576b21c6a4795c27ad64c82ea00c_1440w.jpg)

（使用后）

![](https://pic1.zhimg.com/v2-855d4c4ad47d288aa55081ebfcffb304_1440w.jpg)

### 4.4 启用自动补全

clink 支持 `autosuggest` 自动补全功能，类似于 shell 中的 zsh 自动建议。可以通过以下命令启用该功能：

```text
clink set autosuggest.enable true
```

### 4.5 查看配置信息

可以使用以下命令查看当前的 clink 配置信息：

```text
clink info
```

### 4.6 配置 oh-my-posh 样式

如果希望在 CMD 中同样展示 **oh-my-posh** 的样式，可以通过 Lua 脚本加载主题。具体步骤如下：

**创建 Lua 配置文件**

在 `C:\Users\<用户名>\AppData\Local\clink` 目录下，新建一个名为 `oh-my-posh.lua` 的文件。

**加载 oh-my-posh 主题**

在文件中写入以下代码，以将 oh-my-posh 的样式应用到 CMD：

```text
load(io.popen('oh-my-posh init cmd'):read("*a"))() 
```

配置完成后，重新打开 CMD，即可看到应用了 **oh-my-posh** 的自定义提示符样式。

### 4.7 使用 CMD 脚本预先配置 Alias

通过 Clink，可以在 CMD 中为常用的 Linux 命令（如 `ls`、`rm` 等）创建别名（alias），帮助习惯 Linux 命令行的用户更轻松地适应 CMD 控制台。

在 Windows 系统上设置 alias 通常使用 `doskey` 命令，并可以借助 Clink 工具，在 CMD 启动时自动执行脚本来加载这些 alias。默认情况下，Clink 会从 `C:\Users\<username>\AppData\Local\clink` 目录中查找 `clink_start.cmd` 文件来进行初始化。

可以在该目录下创建 `clink_start.cmd` 文件，并添加以下内容：

```text
@echo off 
doskey ls=dir 
doskey rm=del 
doskey cp=copy 
doskey mv=move 
doskey of=explorer.exe .
```

保存文件后，这些 `doskey` 指令将在 CMD 下次启动时自动执行，从而实现 alias 效果。

## 五、美化 VScode 内终端

在 VScode 里使用终端，可能会出现乱码或者图标不显示情况，设置一下字体就行，直接输入你上面配置的 oh-my-posh 字体 如： MesloLGM Nerd Font。

![](https://pic1.zhimg.com/v2-5e14ed81bab8a24ca48cf3358f25c6e8_1440w.jpg)

效果展示如下：

![](https://pic4.zhimg.com/v2-57711ca22bd1f4e20ab769c12a47fe39_1440w.jpg)

## 六、结语

**oh-my-posh** 总体体验上还不错，能够方便的展示 git 相关的信息，但是性能拉胯，每次终端可能需要0.5s到2s之间的延迟卡顿，相比于 Linux 和 Mac 上的 Shell 要慢上不少，**最后提一句：国补之后的铭凡原子侠G7 PT迷你主机是真的香啊，兄弟们赶紧点击我文章中的链接冲起来吧！**

**END**

> 攻城狮阿程一个喜欢IT也懂土木工程的运维攻城狮。  
> 运维入行，直至信创、网安、OpenWrt、虚拟技术、Docker 容器。  
> 岗位历经网络工程、运维、项目经理、信息安全。  
> 主要渠道：个人淘宝店：阿程数码  
> 知乎：攻城狮阿程  
> 个人公众号：攻城狮阿程  
> 个人博客：[https://strider1230.cn](https://strider1230.cn)  
> 小红书：果冻橙是橘子吗の快乐生活  
> 知识星球：阿程的资源社区（待完善）  
> 抖音炉石传说：果冻橙是橘子吗  
> 其他渠道持续拓展中

