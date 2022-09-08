FROM ubuntu:latest AS core

ARG NPM_REGISTRY=https://registry.npmmirror.com
ARG NPM_MIRROR=https://npmmirror.com

ENV ENABLE_NODE_LOG YES
ENV NODE_LOG_DIR /tmp
ENV HOME /root
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
  && sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
  && apt-get update \
  && apt-get install  --no-install-recommends  curl  ca-certificates -y \
  && rm -rf /var/lib/apt/lists/*
ARG ALINODE_VERSION
ENV ALINODE_VERSION=${ALINODE_VERSION}
# ENV ARCH=x64
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "arm64" ] ; then \
      export ARCH=arm64 ; \
    elif [ "$TARGETARCH" = "arm" ] ; then \
      export ARCH=armv7l ; \
    else \
      export ARCH=x64 ; \
    fi ; \
    if [ "$TARGETARCH" = "arm64" ] || [ "$TARGETARCH" = "arm" ] ; then \
      apt-get update \
      && apt-get install libatomic1 --no-install-recommends -y \
      && rm -rf /var/lib/apt/lists/* ; \
    fi \
  && curl -fsSLO --compressed "${NPM_MIRROR}/mirrors/alinode/v$ALINODE_VERSION/alinode-v$ALINODE_VERSION-linux-$ARCH.tar.gz" \
  && curl -fsSLO --compressed "${NPM_MIRROR}/mirrors/alinode/v$ALINODE_VERSION/SHASUMS256.txt" \
  && grep " alinode-v$ALINODE_VERSION-linux-$ARCH.tar.gz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -zxvf "alinode-v$ALINODE_VERSION-linux-$ARCH.tar.gz" -C /usr/local --strip-components=1 \
  && rm "alinode-v$ALINODE_VERSION-linux-$ARCH.tar.gz" SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && npm config set registry ${NPM_REGISTRY} \
	&& npm config set profiler-binary-host-mirror ${NPM_MIRROR}/mirrors/node-inspector/ \
  && npm config set disturl ${NPM_MIRROR}/dist \
  && ENABLE_NODE_LOG=NO npm install -g @alicloud/agenthub yarn \
  && npm cache clean --force \
  && yarn config set registry ${NPM_REGISTRY}

# 使用东八区时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

FROM core AS compiler


RUN apt-get update \
  && apt-get  --no-install-recommends install git gcc g++ make python3 openssh-client -y \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp 

FROM core AS runtime
ENV ENABLE_NODE_LOG YES

COPY ./default.config.js $HOME
COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

