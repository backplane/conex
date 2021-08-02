#!/usr/bin/env python3
""" sorts the sections and keys of a docker-compose.yml file """
import argparse
import re
import sys
from typing import Any, Callable, Dict, List, Optional, Pattern

from ruamel.yaml import YAML

PATH_SORT_HINTS = {
    r"^$": [
        "version",
        "services",
        "volumes",
        "networks",
        "secrets",
    ],
    r"^/services/[^/]+$": [
        "image",
        "build",
        "restart",
        "depends_on",
        "environment",
        "secrets",
        "volumes",
        "networks",
        "ports",
    ],
}


def compile_hints(
    path_hints: Dict[str, List[str]]
) -> Dict[Pattern[Any], Callable[[str], int]]:
    """
    given a regex_string:hint_list mapping, return a
    compiled_regex:key_function mapping.

    the key functions returned by this function are used in the context of
    sort(some_iterable, key=keyfunc) context.

    the key function gets called with the name of an item in the list and it
    returns the desired sort position of that item. if the key function is
    called with an item not on the list, it returns the list length, which
    effectively sorts unknown items to the end of the list

    the result looks somthing like this:
    {
        re.compile('^$'): lambda x: {'1st': 0, '2nd': 1, '3rd': 2}.get(x, 3),
        re.compile('^/test$'): lambda x: {'one': 0, 'two': 1}.get(x, 2)
    }
    """
    result: Dict[Pattern[Any], Callable[[str], int]] = dict()
    for path_regex, hint_list in path_hints.items():

        def get_hint(
            key: str,
            hints: Dict[str, int] = {hint: i for i, hint in enumerate(hint_list)},
        ) -> int:
            return hints.get(key, len(hints))

        result[re.compile(path_regex)] = get_hint
    return result


def anymatch(
    hint_dict: Dict[Pattern[Any], Callable[[str], int]],
    path: str,
) -> Optional[Callable[[str], int]]:
    """
    given a hint dictionary and a path, if the path matches any of the regexes
    in the hint_dict, return the corresponding item from the hint_dict
    """
    for regex, hints in hint_dict.items():
        if regex.match(path):
            return hints
    return None


def pappend(path: str, *appendages: str, delimiter: str = "/") -> str:
    """
    aka 'path append', return the concatenation of a given path, a delimiter,
    and the given appendage
    """
    return delimiter.join((path.rstrip(delimiter),) + appendages)


def ordered_dict_copy(
    source: Dict[Any, Any],
    sort_hints: Dict[Pattern[Any], Callable[[str], int]],
    path: str = "",
) -> Dict[Any, Any]:
    """
    returns a copy of the given source data structure with the dicts replaced
    by OrderedDicts and sorted according to the given hints
    """
    dest: Dict[Any, Any] = dict()

    if source is None:
        return dest

    for key in sorted(source, key=anymatch(sort_hints, path)):
        val = source[key]
        if isinstance(val, dict):
            dest[key] = ordered_dict_copy(val, sort_hints, pappend(path, key))
        elif isinstance(val, list):
            dest[key] = ordered_list_copy(val, sort_hints, pappend(path, key))
        else:
            dest[key] = val

    return dest


def ordered_list_copy(
    source: List[Any],
    sort_hints: Dict[Pattern[Any], Callable[[str], int]],
    path: str = "",
) -> List[Any]:
    """
    returns a copy of the given source data structure with the dicts replaced
    by OrderedDicts and sorted according to the given hints
    """
    dest: List[Any] = list()

    for item in source:
        if isinstance(item, dict):
            dest.append(ordered_dict_copy(item, sort_hints, path))
        elif isinstance(item, list):
            dest.append(ordered_list_copy(item, sort_hints, path))
        else:
            dest.append(item)

    return dest


def main() -> int:
    """
    read yaml from stdin, sort it accordingly, write it to stdout
    return a value suitable for sys.exit
    """
    argp = argparse.ArgumentParser(
        description=("command-line utility for sorting docker-compose.yml files")
    )
    argp.add_argument(
        "input_file",
        nargs="?",
        help=("the file to sort, if not specified STDIN will be used"),
    )
    args = argp.parse_args()

    if args.input_file:
        input_file = open(args.input_file, "r")
    else:
        input_file = sys.stdin

    yaml = YAML()
    composition = yaml.load(input_file)
    sorted_composition = ordered_dict_copy(composition, compile_hints(PATH_SORT_HINTS))
    yaml.dump(sorted_composition, sys.stdout)

    return 0


if __name__ == "__main__":
    sys.exit(main())
