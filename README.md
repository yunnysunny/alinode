# alinode 镜像

## 镜像说明

### core

集成了 alinode 和 yarn，是 alinode-compiler 和 alinode-runtinme 的基础镜像。

### alinode-compiler

集成了 gcc g++ python3 等开发包，可以用其来编译原生代码。

### alinode-runtinme

集成 alinode 日志收集功能，需要注入 `APP_ID` `APP_SECRET` 两个环境变量。

## 使用方法

使用 alinode-compiler 来生成 node_modules 、构建项目生成产物，然后将 node_modules 和 生产产物拷贝到基于 alinode-runtinme 的镜像中。

## 构建示例

可以参见 [test/hello/test.sh](test/hello/test.sh)。

## 版本说明

本项目的构建的镜像版本支持语义化版本号原则。在 github 上发布一个  `vx.y.z` tag 后，会自动生成 `x` `x.y` `x.y.z` 三个镜像版本。

| 镜像版本 | node 版本 | 备注 |
| -------- | --------- | ---- |
| 0        | 16        |      |
|          |           |      |

