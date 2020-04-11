# conex

This is a repository of source files for various utility docker images. The corresponding README file for each image usually has some information on how to use it. Feedback/contributions welcome.

The image sources in this repo have weekly <a href="https://hub.docker.com/r/galvanist/conex/tags">scheduled builds published to <img src=".assets/dockerhub.png" width="150" height="28" alt="docker hub"></a>

## Dockerization Guidelines Used

I aspire to these guidelines when dockerizing things _for this repo_ but for prod/critical apps things like version-pinning are required.

* Dockerfile instructions (e.g. `FROM`, `RUN`, `COPY`, `ENTRYPOINT`) should be in uppercase letters.
* Base images directly on well-maintained OS-distro images in the docker hub library like `alpine:edge`, `debian:stable-slim`, or in some cases `ubuntu`. Or use `scratch`.
* Always include a maintainer label
* Limit layers and layer sizes as much as possible with the general layer structure:
	1. OS-level package deps + cleanup (e.g. `apk add` or `apt install`)
	2. App-level package deps + cleanup (e.g. `pip install` or `npm install`). Try to add these via manifest files like `requirements.txt` or `package.json` to enable security scanning.
	3. App code (usually via `COPY` or `curl`) as near to the end of the file as possible
* Fetch via verified TLS. Verify gpg signatures and checksums.
* Drop privs when possible (with `RUN adduser ...` or equivalent then `USER`)
* For `RUN` instructions:

	* Start long instructions with `set -x`
	* Split complex commands across multiple lines using the continuation character `\`
	* Generally use one command per line...
	* ...but split complex commands so they have one argument per line
	* Things like package installs get one package per line, always indented one additional level, sorted alphabetically, ending with a sentinel like true if the package install is the last thing in the run command.
	* Put `&&` at the beginning of the line, not the end.
	
	For example:

	```
	RUN apk add --no-cache \
	    git \
	    make \
	  && true
	```
	
* For entrypoint scripts and other helpers: if you can't clearly and readably write it in POSIX-compliant shell script (i.e., `#!/bin/sh`) then use a real programming language. Do not use bash-isms and other half-measures.
* Lint and check everything (e.g., with tools like `shellcheck`, `pylint`, `go lint`, etc.)
* Use build args to parameterize things like version numbers in package downloads. If you do so, include an adjacent comment with the URL a human and use to check for updates / release notes.
* For contained services, follow the [12 factors](https://en.wikipedia.org/wiki/Twelve-Factor_App_methodology)
* Don't embed secrets in images, don't put secrets in environment variables

## The Images

* [`adb`](#adb)
* [`apg`](#apg)
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
* [`pwgen`](#pwgen)
* [`pycodestyle`](#pycodestyle)
* [`pygmentize`](#pygmentize)
* [`pylint`](#pylint)
* [`shunit2`](#shunit2)
* [`vueenv`](#vueenv)
* [`wireguard`](#wireguard)

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

## [`apg`](apg)

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of apg -- the "Automated Password Generator" by Adel I. Mirzazhanov.

> APG (Automated Password Generator) is the tool set for random password generation. It generates some random words of required type and prints them to standard output. This binary package contains only the standalone version of apg. Advantages:
> 
>  * Built-in ANSI X9.17 RNG (Random Number Generator)(CAST/SHA1)
>  * Built-in password quality checking system (now it has support for Bloom
>    filter for faster access)
>  * Two Password Generation Algorithms:
>     1. Pronounceable Password Generation Algorithm (according to NIST
>        FIPS 181)
>     2. Random Character Password Generation Algorithm with 35
>        configurable modes of operation
>  * Configurable password length parameters
>  * Configurable amount of generated passwords
>  * Ability to initialize RNG with user string
>  * Support for /dev/random
>  * Ability to crypt() generated passwords and print them as additional output.
>  * Special parameters to use APG in script
>  * Ability to log password generation requests for network version
>  * Ability to control APG service access using tcpd
>  * Ability to use password generation service from any type of box (Mac,
>    WinXX, etc.) that connected to network
>  * Ability to enforce remote users to use only allowed type of password
>    generation

### Caution

This container uses the alpine apk package [which is based on the ubuntu source file](https://git.alpinelinux.org/aports/tree/main/apg/APKBUILD), as of Apr 11 2020 that means: <https://launchpad.net/ubuntu/+archive/primary/+files/apg_2.2.3.orig.tar.gz>.

The debian (and consequently ubuntu) package maintainer [Marc Haber](https://salsa.debian.org/zugschlus) has issued some [important warnings about the apg package](https://packages.debian.org/stable/apg):

> * Please note that there are security flaws in pronounceable password generation schemes (see Ganesan / Davis "A New Attack on Random Pronounceable Password Generators", in "Proceedings of the 17th National Computer Security Conference (NCSC), Oct. 11-14, 1994 (Volume 1)", http://csrc.nist.gov/publications/history/nissc/1994-17th-NCSC-proceedings-vol-1.pdf, pages 203-216) [[updated link here](https://csrc.nist.gov/CSRC/media/Publications/conference-paper/1994/10/11/proceedings-17th-national-computer-security-conference-1994/documents/1994-17th-NCSC-proceedings-vol-1.pdf)]
>
> * Also note that the FIPS 181 standard from 1993 has been withdrawn by NIST in 2015 with no superseding publication. This means that the document is considered by its [publisher] as obsolete and not been updated to reference current or revised voluntary industry standards, federal specifications, or federal data standards.
>
> * apg has not seen upstream attention since 2003, upstream is not answering e-mail, and the upstream web page does not look like it is in good working order. The Debian maintainer plans to discontinue apg maintenance as soon as an actually maintained software with a [comparable] feature set becomes available.

### Usage

```
apg   Automated Password Generator
        Copyright (c) Adel I. Mirzazhanov

apg   [-a algorithm] [-r file] 
      [-M mode] [-E char_string] [-n num_of_pass] [-m min_pass_len]
      [-x max_pass_len] [-c cl_seed] [-d] [-s] [-h] [-y] [-q]

-M mode         new style password modes
-E char_string  exclude characters from password generation process
-r file         apply dictionary check against file
-b filter_file  apply bloom filter check against filter_file
                (filter_file should be created with apgbfm(1) utility)
-p substr_len   paranoid modifier for bloom filter check
-a algorithm    choose algorithm
                 1 - random password generation according to
                     password modes
                 0 - pronounceable password generation
-n num_of_pass  generate num_of_pass passwords
-m min_pass_len minimum password length
-x max_pass_len maximum password length
-s              ask user for a random seed for password
                generation
-c cl_seed      use cl_seed as a random seed for password
-d              do NOT use any delimiters between generated passwords
-l              spell generated password
-t              print pronunciation for generated pronounceable password
-y              print crypted passwords
-q              quiet mode (do not print warnings)
-h              print this help screen
-v              print version information
```

#### Interactive

The following shell function can assist in running this container interactively:

```sh

apg() {
  docker run \
    --rm \
    --interactive \
    --tty \
    "galvanist/conex:apg" \
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

A container image for working with the [go](https://golang.org/) programming language. As the homepage says:

> Go is an open source programming language that makes it easy to build simple, reliable, and efficient software. 

This image is meant to be used as a builder stage in a multi-stage build and it is also very useful for interactive use during development.

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
  run_flags="--rm -i"
  container_flags="" 

  if [ -t 0 ]; then
    # stdin is a terminal
    # run_flags="${run_flags}" # -t can be a problem here
    container_flags="--ignore-stdin"
  fi
  # else stdin is a pipe or some non-terminal thing

  if [ -t 1 ] && [ -z "$NOFORMAT" ]; then
    # stdout is a terminal
    container_flags="${container_flags} --verbose --pretty=all"
  else
    # stdout is a pipe or something
    container_flags="${container_flags} --print=b --pretty=none"
  fi

  # shellcheck disable=SC2086
  docker run $run_flags "galvanist/conex:httpie" $container_flags "$@"
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
  run_flags="--rm -i"
  container_flags=""

  if [ -t 0 ]; then
    # stdin is a terminal
    run_flags="${run_flags} -t"
  fi

  if [ -t 1 ] && [ -z "$NOFORMAT" ]; then
    # stdout is a terminal
    container_flags="${container_flags} -C" # colorize json
  else
    # stdout is a pipe or something
    container_flags="${container_flags} -M" # monochrome

    if [ -n "$NOFORMAT" ]; then
      container_flags="${container_flags} -c" # compact
    fi
  fi

  # shellcheck disable=SC2086
  docker run $run_flags "galvanist/conex:jq" $container_flags "$@"
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

This is a single-binary container that creates an HTTP endpoint which returns the user's own IP address in JSON format.

It is meant to be run behind a load balancer that provides TLS.

## [`pwgen`](pwgen)

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pwgen](https://github.com/tytso/pwgen) by [Theodore Ts'o](https://github.com/tytso). This is the same code base as the [pwgen package on debian](https://packages.debian.org/stable/pwgen).

### Usage

```
Usage: pwgen [ OPTIONS ] [ pw_length ] [ num_pw ]

Options supported by pwgen:
  -c or --capitalize
	Include at least one capital letter in the password
  -A or --no-capitalize
	Don't include capital letters in the password
  -n or --numerals
	Include at least one number in the password
  -0 or --no-numerals
	Don't include numbers in the password
  -y or --symbols
	Include at least one special symbol in the password
  -r <chars> or --remove-chars=<chars>
	Remove characters from the set of characters to generate passwords
  -s or --secure
	Generate completely random passwords
  -B or --ambiguous
	Don't include ambiguous characters in the password
  -h or --help
	Print a help message
  -H or --sha1=path/to/file[#seed]
	Use sha1 hash of given file as a (not so) random generator
  -C
	Print the generated passwords in columns
  -1
	Don't print the generated passwords in columns
  -v or --no-vowels
	Do not use any vowels so as to avoid accidental nasty words
```

#### Interactive

Here is a shell function that can simplify use of this container. Note that if you use it this way (without a bind-mount) you won't have access to the `-H` / `--sha1=` feature.

```sh

pwgen() {
  docker run \
    --rm \
    --interactive \
    --tty \
    "galvanist/conex:pwgen" \
    "$@"
}

```

## [`pycodestyle`](pycodestyle)

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pycodestyle](https://pycodestyle.pycqa.org/). As the homepage says:

> pycodestyle (formerly pep8) is a tool to check your Python code against some of the style conventions in [PEP 8](http://www.python.org/dev/peps/pep-0008/).

### Usage

#### Interactive

I use this container with something like the following shell function:

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

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pylint](https://www.pylint.org/). As the docs say:

> Pylint is a tool that checks for errors in Python code, tries to enforce a coding standard and looks for code smells. It can also look for certain type errors, it can recommend suggestions about how particular blocks can be refactored and can offer you details about the code's complexity.

### Usage

#### Interactive

I use this container with something like the following shell function:

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

A container image for working with [Vue.js](https://vuejs.org/). This image is meant to be used as a builder stage for [Vue CLI](https://cli.vuejs.org/)-based apps in a multi-stage build. It is also very useful during development.

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

## [`wireguard`](wireguard)

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [WireGuard](https://www.wireguard.com/), the free open-source VPN software. As the site says:

> WireGuard® is an extremely simple yet fast and modern VPN that utilizes **state-of-the-art** [cryptography](https://www.wireguard.com/protocol/). It aims to be [faster](https://www.wireguard.com/performance/), [simpler](https://www.wireguard.com/quickstart/), leaner, and more useful than IPsec, while avoiding the massive headache. It intends to be considerably more performant than OpenVPN. WireGuard is designed as a general purpose VPN for running on embedded interfaces and super computers alike, fit for many different circumstances. Initially released for the Linux kernel, it is now cross-platform (Windows, macOS, BSD, iOS, Android) and widely deployable. It is currently under heavy development, but already it might be regarded as the most secure, easiest to use, and simplest VPN solution in the industry.

The image uses the `wg` command as its entry-point.

### Usage

It is probably best if you don't use this "experimental" container image for anything sensitive. Experimental isn't exactly the right word because the Dockerfile just installs the recommended package and does nothing else, but using this image means you're trusting my setup, my github account, possibly my docker hub account in addition to the apk server, the apk packager's hardware and accounts, etc.

```
Usage: /usr/bin/wg <cmd> [<args>]

Available subcommands:
  show: Shows the current configuration and device information
  showconf: Shows the current configuration of a given WireGuard interface, for use with `setconf'
  set: Change the current configuration, add peers, remove peers, or change peers
  setconf: Applies a configuration file to a WireGuard interface
  addconf: Appends a configuration file to a WireGuard interface
  syncconf: Synchronizes a configuration file to a WireGuard interface
  genkey: Generates a new private key and writes it to stdout
  genpsk: Generates a new preshared key and writes it to stdout
  pubkey: Reads a private key from stdin and writes a public key to stdout
You may pass `--help' to any of these subcommands to view usage.
```

#### Interactive

Here is a shell function that might help if you want to throw caution to the wind:

```sh

wireguard() {
  docker run \
    --rm \
    --interactive \
    --tty \
    "galvanist/conex:wireguard" \
    "$@"
}

```

