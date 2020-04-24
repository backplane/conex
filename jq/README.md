# jq

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [jq](https://stedolan.github.io/jq/)

From the site:

> jq is a lightweight and flexible command-line JSON processor. jq is like sed for JSON data - you can use it to slice and filter and map and transform structured data with the same ease that sed, awk, grep and friends let you play with text.

## Usage

### Interactive

I use a shell function like this to run the image.

```sh
jq() {
  run_flags="--rm -i"
  container_flags=""

  if [ -t 0 ]; then
    # stdin is a terminal
    run_flags="${run_flags} -t"
  fi

  if [ -t 1 ] && [ -z "$NOFORMAT" ]; then
    # stdout is a terminal
    container_flags="${container_flags} -C" # colorize json
  else
    # stdout is a pipe or something
    container_flags="${container_flags} -M" # monochrome

    if [ -n "$NOFORMAT" ]; then
      container_flags="${container_flags} -c" # compact
    fi
  fi

  # shellcheck disable=SC2086
  docker run $run_flags "galvanist/conex:jq" $container_flags "$@"
}
```
