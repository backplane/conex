# toolbox

[`ubuntu:latest`](https://hub.docker.com/_/ubuntu/)-based image that includes a collection of common debugging tools for developers and system administrators

The image provides convenient access to these tools in isolated environments.

## Tools

The following tools are installed:

- **age**: simple, modern and secure encryption tool
- **bash**: The Bourne Again SHell.
- **bind9-dnsutils**: DNS utilities for debugging domain name services.
- **chardet**: Universal Character Encoding Detector
- **curl**: Command-line tool for transferring data using various protocols (HTTP, HTTPS, FTP).
- **file**: Recognize the type of data in a file using "magic" numbers
- **iproute2**: Advanced IP packet routing and management tools.
- **iputils-ping**: Tools for testing network connectivity (ping, traceroute).
- **mtr**: Full screen ncurses traceroute tool
- **nano**: Lightweight text editor.
- **neovim**: Modern Vim editor.
- **net-tools**: Network configuration and monitoring tools.
- **netcat-traditional**: TCP/IP utilities (nc).
- **openssl**: Secure Sockets Layer toolkit - cryptographic utility
- **p7zip**: 7-Zip compression tool with encryption support.
- **ripgrep**: Fast search tool combining features of `grep` and `The Silver Searcher`.
- **rsync**: fast, versatile, remote (and local) file-copying tool
- **socat**: multipurpose relay for bidirectional data transfer
- **tmux**: Terminal multiplexer for session management.
- **traceroute**: Tool to trace the route data packets take across networks.
- **unzip**: Utility to extract files in ZIP archives.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/toolbox).

The image is hosted on Docker Hub in the [backplane/toolbox repo](https://hub.docker.com/r/backplane/toolbox).

## Example Usage

This example shows how to run the image with the current working directory mounted into the container:

```sh
docker run --rm -it --volume "$(pwd):/work" backplane/toolbox:latest
```
