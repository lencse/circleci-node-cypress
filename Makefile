.PHONY: build test push

DOCKER_IMAGE_NAME=lencse/circleci-node-cypress

build:
	docker build -t ${DOCKER_IMAGE_NAME} .

test:
	docker run -it -v `pwd`/test:/build ${DOCKER_IMAGE_NAME} /build/verify-cypress.sh

push:
	[ ! -z "$(DOCKER_IMAGE_TAG)" ] && \
		( \
			docker tag ${DOCKER_IMAGE_NAME} ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} && \
			docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} \
		) || \
		(echo "\n---\nDOCKER_IMAGE_TAG env var is not set\n---" && exit 1)
