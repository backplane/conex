#!/usr/bin/env python3
""" helper for updating the github action with the current list of subdirectories """
import pathlib
from typing import Any, Dict, Final, List, Union

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
    key: Union[str, int]
    for depth, key in enumerate(keypath):
        try:
            if isinstance(sub_obj, list):
                key = int(key)
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
    key: Union[str, int]
    for depth, key in enumerate(keypath):
        try:
            if isinstance(sub_obj, list):
                key = int(key)
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
    yaml.width = 1000  # type: ignore
    yaml.indent(offset=2, mapping=2, sequence=4)
    with open(path, "wt", encoding=encoding) as yml_out:
        yaml.dump(obj, yml_out)


def update_action(path: str, projects: List[str]):
    """
    update the action file at the given path with the given list of projects
    """
    action = read_yaml(path)
    set_keypath(action, CONTAINER_KEYPATH, projects)
    write_yaml(path, action)
