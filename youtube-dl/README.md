# youtube-dl

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [youtube-dl](https://ytdl-org.github.io/youtube-dl/), the command-line media download utility with support for [about 1000 sites](https://ytdl-org.github.io/youtube-dl/supportedsites.html)

## Usage

### Interactive

The following shell function can assist in running this container interactively:

```sh

youtubedl() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:youtube-dl" \
    "$@"
}

```
