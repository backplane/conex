# pylint

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pylint](https://www.pylint.org/)

As the docs say:

> Pylint is a tool that checks for errors in Python code, tries to enforce a coding standard and looks for code smells. It can also look for certain type errors, it can recommend suggestions about how particular blocks can be refactored and can offer you details about the code's complexity.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/pylint).

## Usage

### Interactive

I use this container image with something like the following shell function:

```sh

pylint() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/pylint" \
    "$@"
}

```
