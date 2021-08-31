# aws-cli v1

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [aws-cli v1](https://docs.aws.amazon.com/cli/latest/index.html), the Amazon Web Services Command Line Interface utility.

As the site says:

> The AWS Command Line Interface is a unified tool that provides a consistent interface for interacting with all parts of AWS.

Note: there is an [official docker image for the AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-docker.html) (it's `amazon/aws-cli`).

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

awscli() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd)/.aws:/work/.aws" \
    "backplane/awscli" \
    "$@"
}

```
