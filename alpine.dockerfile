FROM alpine:latest AS core

ARG NPM_REGISTRY=https://registry.npmmirror.com
ARG NPM_MIRROR=https://npmmirror.com

ENV ENABLE_NODE_LOG YES
ENV NODE_LOG_DIR /tmp
ENV HOME /root
ARG ALINODE_VERSION
ENV ALINODE_VERSION=${ALINODE_VERSION}
ARG TARGETARCH
ARG YARN_VERSION=1.22.19
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
  && apk update \
  && apk add --no-cache gcompat libstdc++ ca-certificates \
  && apk add --no-cache --virtual .build-deps-yarn curl gnupg \
  && rm -rf /var/cache/apk/* \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys "$key" || \
    gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && if [ "$TARGETARCH" = "arm64" ] ; then \
      export ARCH=arm64 ; \
    elif [ "$TARGETARCH" = "arm" ] ; then \
      export ARCH=armv7l ; \
    else \
      export ARCH=x64 ; \
    fi ; \
    if [ "$TARGETARCH" = "arm64" ] || [ "$TARGETARCH" = "arm" ] ; then \
      apk update \
      && apk add --no-cache libatomic  \
      && rm -rf /var/cache/apk/* ; \
    fi  \
  && curl -fsSLO --compressed "${NPM_MIRROR}/mirrors/alinode/v$ALINODE_VERSION/alinode-v$ALINODE_VERSION-linux-$ARCH.tar.gz" \
  && curl -fsSLO --compressed "${NPM_MIRROR}/mirrors/alinode/v$ALINODE_VERSION/SHASUMS256.txt" \
  && grep " alinode-v$ALINODE_VERSION-linux-$ARCH.tar.gz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -zxvf "alinode-v$ALINODE_VERSION-linux-$ARCH.tar.gz" -C /usr/local --strip-components=1 \
  && rm "alinode-v$ALINODE_VERSION-linux-$ARCH.tar.gz" SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && echo $PATH \
  && set -x \
  && npm config set registry ${NPM_REGISTRY} \
	&& npm config set profiler-binary-host-mirror ${NPM_MIRROR}/mirrors/node-inspector/ \
  && npm config set disturl ${NPM_MIRROR}/dist \
  && npm install -g  @alicloud/agenthub --loglevel verbose \
  && npm cache clean --force \
  && curl -fSLO --compressed "https://master.dl.sourceforge.net/project/yarn.mirror/v$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fSLO --compressed "https://master.dl.sourceforge.net/project/yarn.mirror/v$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn

# 使用东八区时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

FROM core AS compiler


RUN apk update \
  && apk add --no-cache git gcc g++ make python3 openssh-client \
  && rm -rf /var/cache/apk/*

WORKDIR /tmp 

FROM core AS runtime
ENV ENABLE_NODE_LOG YES

COPY ./default.config.js $HOME
COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

