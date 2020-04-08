# conex

This is a repository for various utility container images. The [latest versions of these images are mirrored to docker hub](https://hub.docker.com/r/galvanist/conex/tags).

## The Images

* [`adb`](#adb)
* [`audiosprite`](#audiosprite)
* [`bpython`](#bpython)
* [`checkmake`](#checkmake)
* [`fzf`](#fzf)
* [`goenv`](#goenv)
* [`grta`](#grta)
* [`httpie`](#httpie)
* [`hugo`](#hugo)
* [`jq`](#jq)
* [`json-server`](#json-server)
* [`kotlinc`](#kotlinc)
* [`lxde`](#lxde)
* [`myip`](#myip)
* [`pycodestyle`](#pycodestyle)
* [`pygmentize`](#pygmentize)
* [`pylint`](#pylint)
* [`shunit2`](#shunit2)
* [`vueenv`](#vueenv)

## [`adb`](adb)

This is a [`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of the Android [SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools) (using the [debian adb package](https://packages.debian.org/buster/adb)).

Note: In an earlier variant I was getting the package directly from <https://dl.google.com/android/repository/platform-tools-latest-linux.zip>.

### Usage

#### Interactive

something like this... still working on the params

```sh

adb() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --device "/dev/bus/usb/001/004" \
    --volume "$(pwd):/work" \
    "galvanist/conex:adb" \
    "$@"
}

```

## [`audiosprite`](audiosprite)

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [audiosprite](https://github.com/tonistiigi/audiosprite).

### Usage

#### Interactive

```sh
audiosprite() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/data" \
    "galvanist/conex:audiosprite" \
    "$@"
}
```

## [`bpython`](bpython)

This is a lightweight dockerization of [the bpython interpreter](https://bpython-interpreter.org/). As their homepage says:

> bpython is a fancy interface to the Python interpreter for Linux, BSD, OS X and Windows (with some work). bpython is released under the MIT License. It has the following (special) features:
>
>* In-line syntax highlighting
>* Readline-like autocomplete with suggestions displayed as you type.
>* Expected parameter list for any Python function.
>* "Rewind" function to pop the last line of code from memory and re-evaluate.
>* Send the code you've entered off to a pastebin.
>* Save the code you've entered to a file.
>* Auto-indentation.
>* Python 3 support.


### Usage

#### Interactive

I use the following shell function to run this container:

```sh

bpython() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "$@" \
    "galvanist/conex:bpython"
}

```

## [`checkmake`](checkmake)

Alpine-based containerization of [checkmake](https://github.com/mrtazz/checkmake/), the `Makefile` linter.

### Usage

#### Interactive

This shell function demonstrates using this container in place of having the binary installed.

```sh
checkmake() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:checkmake" \
    "$@"
}
```

Examples sessions using the function:

```sh
$ checkmake
checkmake.

  Usage:
  checkmake [options] <makefile>
  checkmake -h | --help
  checkmake --version
  checkmake --list-rules

  Options:
  -h --help               Show this screen.
  --version               Show version.
  --debug                 Enable debug mode
  --config=<configPath>   Configuration file to read
  --format=<format>       Output format as a Golang text/template template
  --list-rules            List registered rules
```

Checking against this repo's `Makefile`:

```
$ checkmake Makefile 
                                                                
      RULE                 DESCRIPTION             LINE NUMBER  
                                                                
  maxbodylength   Target body for "push" exceeds   25           
                  allowed length of 5 (10).                     
  minphony        Missing required phony target    0            
                  "all"                                         
  minphony        Missing required phony target    0            
                  "test"                                        
```

## [`fzf`](fzf)

An [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [fzf](https://github.com/junegunn/fzf). 

### Usage

This is a work in progress. Here's my typical function wrapper. It will need a bit more help to be useful this way.

#### Interactive

```sh

fzf() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:fzf" \
    "$@"
}

```

## [`goenv`](goenv)

### Usage

#### Interactive

This shell function demonstrates using this container in place of having the actual go installation.

```sh
goenv() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/home/user/go/src/local" \
    "$@" \
    galvanist/conex:goenv
}
```

Then you just cd to a directory with a go project (or an empty directory) and run `goenv`.

## [`grta`](grta)

This HTTP endpoint receives webhooks, validates against the PSK, writes the webhook payload to a file (or fifo). Meant to be used behind a load balancer that provides TLS.

### Usage

Coming "soon."

## [`httpie`](httpie)

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [HTTPie](https://httpie.org/).

As their site says:

> HTTPie—aitch-tee-tee-pie—is a command line HTTP client with an intuitive UI, JSON support, syntax highlighting, wget-like downloads, plugins, and more. HTTPie consists of a single http command designed for painless debugging and interaction with HTTP servers, RESTful APIs, and web services, which it accomplishes by:
>
> * Sensible defaults
> * Expressive and intuitive command syntax
> * Colorized and formatted terminal output
> * Built-in JSON support
> * Persistent sessions
> * Forms and file uploads
> * HTTPS, proxies, and authentication support
> * Support for arbitrary request data and headers
> * Wget-like downloads
> * Extensions
> * Linux, macOS, and Windows support
> * And more…


### Usage

#### Interactive

You can use a function like this, note the name is `http` not `httpie` when called.

```sh
http() {
  flags=""
  add_newline=""

  if [ -t 0 ]; then
    # stdin is a terminal
    flags="--ignore-stdin"
  fi
  # else stdin is a pipe or some non-terminal thing

  if [ -t 1 ] && [ -z "$NOFORMAT" ]; then
    # stdout is a terminal
    flags="${flags} --verbose --pretty=all"
    add_newline="1"
  else
    # stdout is a pipe or something
    if [ -n "$NOFORMAT" ]; then
      flags="${flags} --pretty=none"
    else
      flags="${flags} --pretty=format"
    fi
  fi

  # shellcheck disable=SC2086
  docker run --rm "galvanist/conex:httpie" $flags "$@"

  [ -n "$add_newline" ] && printf '\n'
}
```

## [`hugo`](hugo)

This is a [`debian:stable-slim`](https://hub.docker.com/_/debian/)-based containerization of hugo-extended. I use it as a builder in multi-stage container builds, I also run it interactively during development.

### Usage

#### Interactive

This shell function demonstrates using this container in place of having the actual hugo binary.

```sh
hugo() {
  insert=""
  if [ "$1" = "server" ] || [ "$1" = "serve" ]; then
    shift;
    insert="server --bind 0.0.0.0 --port 1313"
  fi

  # shellcheck disable=SC2086
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    --publish "1313:1313" \
    galvanist/conex:hugo \
    hugo \
      $insert \
      "$@"
}
```

You just add the above function to your shell rc file then use hugo normally:

```sh
$ hugo
```

or

```sh
$ hugo serve -D
```

#### As Build Stage

```Dockerfile
FROM galvanist/conex:hugo as builder

COPY . .
RUN hugo

FROM nginx:1-alpine as server
COPY --from=builder /work/public/ /usr/share/nginx/html/
```

## [`jq`](jq)

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [jq](https://stedolan.github.io/jq/).

From the site:

> jq is a lightweight and flexible command-line JSON processor. jq is like sed for JSON data - you can use it to slice and filter and map and transform structured data with the same ease that sed, awk, grep and friends let you play with text.

### Usage

#### Interactive

I use a shell function like this to run the container.

```sh
jq() {
  flags=""

  if [ -t 1 ] && [ -z "$NOFORMAT" ]; then
    # stdout is a terminal
    flags="-C" # colorize json
  else
    # stdout is a pipe or something
    if [ -n "$NOFORMAT" ]; then
      flags="-M -c" # monochrome, compact
    else
      flags="-M" # monochrome
    fi
  fi

  # shellcheck disable=SC2086
  docker run --rm "galvanist/conex:jq" $flags "$@"
}
```

## [`json-server`](json-server)

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [json-server](https://github.com/typicode/json-server).

### Usage

#### Interactive

```sh

json-server() {
  docker run \
    --rm \
    --init \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    --publish "3000:3000" \
    "galvanist/conex:json-server" \
    --host 0.0.0.0 \
    "$@"
}

```

## [`kotlinc`](kotlinc)

Reference: <https://github.com/JetBrains/kotlin>
Releases: <https://github.com/JetBrains/kotlin/releases>

* I don't see published sums so I calculate them myself 😞
* `bash` is an actual dep 😞
* I don't know if the `JDK_nn` defs are actually needed because things seems to work fine without them.
* You can make the image smaller by setting these image build args to empty strings:

  * `INTERACTIVE_EXTRAS` includes `nano` and `vim` by default
  * `DEV_EXTRAS` includes `gradle` by default

### Usage

Still experimenting with this container. Here are some things I'm experimenting with:

#### Interactive

Here's a shell function that you could use to run this container:

```sh

kotlinc() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:kotlinc" \
    "$@"
}

```

#### As Build Stage

```Dockerfile
FROM galvanist/conex:kotlinc as builder

COPY . .

# RUN some kind of kotlinc thing? help me out, I'm just learning kotlin
```

## [`lxde`](lxde)

### Usage

This is a [`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of [TigerVNC](https://tigervnc.org/) running an [LXDE](https://lxde.org/) X11 desktop environment.

Start the container below. A session-specific VNC password will be generated and written to the standard output. Then VNC to localhost and enter the password.

`sudo` is available but you need to set a password for the non-priv user first.

I'm more interested in deploying this in a pod with [noVNC](https://novnc.com/info.html) behind TLS.

#### Interactive

```sh

lxde() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --publish "5900:5900" \
    --volume "lxdehome:/work/" \
    "galvanist/conex:lxde" \
    "$@"
}

```

## [`myip`](myip)

This is a single-binary container that creates an HTTP endpoint which return's the user's own IP address in JSON format.

It is meant to be run behind a load balancer that provides TLS.

## [`pycodestyle`](pycodestyle)

### Usage

#### Interactive

```sh

pycodestyle() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:pycodestyle" \
    "$@"
}

```

## [`pygmentize`](pygmentize)

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the [pygmentize](https://pygments.org/docs/cmdline/) from the [Pygments](https://pygments.org/) generic syntax highlighter.

### Usage

#### Interactive

```sh

pygmentize() {
  docker run \
    --rm \
    --interactive \
    --volume "$(pwd):/work" \
    "galvanist/conex:pygmentize" \
    "$@"
}

```

## [`pylint`](pylint)

### Usage

#### Interactive

```sh

pylint() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:pylint" \
    "$@"
}

```

## [`shunit2`](shunit2)

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based containerization of [shUnit2](https://github.com/kward/shunit2/), the "xUnit-based unit test framework for Bourne-based shell scripts."

### Usage

The container will set the `SHUNIT_PATH` environment variable (to `/shunit`). It will provide the latest version of shunit at `/shunit`. At the end of your shell tests, load shunit with something like the following line:

```sh
# shellcheck source=/dev/null
. ${SHUNIT_PATH:-../shunit}
```

or simply

```
# shellcheck source=/dev/null
. "$SHUNIT_PATH"
```

Then with the interactive shunit2 alias below, 


#### Interactive

```sh

shunit2() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:shunit2" \
    "$@"
}

```

Simply run `shunit2` from the project root directory.

## [`vueenv`](vueenv)

This container image is meant to be used as a builder stage for Vue CLI-based apps in a multi-stage build. It is also very useful during development.

### Usage

#### Interactive

Add this to your shell profile:

```sh
vueenv() {
  docker run \
    -it \
    --rm \
    --volume "$(pwd):/work" \
    --env "HOST=0.0.0.0" \
    --env "PORT=8090" \
    --publish "8090:8090" \
    "galvanist/vueenv:latest" \
    "$@"
}
```

#### As Build Stage

```Dockerfile
FROM galvanist/vueenv:latest as builder

COPY src /work

RUN npm install \
  && npm run build

FROM nginx:1-alpine as server
COPY --from=builder /work/dist/ /usr/share/nginx/html/

# maybe also something like this:
# COPY nginx_conf.d/* /etc/nginx/conf.d/
```

