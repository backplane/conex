#!/usr/bin/python
""" sorts the sections and keys of a docker-compose.yml file """
import argparse
import collections
import re
import sys

import yaml

try:
    from yaml import CDumper as Dumper
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Dumper, Loader

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


def compile_hints(path_hints):
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
    result = dict()
    for path_regex, hint_list in path_hints.items():

        def get_hint(key, hints={hint: i for i, hint in enumerate(hint_list)}):
            return hints.get(key, len(hints))

        result[re.compile(path_regex)] = get_hint
    return result


def anymatch(hint_dict, path):
    """
    given a hint dictionary and a path, if the path matches any of the regexes
    in the hint_dict, return the corresponding item from the hint_dict
    """
    for regex, hints in hint_dict.items():
        if regex.match(path):
            return hints
    return None


def pappend(path, appendage):
    """
    aka 'path append', return the concatenation of a given path, a delimiter,
    and the given appendage
    """
    return "{}{}{}".format(path, "/", appendage)


def ordered_dict_copy(source, sort_hints, path=""):
    """
    returns a copy of the given source data structure with the dicts replaced
    by OrderedDicts and sorted according to the given hints
    """
    dest = collections.OrderedDict()
    hints = anymatch(sort_hints, path)

    if source is None:
        return dest

    for key in sorted(source, key=hints):
        val = source[key]
        if isinstance(val, dict):
            dest[key] = ordered_dict_copy(val, sort_hints, pappend(path, key))
        elif isinstance(val, list):
            dest[key] = ordered_list_copy(val, sort_hints, pappend(path, key))
        else:
            dest[key] = val

    return dest


def ordered_list_copy(source, sort_hints, path=""):
    """
    returns a copy of the given source data structure with the dicts replaced
    by OrderedDicts and sorted according to the given hints
    """
    dest = list()

    for item in source:
        if isinstance(item, dict):
            dest.append(ordered_dict_copy(item, sort_hints, path))
        elif isinstance(item, list):
            dest.append(ordered_list_copy(item, sort_hints, path))
        else:
            dest.append(item)

    return dest


def dump_anydict_as_map(anydict):
    """helper to make the yaml library treat OrderedDicts like mappings"""
    # directly from https://stackoverflow.com/a/8661021
    def _represent_dictorder(self, data):
        return self.represent_mapping("tag:yaml.org,2002:map", data.items())

    yaml.add_representer(anydict, _represent_dictorder)


def main():
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

    dump_anydict_as_map(collections.OrderedDict)

    yml = yaml.safe_load(input_file, Loader=Loader)
    sorted_yml = ordered_dict_copy(yml, compile_hints(PATH_SORT_HINTS))
    print(yaml.safe_dump(sorted_yml, Dumper=Dumper))

    return 0


if __name__ == "__main__":
    sys.exit(main())
