.PHONY: build test push push_readme_to_dockerhub

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
	[ -z "${DOCKER_SOURCE_TAG}" ] && echo "\n---\nError: DOCKER_SOURCE_TAG env var is not set\n---" && exit 1 || \
		docker tag ${DOCKER_IMAGE_NAME} "${DOCKER_IMAGE_NAME}:${DOCKER_SOURCE_TAG}-chrome-${CHROME_VERSION}" && \
		docker login  -u "${DOCKER_USER}" -p "${DOCKER_PASSWORD}" && \
		docker push ${DOCKER_IMAGE_NAME}:"${DOCKER_SOURCE_TAG}-chrome-${CHROME_VERSION}"

Dockerfile: Dockerfile.template
	cp Dockerfile.template Dockerfile
# [ ! -z "$(DOCKER_SOURCE_TAG)" ] && \
# 	cat Dockerfile.template| sed "s@FROM ${DOCKER_SOURCE_IMAGE_NAME}@FROM ${DOCKER_SOURCE_IMAGE_NAME}:${DOCKER_SOURCE_TAG}@" > Dockerfile || \
# 	(echo "\n---\nError: DOCKER_SOURCE_TAG env var is not set\n---" && exit 1)

.chrome_version: Dockerfile
	docker build -t ${DOCKER_IMAGE_NAME} .
	echo "CHROME_VERSION=0" > .chrome_version
# docker run ${DOCKER_IMAGE_NAME} google-chrome --version | \
# 	sed "s/^Google Chrome \([^.]*\).*/CHROME_VERSION=\\1/" > .chrome_version

push_readme_to_dockerhub:
	docker run -v `pwd`:/workspace \
		-e DOCKERHUB_USERNAME=${DOCKER_USER} \
		-e DOCKERHUB_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKERHUB_REPOSITORY=${DOCKER_IMAGE_NAME} \
		-e README_FILEPATH='/workspace/README.md' \
		peterevans/dockerhub-description:2