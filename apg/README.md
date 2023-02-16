# apg

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of apg -- the "Automated Password Generator"

apg is written by Adel I. Mirzazhanov

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

## Caution

This image uses the alpine apk package [which is based on the ubuntu source file](https://git.alpinelinux.org/aports/tree/main/apg/APKBUILD), as of Apr 11 2020 that means: <https://launchpad.net/ubuntu/+archive/primary/+files/apg_2.2.3.orig.tar.gz>.

The debian (and consequently ubuntu) package maintainer [Marc Haber](https://salsa.debian.org/zugschlus) has issued some [important warnings about the apg package](https://packages.debian.org/stable/apg):

> * Please note that there are security flaws in pronounceable password generation schemes (see Ganesan / Davis "A New Attack on Random Pronounceable Password Generators", in "Proceedings of the 17th National Computer Security Conference (NCSC), Oct. 11-14, 1994 (Volume 1)", http://csrc.nist.gov/publications/history/nissc/1994-17th-NCSC-proceedings-vol-1.pdf, pages 203-216) [[updated link here](https://csrc.nist.gov/CSRC/media/Publications/conference-paper/1994/10/11/proceedings-17th-national-computer-security-conference-1994/documents/1994-17th-NCSC-proceedings-vol-1.pdf)]
>
> * Also note that the FIPS 181 standard from 1993 has been withdrawn by NIST in 2015 with no superseding publication. This means that the document is considered by its [publisher] as obsolete and not been updated to reference current or revised voluntary industry standards, federal specifications, or federal data standards.
>
> * apg has not seen upstream attention since 2003, upstream is not answering e-mail, and the upstream web page does not look like it is in good working order. The Debian maintainer plans to discontinue apg maintenance as soon as an actually maintained software with a [comparable] feature set becomes available.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/apg).

## Usage

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

### Interactive

The following shell function can assist in running this image interactively:

```sh

apg() {
  docker run \
    --rm \
    --interactive \
    --tty \
    "backplane/apg" \
    "$@"
}

```
