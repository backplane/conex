GH_REGISTRY_PATH ?= docker.pkg.github.com/glvnst/conex
DH_REGISTRY_PATH ?= galvanist/conex
LOCAL_IMG_PREFIX ?= conex_
BUILD_ARGS ?=
DOCKER := docker
DOCKERFILES := $(wildcard */Dockerfile)
PROJECTS := $(DOCKERFILES:/Dockerfile=)

.PHONY: build push clean deepclean list report all test

.PRESCIOUS: $(PROJECTS:%=%-build-rcpt.txt) $(PROJECTS:%=%-postbuild-rcpt.txt) $(PROJECTS:%=%-ghpush-rcpt.txt) $(PROJECTS:%=%-dhpush-rcpt.txt) $(PROJECTS:%=%-postpush-rcpt.txt)

build: $(PROJECTS:%=%-postbuild-rcpt.txt)

push: $(PROJECTS:%=%-postpush-rcpt.txt)

clean:
	@echo "===> CLEAN $<"
	rm -f *-rcpt.txt

deepclean:
	@echo "===> CLEAN + docker clean $<"
	rm -f *-rcpt.txt
	@set -x; for project in $(PROJECTS); do \
	  docker image rm "$(LOCAL_IMG_PREFIX)$${project}" || true; \
	done

list:
	@for project in $(PROJECTS); do \
	  echo "$$project"; \
	done

report:
	@for project in $(PROJECTS); do \
	  for step in build ghpush dhpush postpush; do \
	    echo "========== $$project $$step ==========" && \
	    rcpt="$${project}-$${step}-rcpt.txt"; \
	    if [ -f "$$rcpt" ]; then \
	      cat -- "$$rcpt"; \
	    else \
		  echo "No receipt found. ($${rcpt})"; \
		fi; \
	  done; \
	done

all: build

test:
	@echo 'This repo needs tests! Please help.'
	@false

# enables "make <subdir>" to work (e.g. "make vueenv")
$(PROJECTS): % : %-postbuild-rcpt.txt

%-build-rcpt.txt: %/Dockerfile
	@printf '==> %s\n' "$$(basename "$@" "-rcpt.txt")"
	.helpers/maker.sh build "$@"

%-postbuild-rcpt.txt: %-build-rcpt.txt
	@printf '==> %s\n' "$$(basename "$@" "-rcpt.txt")"
	.helpers/maker.sh postbuild "$@"

%-ghpush-rcpt.txt: %-postbuild-rcpt.txt
	@printf '==> %s\n' "$$(basename "$@" "-rcpt.txt")"
	.helpers/maker.sh ghpush "$@"

%-dhpush-rcpt.txt: %-postbuild-rcpt.txt
	@printf '==> %s\n' "$$(basename "$@" "-rcpt.txt")"
	.helpers/maker.sh dhpush "$@"

%-postpush-rcpt.txt: %-dhpush-rcpt.txt %-ghpush-rcpt.txt
	@printf '==> %s\n' "$$(basename "$@" "-rcpt.txt")"
	.helpers/maker.sh postpush "$@"

README.md: */README.md
	@echo "==> $@"
	.helpers/maker.sh genreadme $(PROJECTS)
