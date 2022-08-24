export IMAGE_VERSION=$(shell node ci/get_full_version.js) 

check:
	@echo "current tag $(CI_COMMIT_TAG)"

switch-tag:check
	git fetch --tags && git checkout $(CI_COMMIT_TAG)

build:check
	./build.sh

test-hello:
	cd test/hello && ./test.sh

test:check test-hello

push:check
	export NEED_PUSH=1 && ./build.sh

.PHONY: switch-tag build test-hello test push
