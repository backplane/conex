# youtube-dl

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [yt-dlp](https://github.com/yt-dlp/yt-dlp/), the command-line media download utility with support for [about 1000 sites](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md)

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
