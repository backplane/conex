# conex

This is a repository for utility container images. The latest versions are mirrored to docker hub.

### To access these images, see: <https://hub.docker.com/r/galvanist/conex/tags>

## The Images

* [`audiosprite`](#audiosprite)
* [`bpython`](#bpython)
* [`checkmake`](#checkmake)
* [`goenv`](#goenv)
* [`grta`](#grta)
* [`hugo`](#hugo)
* [`vueenv`](#vueenv)

## [`audiosprite`](audiosprite)

This is an alpine-based dockerization of [audiosprite](https://github.com/tonistiigi/audiosprite).

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

> * In-line syntax highlighting
* Readline-like autocomplete with suggestions displayed as you type.
* Expected parameter list for any Python function.
* "Rewind" function to pop the last line of code from memory and re-evaluate.
* Send the code you've entered off to a pastebin.
* Save the code you've entered to a file.
* Auto-indentation.
* Python 3 support.


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
## [`hugo`](hugo)

This is a `debian:stable-slim`-based containerization of hugo-extended. I use it as a builder in multi-stage container builds, I also run it interactively during development.

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
## [`vueenv`](vueenv)

This container image is meant to be used as a builder stage for Vue CLI-based apps in a multi-stage build. It is also very useful during development.

### Usage

#### Interactive

Add this to your shell profile:

```sh
vueenv() {
  docker run \
    -it \
    --rm "$@" \
    --volume "$(pwd):/app" \
    "galvanist/vueenv:latest"
}
```

#### As Build Stage

```Dockerfile
FROM galvanist/vueenv:latest as builder

COPY src /app

RUN npm install \
  && npm run build

FROM nginx:1-alpine as server
COPY --from=builder /app/dist/ /usr/share/nginx/html/

# maybe also something like this:
# COPY nginx_conf.d/* /etc/nginx/conf.d/
```
