---
title: Submodule 解决 Hexo 主题库更新
date: 2017-07-31 23:19:29
categories:
- IT
- Develop
- web
- blog
- hexo
- theme
tags:
- 开发文档
- 技术干货
- 教程
---

介绍一种方法，巧用 Git submodule 功能方便快捷地完成主题更新，针对一个安装了开源主题的 Hexo blog，并且自身源码需要用 Git 管理。

<!-- more -->

## 问题叙述
如果大家和我一样用的是 [Hexo][6c4b4b34] 框架和某个开源主题（比如我用的是 [Next][67772811] 主题），那么，随着时间的流逝，他们都会更新！并且整个 Bolg 的 Hexo 源码也是通过 Git 管理，托管在 GitHub 上的！（ **之后会说到 Git 会引起多大的麻烦** ）

Hexo 更新到没什么，它本身是一个基于 NodeJS 的命令行工具，`npm update` `npm install` 就完了，就算有什么新配置，新特性，我想用不用，随便，加上个字段就完了。

但是，Next 作为一个 Hexo 的主题（ **其实所有主题都是这样** ），如果它更新了一大堆东西那就麻烦了！你想安装吧，那你之前的那么多配置信息怎么办？主题的所有配置信息那可都是放在主题配置文件 `\themes\<your theme folder>\_config.yml` 里的，你不能瞎复制瞎迁移，甚至必须老老实实重新配置一遍，特别麻烦！

现在的所有 Hexo 主题，有一下三种安装方式：

- 直接下载复制和 NPM：但这里的 NPM 和直接下载复制，本质上没有任何区别，因为在这里 NPM 根本无法发挥它包管理的特性，主题文档里都是让你 NPM 下来然后复制到 Bolg 源码的相应路径，就是把 NPM 当下载器用了。你想想也是，你自己还要配置呀！你用 NPM 你的配置文件怎么办？按照 Hexo 的原理、给主题提供的接入方法，这种方法进行管理好像是不可能的，只能手动迁移配置。
- Git：这种方法的好处显而易见，首先你可以 Fork ，你可以把你的配置修改同步到 GitHub 上去，防止丢失；更重要的是，你可以 marge or rebase ，把主题开发者的上游更改 pull 过来，同时即非常方便的将你的配置更改迁移到新版本上，如果有合并冲突（比如你使用的某个组件不再被支持），也很好处理。 **但是，别忘了我的整个 Hexo 源码可都是通过 Git 控制的！** 这可如何是好？！我从来没见过 Git repository 的嵌套！

[6c4b4b34]: https://hexo.io "Hexo"
[67772811]: http://theme-next.iissnan.com/ "Next"

## 噩梦般的解决方案一

如果说你在上述第二种解决方案 Git 的难题上犯憷了，采用了第一种解决方案。那真是后患无穷啊！

之前你把旧版的 [Next release][55862673] 下载了下来，现在他更新了。于是又把新版的 Next release下载下来，把旧版本的文件夹重命名，把新版本放到 `\themes\next` 文件夹，然后， **噩梦般的配置迁移过程就来了！！！**

  [55862673]: https://github.com/iissnan/hexo-theme-next/releases "Next releases"

### 噩梦般的配置迁移

比如，我可以分享一下我的一次配置迁移历程：

~~Now, I have a pen!~~ 现在，我有一个旧版本的已经配置好的主题文件夹，和一个未经配置的新版本主题文件夹，我如何迁移配置，注意： **我对主题作者的更改、版本控制信息一无所知！** 因此我只好手动合并更改，那么首当其冲的就是比对 `_config.yml` 的配置信息了。当然我不会愚蠢地肉眼查找，经过寻找和研究，神器 [split-diff][259a9ca7] 帮我度过了难关，检出了不一致的地方，于是我一个一个看，终于把配置信息迁移了过去。[^1]

但是，令人头大的问题还在后面！我遇到了几个莫名其妙的问题，其中有一些问题我印象中好像在遥远的过去，最初配置站点时遇到过，但是完全想不起来怎么解决了。于是我翻找之前的 commits ，最终发现了[一年前的修改][2f319283]，于是对照着[做了修改][170a8b81]。还有一个[缩进问题][87f1a80a]，应该是新老版本的配置文件有格式上的微妙差异导致的，简直想骂人！

  [259a9ca7]: https://atom.io/packages/split-diff "split-diff"
  [2f319283]: https://github.com/Leo-Mu/Leo-Mu.github.io/commit/253d1efdf6ac1c89c308944c143e3a78ed440746 "The commit to fix 'https mode' button"
  [170a8b81]: https://github.com/Leo-Mu/Leo-Mu.github.io/commit/790964739920e9632bc98fb45eb678d4b919f3c3 "The new version commit to fix 'https mode' button"
  [87f1a80a]: https://github.com/Leo-Mu/Leo-Mu.github.io/commit/c676358556c6c703bd37ba1d2cd9643ac08f122a "An indent mistack wants to kill me!"

## 新解决方案

终于到了我们的重点！机智地想出第二种解决方案的变式。

大家也看到了，使用第一种解决方案是多么的恶心，更何况我做完这一切之后，发现自己等于是给下一个升级埋了个大坑！下一回我还得这么干，不能忍！

但是第二种解决方案的 Git 仓库嵌套问题怎么解决啊？我研究了一下发现，主要有 [submodule][bebee5c1] & [subtree][33aa63fc] 两种方式。虽然 subtree 更先进，是新的推荐做法，但是 subtree 主要是给大型项目使用的，而且子库还要专门进行合并同步，特别麻烦，命令也多，最终我认为 submodule 是挂载主题的最佳方式。

### Git submodule 解决主题库

于是我就把刚刚配置好的 release 版本主题移走（推荐使用 `git mv <旧文件/文件夹名> <新文件/文件夹名>`  [命令](https://git-scm.com/book/zh/v2/ch00/_git_mv) ），尝试使用 Git submodule 解决问题。使用我的解决方案具体如下：

1. 在 GitHub 网站上 fork 主题仓库到我的账户
2. 将仓库 clone 下来到某处进行配置修改，并 push 好
3. 将改好的仓库以 submodule 方式 clone 到 blog source 并 push 好

```shell
%your hexo source%\themes> git submodule  add <your forked Next repository link> Next
```

以后要更新时只需要先在 fork 的仓库那里同步下来，合并好更新，并 push 好。然后在 blog source 仓库中执行更新子模块的操作，并 push 好即可完成！

```shell
%your hexo source%> git submodule update --remote
```
需要注意的是任何涉及子模块的操作，更改完后都不能使用 GitHub GUI 客户端 commit.（ GitHub 客户端一如既往的坑）手动敲命令就好了。

于是我做到了！以后大家就不用担心上游更新的问题了，哈哈哈！

  [bebee5c1]: https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A8%A1%E5%9D%97 "submodule reference"
  [33aa63fc]: https://git-scm.com/book/zh/v1/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A0%91%E5%90%88%E5%B9%B6 "subtree reference"


[^1]: 关于这个神奇插件的详细内容可以参见我的另一篇博文： {% post_link Atom-文件比对：-split-diff %}
