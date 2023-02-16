# pygmentize

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the [pygmentize](https://pygments.org/docs/cmdline/) utility from the [Pygments](https://pygments.org/) generic syntax highlighter package

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/pygmentize).

## Usage

### Interactive

```sh

pygmentize() {
  docker run \
    --rm \
    --interactive \
    --volume "$(pwd):/work" \
    "backplane/pygmentize" \
    "$@"
}

```
