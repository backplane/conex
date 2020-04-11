# pylint

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pylint](https://www.pylint.org/)

As the docs say:

> Pylint is a tool that checks for errors in Python code, tries to enforce a coding standard and looks for code smells. It can also look for certain type errors, it can recommend suggestions about how particular blocks can be refactored and can offer you details about the code's complexity.

## Usage

### Interactive

I use this container with something like the following shell function:

```sh

pylint() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:pylint" \
    "$@"
}

```
