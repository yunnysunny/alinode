#!/bin/bash
# 本地开发测试用脚本
export DOCKER_REPO=
export CI_COMMIT_TAG=v0.0.2
# export IMAGE_VERSION=$(node ci/get_full_version.js)

make build
make test
