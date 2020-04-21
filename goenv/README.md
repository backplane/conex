# goenv

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the [go](https://golang.org/) programming language compiler and tools

As the homepage says:

> Go is an open source programming language that makes it easy to build simple, reliable, and efficient software. 

This image is meant to be used as a builder stage in a multi-stage build and it is also very useful for interactive use during development.

## Usage

### Interactive

This shell function demonstrates using this container in place of having the actual go installation.

```sh
goenv() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/home/user/go/src/local" \
    "$@" \
    galvanist/conex:goenv
}
```

Then you just cd to a directory with a go project (or an empty directory) and run `goenv`.
