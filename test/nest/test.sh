#!/bin/bash
set -ex

APP_PORT=4232
APP_ID=90945
APP_SECRET=232717ddf1893a9e39464b4752d451e61fc2e416

IMAGE_VERSION=${IMAGE_VERSION:-latest}
MY_NAME=mynest
OS_NAME=${OS_NAME:-ubuntu}
VERSION_NAME_PREFIX=""
if [ "$OS_NAME" = "alpine" ] ; then
    VERSION_NAME_PREFIX="alpine-"
fi
docker build . -t ${MY_NAME} --build-arg APP_ID=${APP_ID} \
--build-arg VERSION_NAME_PREFIX=${VERSION_NAME_PREFIX} \
--build-arg APP_SECRET=${APP_SECRET} \
--build-arg IMAGE_VERSION=${IMAGE_VERSION}
container_id=$(docker run -e APP_PORT="${APP_PORT}" -p ${APP_PORT}:${APP_PORT}  -d ${MY_NAME})
sleep 3
curl http://localhost:${APP_PORT}
docker stop "${container_id}"
docker rm "${container_id}"

