# conex

This is a repository for utility containers. The latest versions are mirrored to docker hub.

## [`goenv`](goenv/Dockerfile)

### interactive use

This shell function demonstrates using this container in place of having the actual go installation.

```sh
goenv() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/home/user/go/src/local" \
    galvanist/conex:goenv
}
```

Then you just cd to a directory with a go project (or an empty directory) and run `goenv`.

## [`grta`](grta/Dockerfile)

This HTTP endpoint receives webhooks, validates against the PSK, writes the webhook payload to a file.

Meant to be used behind a load balancer that provides TLS

## [`hugo`](hugo/Dockerfile)

This is a `debian:stable-slim`-based containerization of hugo-extended. I use it as a builder in multi-stage container builds, I also run it interactively during development.

### interactive use

This shell function demonstrates using this container in place of having the actual hugo binary.

```sh
hugo() {
  insert=""
  if [ "$1" = "server" ] || [ "$1" = "serve" ]; then
    shift;
    insert="server --bind 0.0.0.0 --port 1313"
  fi

  # shellcheck disable=SC2086
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    --publish "1313:1313" \
    galvanist/conex:hugo \
    hugo \
      $insert \
      "$@"
}
```

You just add the above function to your shell rc file then use hugo normally:

```sh
$ hugo
```

or

```sh
$ hugo serve -D
```

### multistage build usage

```Dockerfile
FROM galvanist/conex:hugo as builder

COPY . .
RUN hugo

FROM nginx:1-alpine as server
COPY --from=builder /work/public/ /usr/share/nginx/html/
```