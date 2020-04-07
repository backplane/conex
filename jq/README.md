## `jq`

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [jq](https://stedolan.github.io/jq/).

From the site:

> jq is a lightweight and flexible command-line JSON processor. jq is like sed for JSON data - you can use it to slice and filter and map and transform structured data with the same ease that sed, awk, grep and friends let you play with text.

### Usage

#### Interactive

I use a shell function like this to run the container.

```sh
jq() {
  flags=""

  if [ -t 1 ] && [ -z "$NOFORMAT" ]; then
    # stdout is a terminal
    flags="-C" # colorize json
  else
    # stdout is a pipe or something
    if [ -n "$NOFORMAT" ]; then
      flags="-M -c" # monochrome, compact
    else
      flags="-M" # monochrome
    fi
  fi

  # shellcheck disable=SC2086
  exec docker run --rm "galvanist/conex:jq" $flags "$@"
}
```
