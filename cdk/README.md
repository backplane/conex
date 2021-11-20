# cdk

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [AWS CDK](https://aws.amazon.com/cdk/), the AWS Cloud Development Kit.

As the site says:

> The AWS Cloud Development Kit (AWS CDK) is an open source software development framework to define your cloud application resources using familiar programming languages.

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

cdk() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "awsconfig:/config" \
    --volume "$(pwd):/work" \
    "backplane/cdk" \
    "$@"
}

```
