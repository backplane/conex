# blampy

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerized melange of Python dev tools, including [black](https://black.readthedocs.io/en/stable/) (the python code formatter), [bpython](https://bpython-interpreter.org/) (the enhanced python REPL), [mypy](https://github.com/python/mypy) (the Python type checker), [pycodestyle](https://pycodestyle.pycqa.org/) (the code linter), and [pylint](https://www.pylint.org/) (the error checker).

I use and publish images for all these tools separately, but this container bundles them together with a small wrapper script.

The image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/blampy).

## Usage

### Interactive

I use this image with something like the following shell function:

```sh

blampy() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/blampy" \
    "$@"
}

```

Running the container with a `-h` or `--help` argument prints the following usage text:

```
Usage: blampy [-h|--help] [-d|--debug] [utility_selection(s)] [--watch] [source_file [...]]

Container which reformats and checks python source code

Source Files vs REPL
 The source_file arguments you give are passed to all the utilities (or
 the utilities you select (see below). If no source_file arguments are
 given, the container run the bpython REPL instead.

 -h / --help           Prints this message
 -d / --debug          Enables the POSIX shell '-x' flag which prints
                       commands and results as they are run

Utilities
 The following utilties are available. By default the container runs them
 all. Alternatively, you may use the flags below to specify which
 utilities to run and in what order (flag repetition is honored).

 --black               Run the black code formatting utility
                       NOTE: BLACK ALTERS YOUR SOURCE FILES DIRECTLY
 --pylint              Run the pylint code linter
 --pycodestyle         Run the pycodestyle error checker
 --mypy                Run the mypy type checker

Watch Mode
 --watch               In watch mode the container runs forever watching
                       for changes in the given source files. When they
                       change, the selected utilities are run on them
                       again
```

Here is an example transcript:

```
$ blampy test.py
>>>>>>>>>>>>>>>>>>    black    <<<<<<<<<<<<<<<<<<
All done! ✨ 🍰 ✨
1 file left unchanged.
>>>>>>>>>>>>>>>>>>   pylint    <<<<<<<<<<<<<<<<<<
************* Module test
test.py:1:0: C0114: Missing module docstring (missing-module-docstring)
test.py:5:8: E0602: Undefined variable 'pd' (undefined-variable)

-------------------------------------
Your code has been rated at -10.00/10

>>>>>>>>>>>>>>>>>> pycodestyle <<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>    mypy     <<<<<<<<<<<<<<<<<<
Success: no issues found in 1 source file
```