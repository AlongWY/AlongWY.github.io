---
title: Travis CI + Hexo部署你的博客
date: 2017-08-17 7:30:00
tags: 
    - Hexo
    - Travis CI
categories: 学习
---

# Hexo 介绍
Hexo 是一个快速、简洁且高效的博客框架。

<!-- more --> 

# 准备

1. 到[Git主页](https://git-scm.com/)下载Git并安装。
2. 到[Nodejs主页](https://nodejs.org/zh-cn/)下载Nodejs并安装。

## 注册Github并建立仓库
到[Github](https://github.com/)注册一个账号，新建一个仓库。
仓库名为 username.github.io 这就是你的Github博客主页。

## 部署Git
到一个你喜欢的位置，执行如下命令：
``` bash
git init Blog
cd Blog
git remote add origin git@github.com:username/username.github.io.git
git checkout -b hexo
```
我们将hexo源文件部署在hexo分支下。

## 安装Hexo
现在你已经在博客目录下了，执行如下命令：
``` bash
npm install hexo-cli -g
cd blog
hexo init
npm install
```

# 配置Travis-CI进行持续集成
## 开启 Travis-CI
使用Github账号登录[Travis-CI](https://www.travis-ci.org/)网站，开启你的仓库。
而后你可以在左侧的`My Repositories`侧边栏下看到你的仓库，打开它。
在右侧的`More options`下选择`Settings`选项，打开`General`选项卡下的三个选项。
* Build only if .travis.yml is present
* Build branch updates
* Build pull request updates

然后到Github的Setting页面中完成[Access Token](https://github.com/settings/tokens)的申请，只需要勾选repo这一项权限即可，然后将其作为环境变量`GH_TOKEN`的值存在`Environment Variables`栏下。

## 创建配置文件
在`Blog`目录下创建`.travis.yml`文件，修改其内容如下：
``` YAML
language: node_js
node_js: stable

# Travis-CI Caching
cache:
  directories:
    - node_modules

# S: Build Lifecycle
install:
  - npm install

before_script:
 # - npm install -g gulp

script:
  - hexo g

after_script:
  - cd ./public
  - git init
  - git config --global user.name "uesrname"
  - git config --global user.email "username@mail.adress"
  - git add .
  - git commit -m "Update docs"
  - git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:master
# E: Build LifeCycle

branches:
  only:
    - hexo
env:
 global:
   - GH_REF: github.com/uesrname/uesrname.github.io.git
```
**注意修改文件内的`GH_REF`和`after_script`中的内容**

## 更新文件部署到Github
执行如下命令以更新Blog目录文件:
``` bash
git add ./
git commit -m "create hexo env"
git push --set-upstream origin hexo
```

这样可以实现源文件和静态网页都保存到仓库中，避免了信息丢失的风险。


# 写文章
``` bash
hexo new [layout] <title>
```
使用模板创建文章，在目录`source\_posts`下会生成`<title>.md`，而后你可以对其进行修改，而后执行如下命令生成页面并发布到你的Github主页上。
``` bash
git add ./
git commit -m "update docs"
git push
```

使用如下命令可以在本地预览。
``` bash
hexo clean
hexo g
hexo s
```

# 新的环境下执行如下命令即可
```bash
git clone git@github.com:username/username.github.io.git Blog
cd Blog
git checkout hexo
npm install
```
而后就和前面的步骤一样了。
