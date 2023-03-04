# toybox

[`scratch`](https://hub.docker.com/_/scratch/)-based dockerization of toybox, the BusyBox-alternative with a BSD-license

As [the site](https://landley.net/toybox/about.html) says:

> Toybox combines many common Linux command line utilities together into a single BSD-licensed executable. It's simple, small, fast, and reasonably standards-compliant (POSIX-2008 and LSB 4.1).
>
>Toybox's main goal is to make Android [self-hosting](http://landley.net/aboriginal/about.html#selfhost) by improving Android's command line utilities so it can build an installable Android Open Source Project image entirely from source under a stock Android system. After a talk at the 2013 Embedded Linux Conference explaining this plan ([outline](http://landley.net/talks/celf-2013.txt), [video](https://www.youtube.com/watch?v=SGmtP5Lg_t0)), Google [merged toybox into AOSP](https://lwn.net/Articles/629362/) and began shipping toybox in Android Mashmallow.

This image uses an [`alpine:edge`](https://hub.docker.com/_/alpine/) build step as a staging environment, but is built around the binary releases of toybox found at <https://landley.net/toybox/bin/>

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/toybox).

## Usage

You can launch the container interactively with a command like:

`docker run --rm -it backplane/toybox`

A `nonroot` user is pre-created in the password file, you can access it with Docker's `--user` argument like this:

`docker run --rm -it --user nonroot backplane/toybox`

To see what version of toybox is in the container you can run `toybox --version`, like this:

`docker run --rm backplane/toybox toybox --version`

## Issues

* At present the lack of `stty` can make it a little annoying to work in the toybox shell because you might experience issues with backspace/delete.
* You may also find it unpleasant to operate without shell history.
* The container image license situation is complicated. Time image includes ca-certificates from aports and elements of the password file from alpine. So it's more complicated to use this container than toybox's own BSD0 license.
