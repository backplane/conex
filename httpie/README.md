# httpie

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [HTTPie](https://httpie.org/) the versatile command line HTTP client

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


## Usage

### Interactive

You can use a function like this, note the name is `http` not `httpie` when called.

```sh
http() {
  run_flags="--rm -i"
  container_flags="" 

  if [ -t 0 ]; then
    # stdin is a terminal
    # run_flags="${run_flags}" # -t can be a problem here
    container_flags="--ignore-stdin"
  fi
  # else stdin is a pipe or some non-terminal thing

  if [ -t 1 ] && [ -z "$NOFORMAT" ]; then
    # stdout is a terminal
    container_flags="${container_flags} --verbose --pretty=all"
  else
    # stdout is a pipe or something
    container_flags="${container_flags} --print=b --pretty=none"
  fi

  # shellcheck disable=SC2086
  docker run $run_flags "galvanist/conex:httpie" $container_flags "$@"
}
```
