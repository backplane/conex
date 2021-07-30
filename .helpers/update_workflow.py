#!/usr/bin/env python3
""" helper for updating the github action with the current list of subdirectories """
import argparse
import pathlib
import sys
from typing import Any, Dict, Final, List

from ruamel.yaml import YAML

CONTAINER_KEYPATH: Final = "jobs.build-push.strategy.matrix.container"


def build_contexts(base_str: str) -> List[str]:
    """
    return a list of subdirectories of the given path that meet all the following:
    * contains a Dockerfile
    * contains a "README.md"
    * does not contain an item called '.skip'
    """
    dockerfile: Final = "Dockerfile"
    readme: Final = "README.md"
    skip: Final = ".skip"
    skel: Final = ".skel"

    contexts: List[str] = []
    base = pathlib.Path(base_str)
    for subdir in [x for x in base.iterdir() if x.is_dir() and x.name != skel]:
        if not subdir.joinpath(dockerfile).is_file():
            continue
        if not subdir.joinpath(readme).is_file():
            continue
        if subdir.joinpath(skip).exists():
            continue
        contexts.append(str(subdir))

    return sorted(contexts)


def get_keypath(obj: Dict, keypath_str: str, delimiter: str = ".") -> Any:
    """given a deeply nested object and a delimited keypath, retrieve the deep value at that keypath"""
    keypath: List[str] = keypath_str.split(delimiter)
    sub_obj: Any = obj
    for depth, key in enumerate(keypath):
        try:
            sub_obj = sub_obj[key]
        except KeyError:
            raise KeyError(
                f"unable to resolve keypath '{keypath_str}'; failed to "
                f"retrieve '{key}' component (depth: {depth})"
            ) from None
    return sub_obj


def set_keypath(obj: Dict, keypath_str: str, new_value: Any, delimiter: str = "."):
    """given a deeply nested object and a delimited keypath, retrieve the deep value at that keypath"""
    keypath: List[str] = keypath_str.split(delimiter)
    sub_obj: Any = obj
    target_depth = len(keypath) - 1
    for depth, key in enumerate(keypath):
        try:
            if depth == target_depth:
                sub_obj[key] = new_value
            else:
                sub_obj = sub_obj[key]
        except KeyError:
            raise KeyError(
                f"unable to resolve keypath '{keypath_str}'; failed to "
                f"retrieve '{key}' component (depth: {depth})"
            ) from None


def read_yaml(path: str, encoding: str = "utf-8") -> Any:
    """
    load the yaml file at the given path and return its parsed contents
    """
    yaml = YAML()
    with open(path, "rt", encoding=encoding) as yml_in:
        return yaml.load(yml_in)


def write_yaml(path: str, obj: Any, encoding: str = "utf-8"):
    """
    write the given object to the given path in yaml format
    """
    yaml = YAML()
    with open(path, "wt", encoding=encoding) as yml_out:
        yaml.dump(obj, yml_out)


def update_action(path: str, projects: List[str]):
    """
    update the action file at the given path with the given list of projects
    """
    action = read_yaml(path)
    set_keypath(action, CONTAINER_KEYPATH, projects)
    write_yaml(path, action)


def main() -> int:
    """
    entrypoint for direct execution; returns an int suitable for use by sys.exit
    """
    argp = argparse.ArgumentParser(
        description="helper for updating the github action with the current list of subdirectories",
        formatter_class=argparse.HelpFormatter,
    )
    argp.add_argument(
        "actionfile",
        type=str,
        help="the path to the action file to update (in-place)",
    )
    argp.add_argument(
        "--basedir",
        type=str,
        default=".",
        help="the path the repo base",
    )
    argp.add_argument(
        "-l",
        "--list",
        action="store_true",
        help="don't make any changes; instead print the container list from the current action file",
    )

    args = argp.parse_args()

    if args.list:
        action = read_yaml(args.actionfile)
        print("\n".join(get_keypath(action, CONTAINER_KEYPATH)))
        return 0

    update_action(args.actionfile, build_contexts(args.basedir))

    return 0


if __name__ == "__main__":
    sys.exit(main())
