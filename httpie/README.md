## `httpie`

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [HTTPie](https://httpie.org/).

As their site says:

> HTTPie—aitch-tee-tee-pie—is a command line HTTP client with an intuitive UI, JSON support, syntax highlighting, wget-like downloads, plugins, and more. HTTPie consists of a single http command designed for painless debugging and interaction with HTTP servers, RESTful APIs, and web services, which it accomplishes by:
>
> * Sensible defaults
> * Expressive and intuitive command syntax
> * Colorized and formatted terminal output
> * Built-in JSON support
> * Persistent sessions
> * Forms and file uploads
> * HTTPS, proxies, and authentication support
> * Support for arbitrary request data and headers
> * Wget-like downloads
> * Extensions
> * Linux, macOS, and Windows support
> * And more…


### Usage

#### Interactive

You can use a function like this, note the name is `http` not `httpie` when called.

```sh
http() {
  flags=""
  add_newline=""

  if [ -t 0 ]; then
    # stdin is a terminal
    flags="--ignore-stdin"
  fi
  # else stdin is a pipe or some non-terminal thing

  if [ -t 1 ] && [ -z "$NOFORMAT" ]; then
    # stdout is a terminal
    flags="${flags} --verbose --pretty=all"
    add_newline="1"
  else
    # stdout is a pipe or something
    if [ -n "$NOFORMAT" ]; then
      flags="${flags} --pretty=none"
    else
      flags="${flags} --pretty=format"
    fi
  fi

  # shellcheck disable=SC2086
  docker run --rm "galvanist/conex:httpie" $flags "$@"

  [ -n "$add_newline" ] && printf '\n'
}
```
