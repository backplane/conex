# wimlib-imagex

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the [`wimlib-imagex`](https://wimlib.net/man1/wimlib-imagex.html) utility from [the open source Windows Imaging (WIM) library](https://wimlib.net/)

As the site says:

> wimlib-imagex deals with archive files in the Windows Imaging (WIM) format. Its interface is similar to Microsoft’s ImageX, but wimlib-imagex is cross-platform and has useful improvements and extensions

## mkwinpeimg

This dockerization also contains the [mkwinpeimg](https://wimlib.net/man1/mkwinpeimg.html) bash script, but I have not tested it and I have not included bash in this image (adding bash would add 20% to the image size).

You can quickly create a `mkwinpeimg` image this way:

```Dockerfile
FROM backplane/wimlib-imagex
RUN apk add --no-cache bash
ENTRYPOINT [ "/usr/bin/mkwinpeimg" ]
```

## Usage

```
Usage:
    wimlib-imagex append SOURCE WIMFILE [IMAGE_NAME [IMAGE_DESC]]
                    [--boot] [--check] [--nocheck] [--config=FILE]
                    [--threads=NUM_THREADS] [--no-acls] [--strict-acls]
                    [--rpfix] [--norpfix] [--update-of=[WIMFILE:]IMAGE]
                    [--delta-from=WIMFILE] [--wimboot] [--unix-data]
                    [--dereference] [--snapshot] [--create]

    wimlib-imagex apply WIMFILE [IMAGE] TARGET
                    [--check] [--ref="GLOB"] [--no-acls] [--strict-acls]
                    [--no-attributes] [--rpfix] [--norpfix]
                    [--include-invalid-names] [--wimboot] [--unix-data]
                    [--compact=FORMAT]

    wimlib-imagex capture SOURCE WIMFILE [IMAGE_NAME [IMAGE_DESC]]
                    [--compress=TYPE] [--boot] [--check] [--nocheck]
                    [--config=FILE] [--threads=NUM_THREADS]
                    [--no-acls] [--strict-acls] [--rpfix] [--norpfix]
                    [--update-of=[WIMFILE:]IMAGE] [--delta-from=WIMFILE]
                    [--wimboot] [--unix-data] [--dereference] [--solid]
                    [--snapshot]

    wimlib-imagex delete WIMFILE IMAGE [--check] [--soft]

    wimlib-imagex dir WIMFILE [IMAGE] [--path=PATH] [--detailed]

    wimlib-imagex export SRC_WIMFILE SRC_IMAGE DEST_WIMFILE
                        [DEST_IMAGE_NAME [DEST_IMAGE_DESC]]
                    [--boot] [--check] [--nocheck] [--compress=TYPE]
                    [--ref="GLOB"] [--threads=NUM_THREADS] [--rebuild]
                    [--wimboot] [--solid]

    wimlib-imagex extract WIMFILE IMAGE [(PATH | @LISTFILE)...]
                    [--check] [--ref="GLOB"] [--dest-dir=CMD_DIR]
                    [--to-stdout] [--no-acls] [--strict-acls]
                    [--no-attributes] [--include-invalid-names]
                    [--no-globs] [--nullglob] [--preserve-dir-structure]

    wimlib-imagex info WIMFILE [IMAGE [NEW_NAME [NEW_DESC]]]
                    [--boot] [--check] [--nocheck] [--xml]
                    [--extract-xml FILE] [--header] [--blobs]
                    [--image-property NAME=VALUE]

    wimlib-imagex join OUT_WIMFILE SPLIT_WIM_PART... [--check]

    wimlib-imagex mount WIMFILE [IMAGE] DIRECTORY
                    [--check] [--streams-interface=INTERFACE]
                    [--ref="GLOB"] [--allow-other] [--unix-data]

    wimlib-imagex mountrw WIMFILE [IMAGE] DIRECTORY
                    [--check] [--streams-interface=INTERFACE]
                    [--staging-dir=CMD_DIR] [--allow-other] [--unix-data]

    wimlib-imagex optimize WIMFILE
                    [--recompress] [--compress=TYPE] [--threads=NUM_THREADS]
                    [--check] [--nocheck] [--solid]


    wimlib-imagex split WIMFILE SPLIT_WIM_PART_1 PART_SIZE_MB [--check]

    wimlib-imagex unmount DIRECTORY
                    [--commit] [--force] [--new-image] [--check] [--rebuild]

    wimlib-imagex update WIMFILE [IMAGE]
                    [--check] [--rebuild] [--threads=NUM_THREADS]
                    [DEFAULT_ADD_OPTIONS] [DEFAULT_DELETE_OPTIONS]
                    [--command=STRING] [--wimboot-config=FILE]
                    [< CMDFILE]

    wimlib-imagex verify WIMFILE [--ref="GLOB"]

    wimlib-imagex --help
    wimlib-imagex --version

IMAGE can be the 1-based index or name of an image in the WIM file.
For some commands IMAGE is optional if the WIM file only contains one image.
For some commands IMAGE may be "all".

Some uncommon options are not listed; see `man wimlib-imagex' for more details.
```

### Interactive

The following shell function can assist in running this image interactively:

```sh

wimlibimagex() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/wimlib-imagex" \
    "$@"
}

```

#### Splitting Windows Installer WIM files

If you're creating a Windows 10 USB install drive, sometimes you need to split the large `.wim` files into smaller chunks.

The following command will split all excessively large `.wim` files under the current directory into smaller `.swm` files:

```sh
find . -size +4294967000c -iname '*.wim' -print | while read -r wimpath; do
  wimbase="$(basename "$wimpath" '.wim')"
  wimdir="$(dirname "$wimpath")"
  echo "splitting ${wimpath}"
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/wimlib-imagex" \
      split "$wimpath" "${wimdir}/${wimbase}.swm" 4000
done
```
