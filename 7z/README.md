# 7z

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [p7zip](https://www.7-zip.org/)

As the site says:

> 7-Zip is a file archiver with a high compression ratio.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/7z).

## Usage

### Examples

#### Get help

```sh
docker run --rm -it -v "$(pwd):/work" backplane/7z -h
```

#### Create an archive

```sh
docker run --rm -it -v "$(pwd):/work" backplane/7z a archive.7z examplefile.txt
```

#### Extract

```sh
docker run --rm -it --volume "$(pwd):/work" backplane/7z x archive.7z
```
