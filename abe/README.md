# abe

[`amazoncorretto:16-alpine`](https://hub.docker.com/_/amazoncorretto/)-based dockerization of [android-backup-extractor](https://github.com/nelenkov/android-backup-extractor), a "utility to extract and repack Android backups created with adb backup"

The image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/abe).

## Usage

When run with `-h`/`--help` the container prints the following usage text:

```
Usage:
  unpack:	abe unpack	<backup.ab> <backup.tar> [password]
  pack:		abe pack	<backup.tar> <backup.ab> [password]
  pack for 4.4:	abe pack-kk	<backup.tar> <backup.ab> [password]
If the filename is `-`, then data is read from standard input
or written to standard output.
Envvar ABE_PASSWD is tried when password is not given
```

### Interactive

The following shell function can assist in running this image interactively:

```sh

abe() {
  if [ -n "$ABE_PASSWD" ]; then
    docker run \
      --rm \
      --interactive \
      --tty \
      --volume "$(pwd):/work" \
      --env "ABE_PASSWD=${ABE_PASSWD}" \
      "backplane/abe" \
      "$@"
  else
    docker run \
      --rm \
      --interactive \
      --tty \
      --volume "$(pwd):/work" \
      "backplane/abe" \
      "$@"
  fi
}

```
