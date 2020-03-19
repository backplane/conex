## `bpython`

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
