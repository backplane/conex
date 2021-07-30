#!/usr/bin/env python3
""" calculates a perishable checksum for a docker build context """
import argparse
import datetime
import hashlib
import os
import pathlib
import sys
from typing import Any, Dict, Final, List, Set, Union

DOCKERIGNORE_FILENAME: Final = ".dockerignore"

YEAR: Final = "year"
MONTH: Final = "month"
WEEK: Final = "week"
DAY: Final = "day"
HOUR: Final = "hour"
MINUTE: Final = "minute"

PERISHABILITY_MAP: Dict[str, str] = {
    YEAR: "%Y",
    MONTH: "%Y-%m",
    WEEK: "%Y-%U",
    DAY: "%Y-%m-%d",
    HOUR: "%Y-%m-%dT%H",
    MINUTE: "%Y-%m-%dT%H:%M",
}


def parse_isoformat(datestr: str) -> datetime.datetime:
    """
    return the given ISO 8601-formatted date string as a datetime.datetime object in the UTC timezone
    """
    # YYYY-MM-DD[*HH[:MM[:SS[.fff[fff]]]][+HH:MM[:SS[.ffffff]]]] (where * is any char)
    # see https://docs.python.org/3/library/datetime.html#datetime.datetime.fromisoformat
    dt = datetime.datetime.fromisoformat(datestr)
    return dt.astimezone(datetime.timezone.utc)


def parse_dockerignore(path: Union[str, pathlib.Path]) -> Set[str]:
    """parse a .dockerignore file and return a set of listed exclusion patterns"""
    # https://docs.docker.com/engine/reference/builder/#dockerignore-file

    patterns: List[str] = []
    with open(path, "rt", encoding="utf-8") as dockerignore:
        for line in dockerignore:
            pattern = line.strip()
            if pattern.startswith("#") or pattern == "":
                continue
            patterns.append(os.path.normpath(pattern))
    return set(patterns)


# def sha512_file(path: Union[str, pathlib.Path], read_buffer: int = 131072) -> str:
#     """
#     return the hexdigest of the sha512 checksum of the contents of the file at the given path
#     """
#     hasher = hashlib.sha512()
#     with open(path, "rb") as fh:
#         while buf := fh.read(read_buffer):
#             hasher.update(buf)
#     return hasher.hexdigest()


def sset(*args: Any) -> Set[str]:
    """
    returns the set of the string version(s) of the give argument(s)
    """
    # just a dumb helper function to make a few things more readable
    return set([str(arg) for arg in args])


def build_context_checksum(
    contextdir: pathlib.Path,
    dockerfile_name: str = "Dockerfile",
    skip_dockerfile: bool = False,
    include_filenames: bool = True,
    buffer_size: int = 131072,
) -> str:
    """
    for the given "build context" path, attempt to calculate a checksum of all
    files in the path honoring the .dockerignore file if found. returns the
    hexdigest of the checksum of all data in all the files in the context
    """
    if not contextdir.is_dir():
        raise RuntimeError(f"the given contextdir '{contextdir}' is not a directory")

    exclusions: Set[str] = set()
    hasher = hashlib.sha512()

    dockerignore = contextdir.joinpath(DOCKERIGNORE_FILENAME)
    if dockerignore.is_file():
        exclusions |= sset(dockerignore)  # ignore the dockerignore
        for pattern in parse_dockerignore(dockerignore):
            exclusions |= sset(*contextdir.glob(pattern))

    if skip_dockerfile:
        dockerfile = contextdir.joinpath(dockerfile_name)
        if dockerfile.is_file():
            exclusions |= sset(dockerfile)  # ignore the Dockerfile

    for path_str, subdirs, files in os.walk(contextdir):
        path = pathlib.Path(path_str)

        # apply subdir exclusions
        excluded_subdirs = [s for s in subdirs if str(path.joinpath(s)) in exclusions]
        for s in excluded_subdirs:
            subdirs.remove(s)

        subdirs.sort()

        for filename in sorted(files):
            file_path = str(path.joinpath(filename))
            # apply file exclusions
            if file_path in exclusions:
                # print(f"skpping {file_path}")
                continue

            if include_filenames:
                hasher.update(file_path.encode("utf-8"))

            # feed the bytes of this file to the hasher
            with open(file_path, "rb") as fh:
                while buf := fh.read(buffer_size):
                    hasher.update(buf)

    return hasher.hexdigest()


def main() -> int:
    """
    entrypoint for direct execution; print the perishable checksum for the given container build context
    returns an integer suitable for use with sys.exit
    """
    argp = argparse.ArgumentParser(
        description=(
            "utility for calculating a perishable checksum for a docker build "
            "context. 'perishable' means that part of the current UTC date is "
            "included in the checksummed data. this is useful for tagging "
            "container images, this way a container image can be rebuilt "
            "whenever the build context changes OR when the UTC week number "
            "(for example) changes."
        ),
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    argp.add_argument(
        "contextdir",
        type=pathlib.Path,
        help="docker build context (a directory) to calcualte the checksum for",
    )
    argp.add_argument(
        "--datetime",
        type=parse_isoformat,
        help="override the current date/time with the given datetime.fromisoformat()-style string",
    )
    argp.add_argument(
        "--dockerfile",
        type=str,
        default="Dockerfile",
        help="set the name of the Dockerfile",
    )
    argp.add_argument(
        "--exclude-dockerfile",
        action="store_true",
        help="exclude the Dockerfile from the context checksum",
    )
    argp.add_argument(
        "-p",
        "--perishability",
        choices=PERISHABILITY_MAP,
        default=DAY,
        help="the maximum amount of time a perishable sum could last",
    )

    args = argp.parse_args()
    checksum = build_context_checksum(
        args.contextdir,
        args.dockerfile,
        args.exclude_dockerfile,
    )
    now = args.datetime if args.datetime else datetime.datetime.utcnow()
    insert = now.strftime(PERISHABILITY_MAP[args.perishability])
    perishable_sum = hashlib.sha512(f"{checksum}: {insert}".encode("utf-8")).hexdigest()
    print(perishable_sum)

    return 0


if __name__ == "__main__":
    sys.exit(main())
