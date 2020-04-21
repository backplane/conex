# pdf

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [poppler-utils](https://pkgs.alpinelinux.org/package/edge/main/x86_64/poppler-utils) with a thin wrapper.

As the site says:

> [Poppler](https://poppler.freedesktop.org/) is a PDF rendering library based on the xpdf-3.0 code base.

## Usage

The image is intended to be used interactively and the following shell function can assist in running this container this way:

```sh

pdf() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:pdf" \
    "$@"
}

```

When invoking the container this way, this help text applies:

```
Usage: pdf [-h|--help] command [command_options [...]]

"command" is one of the following, which runs the corresponding binary from the poppler-utils package:

* attach - adds a new embedded file (attachment) to a PDF
* detach - lists or extracts embedded files in a PDF
* fonts - lists the fonts used in a PDF
* images - saves images from a PDF
* info - prints the contents of the "Info" dictionary (and other useful data) of a PDF
* separate - extract single pages from a PDF
* tocairo - converts PDF files to other formats such as PNG, JPEG, TIFF, PS, EPS, SVG
* tohtml - converts PDF files into HTML
* toppm - converts PDF files to PPM, PGM, or PBM files
* tops - converts PDF files to PostScript files
* totext - converts PDF files to text files
* unite - merges several PDF into one

Each command has additional options (including "-h")
```
