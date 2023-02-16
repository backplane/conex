# audiosprite

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [audiosprite](https://github.com/tonistiigi/audiosprite), the "ffmpeg wrapper that will take in multiple audio files and combines them into a single file"

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/audiosprite).

## Usage

### Interactive

```sh
audiosprite() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/audiosprite" \
    "$@"
}
```
