export DH_REGISTRY_PATH ?= galvanist/conex
export GH_REGISTRY_PATH ?= docker.pkg.github.com/glvnst/conex
export LOCAL_IMG_PREFIX ?= conex_

# leave this blank to enable skipping builds when the checksum of the build
# context matches the checksum in the manfiest on docker hub
export DISABLE_DAYSUM_QUERY ?=

DOCKERFILES := $(wildcard */Dockerfile)
PROJECTS := $(DOCKERFILES:/Dockerfile=)

.PHONY: build push clean deepclean list report all test
.PRESCIOUS: $(PROJECTS:%=%-build-rcpt.txt) $(PROJECTS:%=%-postbuild-rcpt.txt) $(PROJECTS:%=%-ghpush-rcpt.txt) $(PROJECTS:%=%-dhpush-rcpt.txt) $(PROJECTS:%=%-postpush-rcpt.txt)

all: build

# enables "make <subdir>" to work (e.g. "make vueenv")
$(PROJECTS): % : %-postbuild-rcpt.txt

build: $(PROJECTS:%=%-postbuild-rcpt.txt)

push: $(PROJECTS:%=%-postpush-rcpt.txt)

clean:
	@printf '==> %s\n' 'CLEAN'
	rm -f *-rcpt.txt

deepclean: clean
	@printf '==> %s\n' 'IMAGE CLEAN'
	@for project in $(PROJECTS); do \
	  printf '%s\n' "$${LOCAL_IMG_PREFIX}$${project}"; \
	done \
	| tr '\n' '\0' \
	| xargs -0 docker image rm \
	|| true

list:
	@for project in $(PROJECTS); do \
	  printf '%s\n' "$$project"; \
	done

report:
	@for project in $(PROJECTS); do \
	  for step in build ghpush dhpush postpush; do \
	    printf '%s\n' "========== $$project $$step ==========" && \
	    rcpt="$${project}-$${step}-rcpt.txt"; \
	    if [ -f "$$rcpt" ]; then \
	      cat -- "$$rcpt"; \
	    else \
	      printf '%s\n' "No receipt found. ($${rcpt})"; \
	    fi; \
	  done; \
	done

test:
	@printf '==> %s\n' 'This repo needs tests! Please help.'
	@false

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

README.md: */README.md docs/about.md docs/dockerization.md
	@printf '==> %s\n' "$@"
	.helpers/readme_generator.py \
	  --dhrepo "$$DH_REGISTRY_PATH" \
	  --header docs/about.md \
	  --header docs/dockerization.md \
	  */README.md \
	  >"$@"
