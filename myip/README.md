# myip

[`scratch`](https://hub.docker.com/_/scratch/)-based single-binary container image which provides an HTTP endpoint which returns the user's own IP address in JSON format

It is meant to be run behind a load balancer that provides TLS.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/myip).

## Usage

This is the output when the container is invoked with the `-h` argument:

```
usage: ./myip

HTTP endpoint reports the user's IP address back to the user

  -listen string
        local address and port to listen on (default "0.0.0.0:8000")
```