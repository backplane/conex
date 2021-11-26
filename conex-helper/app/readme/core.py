#!/usr/bin/env python3
""" Utility for (re)generating the main README in this repo """
import os
import re
from typing import List

README_REGEX = re.compile(
    (
        r"^\s*"
        r"#\s+(?P<title>[^\n]+?)\s*\n"
        r"\n"
        r"(?P<slug>[^\n]{3,}?)\s*\n"
        r"\n"
        r".*"
    ),
    re.DOTALL,
)


def parse_readme(path):
    """
    read the README.md file at the given path and return a tuple of information
    about it (title, slug)
    """
    with open(path, "r") as readme:
        contents = readme.read()

    match = README_REGEX.match(contents)
    if not match:
        raise RuntimeError("Couldn't parse README at {}".format(path))

    return match.groupdict()


def shortpath(path):
    """
    return the given path with only the filename and its parent directory
    e.g. /usr/home/someone/conex/bpython/README.md -> bpython/README.md
    """
    return os.sep.join(path.split(os.sep)[-2:])


def get_row(*fields) -> str:
    """
    given a list of fields, print them joined by the markdown table column
    delimiter ' | '
    """
    return f"{' | '.join(fields)}\n"


def get_table(readmes: List[str], dhuser: str) -> str:
    """prints the markdown table of images"""
    result = ""

    headings = ["Name", "Description", "Dockerfile Link", "Image Link"]

    img_link_fmt = "https://hub.docker.com/r/{user}/{repo}"

    # print the headings
    result += get_row(*headings)

    # print the dashes below each heading - required for markdown tables
    # explicitly left-aligning by beginning them with :
    result += get_row(*[":" + ("-" * (len(heading) - 1)) for heading in headings])

    for readme_path in readmes:
        abspath_readme = os.path.abspath(readme_path)
        abspath_dockerfile = os.sep.join(
            [os.path.dirname(abspath_readme), "Dockerfile"]
        )

        subdir = abspath_readme.split(os.sep)[-2]
        # readme_link = shortpath(abspath_readme)
        dockerfile_link = shortpath(abspath_dockerfile)

        readme = parse_readme(readme_path)

        result += get_row(
            # link to subdir with complete readme and container source
            "[{}]({})".format(readme["title"], subdir),
            # short description from first non-empty, non-header line of readme
            "{}".format(readme["slug"]),
            # link directly to dockerfile for the image
            "[Dockerfile]({})".format(dockerfile_link),
            # link to the image on dockerhub
            "[{dhlinktext}]({dhlinkurl})".format(
                dhlinktext="/".join([dhuser, subdir]),
                dhlinkurl=img_link_fmt.format(user=dhuser, repo=subdir),
            ),
        )
    return result


def get_file(path, encoding="utf-8") -> str:
    """open the given file for reading, print it to stdout"""
    with open(path, "rt", encoding=encoding) as fh:
        return fh.read()
