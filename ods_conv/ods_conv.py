#!/usr/bin/env python3
"""
odsconvert: convert ODS documents to other formats
"""
import argparse
import csv
import datetime
import json
import os
import re
import sys

import pyexcel_ods3


FILENAME_CHARS = re.compile(r"[^A-Za-z0-9_-]")


def main():
    """
    direct program entry point
    return an exit status integer suitable for use with sys.exit
    """
    argp = argparse.ArgumentParser(
        description="convert ODS documents to other formats",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    argp.add_argument(
        "-j", "--json", action="store_true", help="write a JSON copy of the document"
    )
    argp.add_argument(
        "-c",
        "--csv",
        action="store_true",
        help="write a CSV copy of each worksheet in the document",
    )
    argp.add_argument("odsfiles", nargs="+", help="ODS files to convert")
    args = argp.parse_args()

    if not args.json and not args.csv:
        warn("No output options selected.")
        return 1

    for odsfile in args.odsfiles:
        data = ods_data(odsfile)

        # JSON
        if args.json:
            json_output_path = output_path_for_ext(odsfile, "json")
            write_json(data, json_output_path)

        # CSV
        if args.csv:
            for worksheet_name, worksheet_data in data.items():
                worksheet_ouput_path = output_path_for_ext(
                    odsfile, "csv", addendum=safename(worksheet_name)
                )
                write_csv(worksheet_data, worksheet_ouput_path)

    return 0


def warn(message):
    """
    Print the given message to stderr, with timestamp prepended and newline
    appended, return the message unchanged
    """
    sys.stderr.write("{} {}\n".format(datetime.datetime.now(), message))
    return message


def safename(filename):
    """"
    return a copy of the given string with all characters outside the set
    [A-Za-z0-9_-] replaced by "_"
    """
    return FILENAME_CHARS.sub("_", filename)


def output_path_for_ext(srcpath, ext, addendum=None):
    """ return an output path appropriate for with the given input file path """
    src_dir, src_filename = os.path.split(srcpath)
    src_rootname, _ = os.path.splitext(src_filename)
    counter = 0
    counter_str = ""

    if addendum:
        addendum = "-" + addendum

    while True:
        if counter:
            counter_str = "-{}".format(counter)

        name = os.path.join(
            src_dir, "{}{}{}.{}".format(src_rootname, addendum, counter_str, ext)
        )

        if not os.path.exists(name):
            break

        counter = counter + 1

    return name


def ods_data(path):
    """ return the contents of the given ODS file """
    return pyexcel_ods3.get_data(path)


def write_csv(data, path):
    """ write the given data to the given path in csv format """
    with open(path, "w", newline="") as csvfh:
        out = csv.writer(csvfh, delimiter=",", quoting=csv.QUOTE_MINIMAL)
        for row in data:
            out.writerow(row)


def write_json(data, path):
    """ write the given data to the given path in json format """
    with open(path, "w") as jsonfh:
        json.dump(data, jsonfh)


if __name__ == "__main__":
    try:
        RESULT = main()
    except KeyboardInterrupt:
        sys.stderr.write("\n")
        RESULT = 1
    sys.exit(RESULT)
