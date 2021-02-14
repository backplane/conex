# blampy

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerized melange of Python dev tools, including [black](https://black.readthedocs.io/en/stable/) (the python code formatter), [bpython](https://bpython-interpreter.org/) (the enhanced python REPL), [mypy](https://github.com/python/mypy) (the Python type checker), [pycodestyle](https://pycodestyle.pycqa.org/) (the code linter), and [pylint](https://www.pylint.org/) (the error checker).

I use and publish images for all these tools separately, but this container bundles them together with a small wrapper script.

## Usage

### Interactive

I use this image with something like the following shell function:

```sh

blampy() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:blampy" \
    "$@"
}

```
