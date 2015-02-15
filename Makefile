.PHONY: all build


GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
DOCKER_IMAGE := skyline$(if $(GIT_BRANCH),:$(GIT_BRANCH))

default: build

run:

build:
	docker build -t "$(DOCKER_IMAGE)" .

publish:
