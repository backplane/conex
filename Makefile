GH_REGISTRY_PATH ?= docker.pkg.github.com/glvnst/conex
DH_REGISTRY_PATH ?= galvanist/conex
LOCAL_IMG_PREFIX ?= conex_
DOCKER := docker
DOCKERFILES := $(wildcard */Dockerfile)
PROJECTS := $(DOCKERFILES:/Dockerfile=)

.PHONY: build push clean deepclean list

build: $(PROJECTS:%=%-build-rcpt.txt)

# since we have two registries to push to, the postpush hooks run here
push: $(PROJECTS:%=%-ghpush-rcpt.txt) $(PROJECTS:%=%-dhpush-rcpt.txt)
	@for project in $(PROJECTS); do \
	  export NAME="$$project" \
	  && export IMAGE="$(LOCAL_IMG_PREFIX)$${NAME}" \
	  && export POSTPUSH="$$NAME/.postpush.sh" \
	  && \
	  if [ -f "$$POSTPUSH" ]; then \
	    echo "====> POSTPUSH $$NAME" \
	    && ( . "$$POSTPUSH" ) \
		; \
	  fi; \
	done 2>&1 \
	| tee -- "postpush-rcpt.txt"

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

# enables "make <subdir>" to work (e.g. "make vueenv")
$(PROJECTS): % : %-build-rcpt.txt

%-build-rcpt.txt: %/Dockerfile
	@echo "===> BUILD $<"
	@set -x \
	&& export NAME=$$(basename "$@" "-build-rcpt.txt") \
	&& export DOCKER="$(DOCKER)" \
	&& POSTBUILD="$$NAME/.postbuild.sh" \
	&& ( \
	  $(DOCKER) build -t "$(LOCAL_IMG_PREFIX)$${NAME}" "$$NAME" \
	  && \
	  if [ -f "$$POSTBUILD" ]; then \
	    echo "====> POSTBUILD $$NAME" \
	    && . "$$POSTBUILD" \
		; \
	  fi; \
	) 2>&1 | tee -- "$@"

%-ghpush-rcpt.txt: %-build-rcpt.txt
	@echo "===> GITHUB PUSH $<"
	@set -x \
	&& NAME=$$(basename "$@" "-ghpush-rcpt.txt") \
	&& TAG="$(GH_REGISTRY_PATH)/$${NAME}:latest" \
	&& ( $(DOCKER) tag "$(LOCAL_IMG_PREFIX)$${NAME}" "$$TAG" && $(DOCKER) push "$$TAG" ) 2>&1 \
	| tee -- "$@"

%-dhpush-rcpt.txt: %-build-rcpt.txt
	@echo "===> DOCKER HUB PUSH $<"
	@set -x \
	&& NAME=$$(basename "$@" "-dhpush-rcpt.txt") \
	&& TAG="$(DH_REGISTRY_PATH):$${NAME}" \
	&& ( $(DOCKER) tag "$(LOCAL_IMG_PREFIX)$${NAME}" "$$TAG" && $(DOCKER) push "$$TAG" ) 2>&1 \
	| tee -- "$@"
