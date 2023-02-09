#!/usr/bin/env python3
""" utility """
import logging
import os
import pathlib
from typing import List

from bs4 import BeautifulSoup
from dhmanifest import manifest_for_repotag
from markdown import Markdown
from psum import context_psum
from readme import parse_readme


def markdown_to_text(md: str) -> str:
    """
    given a string of markdown-formatted text, return the plaintext representation
    """
    html = Markdown().convert(md)
    return BeautifulSoup(html, features="html.parser").get_text()


def gh_output(name: str, value: str) -> None:
    """
    write the given value with the given name in github workflow step output format
    """
    try:
        output_file = os.environ["GITHUB_OUTPUT"]
    except KeyError:
        logging.error(
            "the GITHUB_OUTPUT environment variable is required for "
            "this proram to work"
        )
        raise

    with open(output_file, "at", encoding="utf-8") as out:
        out.write(f"{name}={value}\n")


def stripped_contents(path: pathlib.Path, encoding="utf-8") -> str:
    """
    return the contents of the file at the given path, with leading and
    trailing whitespace removed
    """
    with open(path, "rt", encoding=encoding) as fh:
        return fh.read().strip()


def emit_metadata(
    context_name: str,
    repo: str,
    platforms: str,
    licenses: str,
    forced_builds: List[str],
    psumlabel: str,
    platforms_override_file: str,
    licenses_override_file: str,
):
    """
    print github actions workflow outputs relevant to the given docker build
    information
    """

    # sanity-check the context argument
    if "/" in context_name or context_name.startswith("."):
        raise RuntimeWarning(
            "the contextname argument is expected to be a bare directory "
            "name, not a path"
        )
    context_path = pathlib.Path(context_name)
    if not context_path.is_dir():
        raise RuntimeError(
            f"the given context argument {context_name} is not a directory"
        )

    # init the output values
    local_psum: str = context_psum(context_path)
    skipbuild: bool = False
    description: str = "Utility Container Image"

    # see if we can skip the build because the current context psum matches the
    # published one
    if repo:
        if context_name in forced_builds:
            skipbuild = False  # redundant, but explicit
        else:
            # check if the published psum matched
            published_psum = manifest_for_repotag(
                repo,
                keypath=f"config/Labels/{psumlabel}",
            )
            if published_psum == local_psum:
                skipbuild = True

    context_files = [f for f in context_path.iterdir() if f.is_file()]

    platforms_override = context_path.joinpath(platforms_override_file)
    if platforms_override in context_files:
        platforms = stripped_contents(platforms_override)

    licenses_override = context_path.joinpath(licenses_override_file)
    if licenses_override in context_files:
        licenses = stripped_contents(licenses_override)

    readme_file = context_path.joinpath("README.md")
    if readme_file in context_files:
        readme = parse_readme(readme_file)
        if "slug" in readme:
            description = markdown_to_text(readme["slug"])

    gh_output("psum", local_psum)
    gh_output("skipbuild", str(int(skipbuild)))
    gh_output("platforms", platforms)
    gh_output("licenses", licenses)
    gh_output("description", description)
