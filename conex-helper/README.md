# conex-helper

[`python:3-alpine`](https://hub.docker.com/_/python/)-based dockerization of a utility program which helps manage the `backplane/conex` github repo

The image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/conex-helper).

## Usage

The program has three primary subcommands: `update-readme`, `update-workflow`, and `metadata`.

### general help text

```
usage: main.py [-h] [--debug] [--dhuser DHUSER] command ...

utility for maintaining the github.com/backplane/conex repo

positional arguments:
  command
    update-readme  update the central readme from the readme files in the container subdirectories
    update-workflow
                   update the github actions workflow file 'docker.yml' with the current list of container subdirectories
    metadata       called during the container build github action to write workflow outputs that get used in later build steps

options:
  -h, --help       show this help message and exit
  --debug          enable debug output (default: False)
  --dhuser DHUSER  the docker hub repo path to use when linking to images (default: backplane)
```

### `update-readme` subcommand

This subcommand is used to update the central `README.md` from the `README.md` files in the container subdirectories.

```
usage: main.py update-readme [-h] [-i HEADER] readme subdir_readmes [subdir_readmes ...]

positional arguments:
  readme                the path to the markdown file to update
  subdir_readmes        the source README.md files to build from

options:
  -h, --help            show this help message and exit
  -i HEADER, --header HEADER
                        header file(s) to include at the beginning of the output (default: [])

```

### `update-workflow` subcommand

This subcommand is used to update the github actions workflow file `docker.yml` with the current list of container subdirectories.

```
usage: main.py update-workflow [-h] [--workflowfile WORKFLOWFILE] [--basedir BASEDIR] [-l]

options:
  -h, --help            show this help message and exit
  --workflowfile WORKFLOWFILE
                        the path to the workflow file to update (in-place) (default: .github/workflows/docker.yml)
  --basedir BASEDIR     the path the repo base (default: .)
  -l, --list            don't make any changes; instead print the container list from the current action file (default: False)

```

### `metadata` subcommand

This subcommand is called during the docker build github action to write workflow outputs that get used in later build steps.

This includes comparing the perishable checksum of the current build context to the perishable checksum label on the corresponding image already on docker hub. This allows builds to be skipped if nothing has changed in the build context.

```
usage: main.py metadata [-h] [--forcedbuilds FORCEDBUILDS] [--repo REPO] [--psumlabel PSUMLABEL] [--platforms PLATFORMS] [--platforms-override-file PLATFORMS_OVERRIDE_FILE] [--licenses LICENSES]
                        [--licenses-override-file LICENSES_OVERRIDE_FILE]
                        contextname

positional arguments:
  contextname           the name of the directory containing the Docker build context

options:
  -h, --help            show this help message and exit
  --forcedbuilds FORCEDBUILDS
                        comma-separated list of container contexts to build, without regard to the context's perishable checksum (default: )
  --repo REPO           the image repo, as given to the 'docker pull' command (default: None)
  --psumlabel PSUMLABEL
                        the namespaced perishable sum label name to apply to the image (default: be.backplane.image.context_psum)
  --platforms PLATFORMS
                        the default list of platforms to build for (default: linux/amd64,linux/arm64,linux/arm/v7)
  --platforms-override-file PLATFORMS_OVERRIDE_FILE
                        the name of a file inside the context directory which lists platforms to build for (default: .build_platforms.txt)
  --licenses LICENSES   the default SPDX License Expression for the primary image content (default: Various Open Source)
  --licenses-override-file LICENSES_OVERRIDE_FILE
                        the name of a file inside the context directory which lists SPDX License Expressions for the primary image content (default: LICENSES.txt)

```

### Interactive Use

The following shell function can assist in running this image interactively:

```sh

conex_helper() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/conex-helper" \
    "$@"
}
```