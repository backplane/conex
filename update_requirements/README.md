# update_requirements

[`python:3-alpine`](https://hub.docker.com/_/python/)-based dockerization of [update_requirements](https://github.com/backplane/update_requirements), the utility for updating requirements files

The program updates Python `requirements.txt` files (optionally in-place), sorts them, and updates the version numbers therein. *NOTE:* Currently, version numbers are updated without regard for the version comparison operators already in the requirements file, this can do bad things in non-trivial requirements files. This limitation is likely to change in the future.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/update_requirements).

## Usage

### Help Text

The following text is printed when the program is invoked with the `-h` or `--help` flags:

```
usage: update_requirements [-h] [-d] [-i] file [file ...]

Update requirements.txt files (optionally in-place); NOTE: Currently, version
numbers are updated without regard for the version comparison operators in the
requirements file, this is likely to change in the future

positional arguments:
  file           path to the requirements.txt file

options:
  -h, --help     show this help message and exit
  -d, --debug    enable more verbose output (default: False)
  -i, --inplace  update the file in-place instead of printing to stdout
                 (default: False)
```

### Interactive Use Example

The following example demonstrates using the container:

```sh
docker run --rm --volume "$(pwd):/work" backplane/update_requirements --inplace requirements.txt
```
