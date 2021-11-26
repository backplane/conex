DOCKERFILES := $(wildcard */Dockerfile)
CONTEXTS := $(DOCKERFILES:/Dockerfile=)

.PHONY: all

all: README.md .github/workflows/docker.yml

README.md: */README.md docs/about.md
	@printf '==> %s\n' "$@"
	docker run --rm -it --volume "$$(pwd):/work" backplane/conex-helper \
	  update-readme \
	    -i docs/about.md \
	    */README.md

.github/workflows/docker.yml: $(DOCKERFILES) $(CONTEXTS)
	docker run --rm -it --volume "$$(pwd):/work" backplane/conex-helper \
	  update-workflow
