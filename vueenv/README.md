# vueenv

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based image for working with [Vue.js](https://vuejs.org/); meant to be run interactively during development and also used as a builder stage for [Vue CLI](https://cli.vuejs.org/)-based apps in a multi-stage image build 

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/vueenv).

## Usage

### Interactive

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
    "backplane/vueenv:latest" \
    "$@"
}
```

### As Build Stage

```Dockerfile
FROM backplane/vueenv:latest as builder

COPY src /work

RUN npm install \
  && npm run build

FROM nginx:1-alpine as server
COPY --from=builder /work/dist/ /usr/share/nginx/html/

# maybe also something like this:
# COPY nginx_conf.d/* /etc/nginx/conf.d/
```
