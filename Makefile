DOCKERFILES := $(wildcard */Dockerfile)
CONTEXTS := $(DOCKERFILES:/Dockerfile=)

.PHONY: all

all: README.md .github/workflows/docker.yml

README.md: */README.md docs/about.md
	@printf '==> %s\n' "$@"
	.helpers/readme_generator.py \
	  --dhuser "backplane" \
	  --header docs/about.md \
	  */README.md \
	  >"$@"

.github/workflows/docker.yml: $(DOCKERFILES) $(CONTEXTS)
	.helpers/update_workflow.py "$@"
