.PHONY: build test push

ifneq (,$(wildcard ./.chrome_version))
    include .chrome_version
    export
endif

DOCKER_SOURCE_IMAGE_NAME=cimg/node
DOCKER_IMAGE_NAME=lencse/circleci-node-cypress

build: .chrome_version

test:
	docker run -it -v `pwd`/test:/build ${DOCKER_IMAGE_NAME} /build/verify-cypress.sh

push: .chrome_version
	[ ! -z "${DOCKER_SOURCE_TAG}" ] && ( \
			docker tag ${DOCKER_IMAGE_NAME} "${DOCKER_IMAGE_NAME}:${DOCKER_SOURCE_TAG}-chrome-${CHROME_VERSION}" && \
			docker push ${DOCKER_IMAGE_NAME}:"${DOCKER_SOURCE_TAG}-chrome-${CHROME_VERSION}" \
		) || \
		(echo "\n---\nError: DOCKER_SOURCE_TAG env var is not set\n---" && exit 1)

Dockerfile: Dockerfile.template
	[ ! -z "$(DOCKER_SOURCE_TAG)" ] && \
		cat Dockerfile.template| sed "s@FROM ${DOCKER_SOURCE_IMAGE_NAME}@FROM ${DOCKER_SOURCE_IMAGE_NAME}:${DOCKER_SOURCE_TAG}@" > Dockerfile || \
		(echo "\n---\nError: DOCKER_SOURCE_TAG env var is not set\n---" && exit 1)

.chrome_version: Dockerfile
	docker build -t ${DOCKER_IMAGE_NAME} .
	docker run ${DOCKER_IMAGE_NAME} google-chrome --version | \
		sed "s/^Google Chrome \([^.]*\).*/CHROME_VERSION=\\1/" > .chrome_version
