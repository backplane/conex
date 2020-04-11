# pygmentize

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the [pygmentize](https://pygments.org/docs/cmdline/) utility from the [Pygments](https://pygments.org/) generic syntax highlighter package

## Usage

### Interactive

```sh

pygmentize() {
  docker run \
    --rm \
    --interactive \
    --volume "$(pwd):/work" \
    "galvanist/conex:pygmentize" \
    "$@"
}

```
