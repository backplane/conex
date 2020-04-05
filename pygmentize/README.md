## `pygmentize`

This is an alpine-based dockerization of the [pygmentize](https://pygments.org/docs/cmdline/) from the [Pygments](https://pygments.org/) generic syntax highlighter.

### Usage

#### Interactive

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
