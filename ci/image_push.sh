#!/bin/bash
echo $DOCKER_PASSWD | docker login -u $DOCKER_USERNAME $DOCKER_REPO --password-stdin
set -ex

names=('core' 'compiler' 'runtime')

for name in "${names[@]}"
do
    tagNameStr=$(node get_image_tags.js "$name")
    IFS=',' read -r -a tagNames <<< "$tagNameStr"
    for tag in "${tagNames[@]}"
    do
        docker push $tag
    done
done