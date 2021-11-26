#!/usr/bin/env python3
""" utility for maintaining the github.com/backplane/conex repo """
import argparse
import os
import sys
from typing import Final, List

from buildcontext import emit_metadata
from readme import get_file, get_table
from workflow import (CONTAINER_KEYPATH, build_contexts, get_keypath,
                      read_yaml, update_action)


def update_readme(
    readme_path: str,
    subdir_readmes: List[str],
    header_files: List[str],
    dhuser: str,
    encoding: str = "utf-8",
) -> None:
    """
    handler for the update-readme command
    """
    with open(readme_path, "wt", encoding=encoding) as readme:
        for header_file in header_files:
            readme.write(get_file(header_file) + "\n")
        readme.write("## Images\n\n")
        readme.write(get_table(subdir_readmes, dhuser))


def update_workflow(workflow_file: str, basedir: str, listmode: bool = False) -> None:
    """
    handler for the update-workflow command
    """
    if listmode:
        action = read_yaml(workflow_file)
        print("\n".join(get_keypath(action, CONTAINER_KEYPATH)))
        return

    update_action(workflow_file, build_contexts(basedir))


def metadata(
    context_name: str,
    repo: str,
    platforms: str,
    licenses: str,
    forced_builds_str: str,
    psumlabel: str,
    platforms_override_file: str,
    licenses_override_file: str,
) -> None:
    """
    handler for the metadata command
    """
    emit_metadata(
        context_name,
        repo,
        platforms,
        licenses,
        [name.strip() for name in forced_builds_str.strip().split(",")],
        psumlabel,
        platforms_override_file,
        licenses_override_file,
    )

    pass


def main() -> int:
    """
    entrypoint for direct execution; returns an integer suitable for use with sys.exit
    """
    arg_update_readme: Final = "update-readme"
    arg_update_workflow: Final = "update-workflow"
    arg_metadata: Final = "metadata"

    argp = argparse.ArgumentParser(
        description=("utility for maintaining the github.com/backplane/conex repo"),
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    argp.add_argument(
        "--debug",
        action="store_true",
        help="enable debug output",
    )
    argp.add_argument(
        "--dhuser",
        default="backplane",
        help=("the docker hub repo path to use when linking to images"),
    )

    subp = argp.add_subparsers(metavar="command", dest="command", required=True)

    # update-readme command
    update_readme_cmd = subp.add_parser(
        arg_update_readme,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
        help=(
            "update the central readme from the readme files in the container "
            "subdirectories"
        ),
    )
    update_readme_cmd.add_argument(
        "subdir_readmes",
        nargs="+",
        help="the source README.md files to build from",
    )
    update_readme_cmd.add_argument(
        "--readme",
        default="README.md",
        help="the path to the markdown file to update",
    )
    update_readme_cmd.add_argument(
        "-i",
        "--header",
        default=[],
        action="append",
        help=("header file(s) to include at the beginning of the output"),
    )

    # update-workflow command
    update_workflow_cmd = subp.add_parser(
        arg_update_workflow,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
        help=(
            "update the github actions workflow file 'docker.yml' with the "
            "current list of container subdirectories"
        ),
    )
    update_workflow_cmd.add_argument(
        "--workflowfile",
        type=str,
        default=".github/workflows/docker.yml",
        help="the path to the workflow file to update (in-place)",
    )
    update_workflow_cmd.add_argument(
        "--basedir",
        type=str,
        default=".",
        help="the path the repo base",
    )
    update_workflow_cmd.add_argument(
        "-l",
        "--list",
        action="store_true",
        help=(
            "don't make any changes; instead print the container list from "
            "the current action file"
        ),
    )

    # metadata command
    metadata_cmd = subp.add_parser(
        arg_metadata,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
        help=(
            "called during the container build github action to write workflow "
            "outputs that get used in later build steps"
        ),
    )
    metadata_cmd.add_argument(
        "contextname",
        type=str,
        help="the name of the directory containing the Docker build context",
    )
    metadata_cmd.add_argument(
        "--forcedbuilds",
        type=str,
        default="",
        help=(
            "comma-separated list of container contexts to build, without regard to "
            "the context's perishable checksum"
        ),
    )
    metadata_cmd.add_argument(
        "--repo",
        type=str,
        help="the image repo, as given to the 'docker pull' command",
    )
    metadata_cmd.add_argument(
        "--psumlabel",
        type=str,
        default=os.environ.get("PSUM_LABEL", "be.backplane.image.context_psum"),
        help="the namespaced perishable sum label name to apply to the image",
    )
    metadata_cmd.add_argument(
        "--platforms",
        type=str,
        default=os.environ.get("PLATFORMS", "linux/amd64,linux/arm64,linux/arm/v7"),
        help="the default list of platforms to build for",
    )
    metadata_cmd.add_argument(
        "--platforms-override-file",
        type=str,
        default=os.environ.get("PLATFORMS_OVERRIDE_FILE", ".build_platforms.txt"),
        help=(
            "the name of a file inside the context directory which lists platforms "
            "to build for"
        ),
    )
    metadata_cmd.add_argument(
        "--licenses",
        type=str,
        default=os.environ.get("LICENSES", "Various Open Source"),
        help="the default SPDX License Expression for the primary image content",
    )
    metadata_cmd.add_argument(
        "--licenses-override-file",
        type=str,
        default=os.environ.get("LICENSES_OVERRIDE_FILE", "LICENSES.txt"),
        help=(
            "the name of a file inside the context directory which lists SPDX "
            "License Expressions for the primary image content"
        ),
    )

    args = argp.parse_args()

    if args.command == arg_update_readme:
        update_readme(
            args.readme,
            args.subdir_readmes,
            args.header,
            args.dhuser,
        )
    elif args.command == arg_update_workflow:
        update_workflow(
            args.workflowfile,
            args.basedir,
            args.list,
        )
    elif args.command == arg_metadata:
        repo = args.repo if args.repo else f"{args.dhuser}/{args.contextname}"
        metadata(
            args.contextname,
            repo,
            args.platforms,
            args.licenses,
            args.forcedbuilds,
            args.psumlabel,
            args.platforms_override_file,
            args.licenses_override_file,
        )
    else:
        raise RuntimeError(f"Unknown command '{args.command}'")

    return 0


if __name__ == "__main__":
    sys.exit(main())
