# hugo

[`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of hugo-extended -- the static site generator

I use it as a builder in multi-stage image builds, I also run it interactively during development.

## Usage

### Interactive

This shell function demonstrates using this container image in place of having the actual hugo binary.

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
    backplane/hugo \
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

### As Build Stage

```Dockerfile
FROM backplane/hugo as builder

COPY . .
RUN hugo

FROM nginx:1-alpine as server
COPY --from=builder /work/public/ /usr/share/nginx/html/
```
