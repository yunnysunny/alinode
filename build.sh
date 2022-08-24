#!/bin/bash
set -ex

ALINODE_VERSION=7.6.0

BUILD_ARGS="--build-arg ALINODE_VERSION=${ALINODE_VERSION} \
"

BUILD_TAG_CORE=$(node ci/get_image_build_tag.js core)
BUILD_TAG_COMPILER=$(node ci/get_image_build_tag.js compiler)
BUILD_TAG_RUNTIME=$(node ci/get_image_build_tag.js runtime)

if [ "$NEED_PUSH" = "1" ] ; then
    PLATFORM="--platform=linux/arm64,linux/amd64"
    PARAM_OUTPUT="--push"
else
    PLATFORM=""
    PARAM_OUTPUT="-o type=docker"
fi

docker buildx build -f ubuntu.dockerfile core \
$PLATFORM \
$BUILD_ARGS \
--target core \
$BUILD_TAG_CORE $PARAM_OUTPUT

docker buildx build -f ubuntu.dockerfile core \
$PLATFORM \
$BUILD_ARGS \
--target compiler \
$BUILD_TAG_COMPILER $PARAM_OUTPUT

docker buildx build -f ubuntu.dockerfile runtime \
$PLATFORM \
$BUILD_ARGS \
--target runtime \
$BUILD_TAG_RUNTIME $PARAM_OUTPUT



