# cdk-python

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [AWS CDK](https://aws.amazon.com/cdk/), the AWS Cloud Development Kit and Python.

As the site says:

> The AWS Cloud Development Kit (AWS CDK) is an open source software development framework to define your cloud application resources using familiar programming languages.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/cdk-python).

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

cdk-python() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "awsconfig:/config" \
    --volume "$(pwd):/work" \
    "backplane/cdk-python" \
    "$@"
}

```
