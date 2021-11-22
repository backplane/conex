#!/usr/bin/env python3
""" utility """
import argparse
import os
import pathlib
import sys

from context_psum import context_psum
from hub_manifest import manifest_for_repotag


def output(name: str, value: str) -> None:
    """
    write the given value with the given name in github workflow step output format
    """
    print(f"::set-output name={name}::{value}")


def stripped_contents(path: pathlib.Path, encoding="utf-8") -> str:
    """
    return the contents of the file at the given path, with leading and
    trailing whitespace removed
    """
    with open(path, "rt", encoding=encoding) as fh:
        return fh.read().strip()


def main() -> int:
    """
    entrypoint for direct execution; returns an integer suitable for use with sys.exit
    """
    argp = argparse.ArgumentParser(
        description=(
            "a helper which outputs build context information used in "
            "subsequent build steps"
        ),
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    argp.add_argument(
        "--debug",
        action="store_true",
        help="enable debug output",
    )
    argp.add_argument(
        "--forcebuild",
        type=str,
        default="",
        help="comma-separated list of container contexts to unconditionally build",
    )
    argp.add_argument(
        "--repo",
        type=str,
        help="the image repo, as given to the 'docker pull' command",
    )
    argp.add_argument(
        "--psumlabel",
        type=str,
        default=os.environ.get("PSUM_LABEL", "be.backplane.image.context_psum"),
        help="the namespaced perishable sum label name to apply to the image",
    )
    argp.add_argument(
        "--platforms",
        type=str,
        default=os.environ.get("PLATFORMS", "linux/amd64,linux/arm64,linux/arm/v7"),
        help="the default list of platforms to build for",
    )
    argp.add_argument(
        "--platforms-override",
        type=str,
        default=os.environ.get("PLATFORMS_OVERRIDE", ".build_platforms.txt"),
        help=(
            "the name of a file inside the context directory which lists platforms "
            "to build for"
        ),
    )
    argp.add_argument(
        "--licenses",
        type=str,
        default=os.environ.get("LICENSES", "Various Open Source"),
        help="the default SPDX License Expression for the primary image content",
    )
    argp.add_argument(
        "--licenses-override",
        type=str,
        default=os.environ.get("LICENSES_OVERRIDE", "LICENSES.txt"),
        help=(
            "the name of a file inside the context directory which lists SPDX "
            "License Expressions for the primary image content"
        ),
    )
    argp.add_argument(
        "contextname",
        type=str,
        help="the name of the directory containing the Docker build context",
    )

    args = argp.parse_args()

    # sanity-check the context argument
    if "/" in args.contextname or args.contextname.startswith("."):
        raise RuntimeWarning(
            "the contextname argument is expected to be a bare directory "
            "name, not a path"
        )
    context_path = pathlib.Path(args.contextname)
    if not context_path.is_dir():
        raise RuntimeError(
            f"the given context argument {args.contextname} is not a directory"
        )

    # init the output values
    local_psum: str = context_psum(context_path)
    skipbuild: bool = False
    platforms: str = args.platforms
    licenses: str = args.licenses

    # see if we can skip the build because the current context psum matches the
    # published one
    if args.repo:
        forced_contexts = [name.strip() for name in args.forcebuild.strip().split(",")]
        if args.contextname in forced_contexts:
            skipbuild = False  # redundant, but explicit
        else:
            # check if the published psum matched
            published_psum = manifest_for_repotag(
                args.repo,
                keypath=f"config/Labels/{args.psumlabel}",
            )
            if published_psum == local_psum:
                skipbuild = True

    context_files = [f for f in context_path.iterdir() if f.is_file()]

    platforms_override = context_path.joinpath(args.platforms_override)
    if platforms_override in context_files:
        platforms = stripped_contents(platforms_override)

    licenses_override = context_path.joinpath(args.licenses_override)
    if licenses_override in context_files:
        licenses = stripped_contents(licenses_override)

    output("psum", local_psum)
    output("skipbuild", str(int(skipbuild)))
    output("platforms", platforms)
    output("licenses", licenses)

    return 0


if __name__ == "__main__":
    sys.exit(main())
