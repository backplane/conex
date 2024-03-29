#!/usr/bin/env python3
""" calculates a perishable checksum for a docker build context """
import datetime
import hashlib
import os
import pathlib
from typing import Any, Dict, Final, List, Optional, Set, Union

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
    returns the given arguments as a set of strings
    """
    # this is just a helper function to make a few things more readable
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
    hasher = hashlib.sha256()

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


def context_psum(
    context_dir: pathlib.Path,
    perishability: str = WEEK,
    dockerfile_name: str = "Dockerfile",
    exclude_dockerfile: bool = False,
    dt: Optional[datetime.datetime] = None,
) -> str:
    """
    returns the perishable checksum for the given container build context directory
    """
    checksum = build_context_checksum(context_dir, dockerfile_name, exclude_dockerfile)
    if not dt:
        dt = datetime.datetime.utcnow()
    insert = dt.strftime(PERISHABILITY_MAP[perishability])
    return hashlib.sha256(f"{checksum}: {insert}".encode("utf-8")).hexdigest()
