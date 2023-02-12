# pycodestyle

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pycodestyle](https://pycodestyle.pycqa.org/), the python linter

As the homepage says:

> pycodestyle (formerly pep8) is a tool to check your Python code against some of the style conventions in [PEP 8](http://www.python.org/dev/peps/pep-0008/).

The image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/pycodestyle).

## Usage

### Interactive

I use this container image with something like the following shell function:

```sh

pycodestyle() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/pycodestyle" \
    "$@"
}

```
