# aws-cli

[`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of [aws-cli v2](https://awscli.amazonaws.com/v2/documentation/api/latest/index.html), the Amazon Web Services Command Line Interface utility.

As the site says:

> The AWS Command Line Interface is a unified tool that provides a consistent interface for interacting with all parts of AWS.

Note: there is an [official docker image for the AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-docker.html) (it's `amazon/aws-cli`).

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/aws-cli).

Repo       | URL
---------- | ------------------------------------------------------
GitHub     | <https://github.com/backplane/conex/tree/main/aws-cli>
Docker Hub | <https://hub.docker.com/r/backplane/aws-cli>


## Usage

### Interactive

Here's an example usage:

```sh
docker run --rm -it -v "$HOME/.aws:/work/.aws:ro" "backplane/awscli" ec2 describe-instance-types
```

Here's an example use as a shell function:

```sh
awscli() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$HOME/.aws:/work/.aws:ro" \
    "backplane/awscli" \
    "$@"
}
```
