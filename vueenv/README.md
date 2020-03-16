# vueenv

This container image is meant to be used as a builder stage for Vue CLI-based apps in a multi-stage build. It is also very useful during development.

## Multistage Build Use

```Dockerfile
FROM galvanist/vueenv:latest as builder

COPY src /app

RUN npm install \
  && npm run build

FROM nginx:1-alpine as server
COPY --from=builder /app/dist/ /usr/share/nginx/html/

# maybe also something like this:
# COPY nginx_conf.d/* /etc/nginx/conf.d/
```

## Interactive Use

Add this to your shell profile:

```sh
vueenv() {
  docker run \
    -it \
    --rm "$@" \
    --volume "$(pwd):/app" \
    "galvanist/vueenv:latest"
}
```