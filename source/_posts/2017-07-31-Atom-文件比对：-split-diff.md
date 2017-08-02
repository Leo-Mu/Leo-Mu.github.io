---
title: Atom 文件比对： split-diff
date: 2017-07-31 22:43:15
categories:
 - IT
 - Develop
 - editor
 - Atom
 - package
tags:
 - 开发文档
 - 技术干货
 - 教程
---

推荐一款 Atom 编辑器中的文件比较插件 [split-diff][8b3673f0]

  [8b3673f0]: https://atom.io/packages/split-diff "split-diff"

<!-- more -->

## 针对需求

此插件针对的问题就是很简单的两个文件要进行比较。

事实上有很多工具被制作来解决这个问题，但是它们大都是命令行工具，至少是需要离开熟悉好用的 Atom 环境，让你丧失自由度和版本控制。最要命的是，这些工具（比如很多 bash 预装的）往往只能列出不同，但没有办法在你编辑的时候实时更新给你看，难道你要看一下行号然后编辑一段，再退出来运行命令？

Atom 上也还有其他 file compare 插件，比如 [compare-files][867f33a5] ，但就有上面提到的问题。

  [867f33a5]: https://atom.io/packages/compare-files "compare-files atom 插件"

## 特性

那么我为什么推荐这一款插件呢？

它非常好用！这个插件可以像 GitHub 的 compare 功能 （当然它仅限于同一个仓库不同版本间的比较） 一样进行左右两栏比对，左右位置同步非常准确，对照方便，颜色标识很清晰！方便编辑！其实已经有很多 Atom 插件可以两栏比对，但都仅限于本仓库的版本比对。这个插件是我找到的唯一一个自由对任何文件进行两栏比对的插件。 [^1]

## 注意事项

一定要注意左右两侧的换行符是不是一样的，如果不一致会所有行都显示更改过，我被这东西坑的浪费了好长时间！看 Atom 下方状态栏的右方最左侧的按钮（ LF/CRLF ），确保左右两者一致！

[^1]: [参见我在 Atom 中文社区发表的回复](https://atom-china.org/t/atom/814/3?u=leo-mu)
