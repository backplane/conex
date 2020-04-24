# ods_conv

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based utility which converts ODS documents into other formats (currently JSON and CSV)

## Usage

This is the program's usage text:

```
usage: ods_conv [-h] [-j] [-c] odsfiles [odsfiles ...]

convert ODS documents to other formats

positional arguments:
  odsfiles    ODS files to convert

optional arguments:
  -h, --help  show this help message and exit
  -j, --json  write a JSON copy of the document (default: False)
  -c, --csv   write a CSV copy of each worksheet in the document (default: False)
```

### Interactive

I use the following shell function to run this image:

```sh

ods_conv() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:ods_conv" \
    "$@"
}

```
