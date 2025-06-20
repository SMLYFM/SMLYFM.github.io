# 个人博客



* **GitHub Issues**: 在本项目的 GitHub Issues 页面新建一个 issue。
* **个人博客**: [分享数学和计算机技术](https://smlyfm.github.io)
* **GitHub 主页**: [![GitHub](https://img.shields.io/badge/GitHub-KS--MATH-blue?style=social&logo=github)](https://github.com/KS-MATH)，[![GitHub](https://img.shields.io/badge/GitHub-topmkter-blue?style=social&logo=github)](https://github.com/topmkter)
* **邮件**: 发送邮件至 <sudocjx@gmail.com>。

提交时，请尽可能详细地描述问题，包括复现步骤、错误截图和您的运行环境，这将有助于我更快地定位和解决问题。



# 搭建说明



使用`git`管理项目源码，`hexo`管理网页



1. **先用 `git init`**：在本地创建一个仓库。
2. **再用 `git remote add`**：将这个本地仓库与一个远程仓库（比如 GitHub 上的）关联起来。



```
# 确保使用你的 SSH 别名来构建地址
git remote add origin git@github.com-SMLYFM:SMLYFM/SMLYFM.github.io.git
```

**这个命令的意思是**：添加一个名为 `origin` 的远程仓库，它的地址是 `git@github.com-SMLYFM:SMLYFM/SMLYFM.github.io.git`。

> **注意**：如果提示 `fatal: remote origin already exists.`，说明你之前可能添加过一个错误的 origin。你需要先用 `git remote remove origin` 删掉它，然后再重新运行上面的 `git remote add` 命令。



```
git remote -v
```

如果你看到类似下面的输出，**那就证明你已经成功了**！

```
origin  git@github.com-SMLYFM:SMLYFM/SMLYFM.github.io.git (fetch)
origin  git@github.com-SMLYFM:SMLYFM/SMLYFM.github.io.git (push)
```



```
# 现在这个命令应该可以成功执行了
git push origin --delete gh-pages

# 删除 master 分支
git push origin --delete master
```

这个工作模式非常清晰：

* **`main` 分支**：作为**部署分支**。只存放由 `hexo generate` 生成的、可以直接在网上浏览的公开网页文件（HTML, CSS, JS）。这个分支通常由 `hexo deploy` 命令自动管理。
* **`master` 分支**：作为**源文件分支**。存放你整个项目的“菜谱”，也就是你的 Markdown 文章、配置文件 `_config.yml`、主题文件等。这个分支由你手动通过 `git add`, `git commit`, `git push` 来管理，作为你的心血备份。

------



```
git branch
```

你应该会看到 `* master`。



```
git push -u origin master
```

* **`git push`**: 推送命令。
* **`origin`**: 你的远程仓库别名（指向 GitHub）。
* **`master`**: 你要推送的本地分支名，同时也是你想在远程创建的分支名。
* **`-u`**: 建立本地 `master` 和远程 `master` 的跟踪关系，方便以后直接使用 `git push`。

执行完这个命令后，你再去 GitHub 仓库页面刷新一下，就能在分支列表里看到新出现的 `master` 分支了，里面存放着你博客的所有源文件。

------

### 确保未来的部署正确无误

最后一步，我们需要检查并确保你 Hexo 的部署配置是正确的，即让 `hexo deploy` 命令把生成的网站推送到 `main` 分支。

请打开你项目的 `_config.yml` 文件，找到 `deploy` 部分，确保 `branch` 的值是 `main`。

YAML

```
# _config.yml

deploy:
  type: git
  # repo 地址使用你的 SSH 别名
  repo: git@github.com-SMLYFM:SMLYFM/SMLYFM.github.io.git
  # 确认部署分支是 main
  branch: main
```

如果这里不是 `main`，请务必修改过来并保存。

### 你的未来工作流程总结

从现在开始，你的工作流程会非常清晰：

1. **写文章、改配置（管理源代码）**：
   * `git add .`
   * `git commit -m "你的修改说明"`
   * `git push origin master`  **(备份源代码到 `master` 分支)**
2. **发布网站（更新线上内容）**：
   * `hexo clean && hexo generate`
   * `hexo deploy`  **(发布公开网站到 `main` 分支)**

这两个流程互相独立，分工明确。你已经搭建起了专业、高效的博客工作流，恭喜！
