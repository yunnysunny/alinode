# alinode 镜像

## 镜像说明

### yunnysunny/alinode-core

集成了 alinode 和 yarn，是 alinode-compiler 和 alinode-runtinme 的基础镜像。

### yunnysunny/alinode-compiler

集成了 gcc g++ python3 等开发包，可以用其来编译原生代码。

### yunnysunny/alinode-runtime

集成 alinode 日志收集功能，需要注入 `APP_ID` `APP_SECRET` 两个环境变量。

## 使用方法

使用 alinode-compiler 来生成 node_modules 、构建项目生成产物，然后将 node_modules 和 生产产物拷贝到基于 alinode-runtinme 的镜像中。

## 构建示例

可以参见 [test/hello/test.sh](https://github.com/yunnysunny/alinode/blob/master/test/hello/test.sh)。

## 版本说明

本项目的构建的镜像版本支持语义化版本号原则。在 github 上发布一个  `vx.y.z` tag 后，会自动生成  `x.y` `x.y.z` 三个镜像版本。

| 镜像版本     | node 版本 | 备注       |
| -------- | ------- | -------- |
| 0.2        | 16      | 基于ubuntu |
| alpine-0.2 | 16      | 基于alpine |

### 关于 alpine 镜像

alinode 基于 glibc 进行构建，但是 alpine 中的 C 标准库没有选择 glibc，而是使用了更加轻量的 musl，这就导致 alinode 无法在 alpine 中直接运行。

alpine.dockerfile 在构建时安装了 gcompat 这个软件包，它可以将 musl 转化为 glibc 运行，目前看 alinode 在上面运行良好。不过考虑到 gcompat 的兼容性，如果你的应用的依赖包中含有原生依赖，且这个原生依赖提供了预编译库，则这个预编译库在此镜像上的运行情况是未知的。

由于 gcompat 不兼容 aarch64 平台，所以 apline 镜像不提供 linux/arm64 版本的镜像。
