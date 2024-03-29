# youtube-dl

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [youtube-dl](https://ytdl-org.github.io/youtube-dl/), the command-line media download utility with support for [about 1000 sites](https://ytdl-org.github.io/youtube-dl/supportedsites.html)

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/youtube-dl).

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

youtubedl() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/youtube-dl" \
    "$@"
}

```
