## `vueenv`

A container image for working with [Vue.js](https://vuejs.org/). This image is meant to be used as a builder stage for [Vue CLI](https://cli.vuejs.org/)-based apps in a multi-stage build. It is also very useful during development.

### Usage

#### Interactive

Add this to your shell profile:

```sh
vueenv() {
  docker run \
    -it \
    --rm \
    --volume "$(pwd):/work" \
    --env "HOST=0.0.0.0" \
    --env "PORT=8090" \
    --publish "8090:8090" \
    "galvanist/vueenv:latest" \
    "$@"
}
```

#### As Build Stage

```Dockerfile
FROM galvanist/vueenv:latest as builder

COPY src /work

RUN npm install \
  && npm run build

FROM nginx:1-alpine as server
COPY --from=builder /work/dist/ /usr/share/nginx/html/

# maybe also something like this:
# COPY nginx_conf.d/* /etc/nginx/conf.d/
```
