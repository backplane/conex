# false

[`scratch`](https://hub.docker.com/_/scratch/)-based single-binary no-op container that always exits unsuccessfully

This container does nothing except exit with exit code 1. It is useful for testing container infrastructure.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/false).

## Usage

```sh
docker run --rm backplane/false
```
