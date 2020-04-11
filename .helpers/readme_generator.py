#!/usr/bin/python
""" Utility for (re)generating the main README in this repo """
from __future__ import print_function
import argparse
import os
import re
import sys


README_REGEX = re.compile(
    r'^\s*'
    r'#\s+(?P<title>[^\n]+?)\s*\n'
    r'\n'
    r'(?P<slug>[^\n]{3,}?)'
    r'\s*\n'
    r'.*', re.DOTALL)


def parse_readme(path):
    """
    read the file at the given path extract the title and return a tuple
    of information about it (title, slug)
    """
    with open(path, "r") as readme:
        contents = readme.read()

    match = README_REGEX.match(contents)
    if not match:
        raise RuntimeError("Couldn't parse README at {}".format(path))

    return match.groupdict()


def shortpath(path):
    """
    return a version of the path with the the file and its parent directory
    """
    return os.sep.join(path.split(os.sep)[-2:])


def printrow(*fields):
    """
    given a number of fields, print them joined by the markdown table column
    delimiter ' | '
    """
    print(' | '.join(fields))


def print_table(readmes):
    """ prints the markdown table of images """
    headings = [
        "Name",
        "Description",
        "Dockerfile Link",
        "Image Link"
    ]

    printrow(*headings)
    printrow(*[':' + ('-' * (len(heading) - 1))
               for heading in headings])

    for readme_path in readmes:
        abspath_readme = os.path.abspath(readme_path)
        abspath_dockerfile = os.sep.join([
            os.path.dirname(abspath_readme),
            'Dockerfile'
        ])

        subdir = abspath_readme.split(os.sep)[-2]
        # readme_link = shortpath(abspath_readme)
        dockerfile_link = shortpath(abspath_dockerfile)

        readme = parse_readme(readme_path)

        printrow(
            '[{}]({})'.format(readme['title'], subdir),
            '{}'.format(readme['slug']),
            '[Dockerfile]({})'.format(dockerfile_link),
            '[{}]({})'.format(
                "galvanist/conex:{}".format(subdir),
                ("https://hub.docker.com/r"
                 "/galvanist/conex"
                 "/tags?name={}").format(subdir)
            )
        )


def print_file(path):
    """ open the given file for reading, print it to stdout """
    with open(path, "r") as pathfh:
        print(pathfh.read())


def main():
    """ direct command-line entry-point """
    argp = argparse.ArgumentParser(
        description=(
            "Utility for (re)generating the main README in this repo"),
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    argp.add_argument('readmes', nargs="+", help=(
        "the source README.md files to build from"))
    argp.add_argument('-d', '--debug', action="store_true", help=(
        "enable debugging output"))
    args = argp.parse_args()

    print_file("docs/about.md")
    print_file("docs/dockerization.md")
    print("## Images\n")
    print_table(args.readmes)

    return 0


if __name__ == '__main__':
    sys.exit(main())
