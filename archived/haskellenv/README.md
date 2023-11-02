# haskellenv

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the [Glasgow Haskell Compiler](https://www.haskell.org/ghc/) and [Cabal](https://www.haskell.org/cabal/)

As the [wikipedia Haskell article](https://en.wikipedia.org/wiki/Haskell_(programming_language)) says:

> Haskell is a general-purpose, statically typed, purely functional programming language with type inference and lazy evaluation

As the [GHC site](https://www.haskell.org/ghc/) says:

> GHC is a state-of-the-art, open source, compiler and interactive environment for the functional language Haskell

And as the [cabal site](https://www.haskell.org/cabal/) says:

> Cabal is a system for building and packaging Haskell libraries and programs. It defines a common interface for package authors and distributors to easily build their applications in a portable way. Cabal is part of a larger infrastructure for distributing, organizing, and cataloging Haskell libraries and programs.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/haskellenv).

## Usage

This container image is meant to be run interactively or as a build stage in a multi-stage build.

### Interactive

The following shell function can assist in running this image interactively:

```sh

haskellenv() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/haskellenv" \
    "$@"
}

```

### As Build Stage

```Dockerfile
FROM backplane/haskellenv as builder

COPY src /work

RUN ghc app.hs

FROM alpine:edge
COPY --from=builder /work/app /bin/app

ENTRYPOINT ["/bin/app"]
```
