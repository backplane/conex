#!/usr/bin/env python3
""" a tool for getting manifests from docker hub """
# forked from https://github.com/TomasTomecek/download-manifest-from-dockerhub
import argparse
import json
import sys
import urllib.request as url
from typing import Any, Dict, Final, Optional

LOGIN_URL: Final = "https://auth.docker.io/token?service=registry.docker.io&scope=repository:{repository}:pull"
MANIFEST_URL: Final = "https://registry.hub.docker.com/v2/{repository}/manifests/{tag}"


def get_json(request_url: str, headers: Optional[Dict[str, str]] = None):
    """requests a JSON document from the given URL with the given headers"""
    if headers is None:
        headers = dict()

    if "accept" not in headers:
        headers["accept"] = "application/json"

    req = url.Request(request_url)
    for name, value in headers.items():
        req.add_header(name, value)

    resp = url.urlopen(req)  # nosec - these urls are derived from the constants above
    if resp.getcode() != 200:
        # fixme: this is not great. throw an exception, catch it
        pretty_print(resp)
        sys.exit(1)

    return json.loads(resp.read())


def pretty_print(obj: Any):
    """prints the given object in human-readable json format"""
    print(json.dumps(obj, indent=2))


def manifest_for_repo(repo, tag):
    """
    returns the manifest for the corresponding Docker Hub repo and tag
    repo: string, repository (e.g. 'library/fedora')
    tag:  string, tag of the repository (e.g. 'latest')
    """
    response = get_json(LOGIN_URL.format(repository=repo))
    token = response["token"]

    manifest = get_json(
        MANIFEST_URL.format(repository=repo, tag=tag),
        headers={
            "Authorization": f"Bearer {token}",
            "accept": (
                # note: implicit string concatenation
                "application/vnd.docker.distribution.manifest.list.v2+json,"
                "application/vnd.docker.distribution.manifestv2+json"
            ),
        },
    )

    return manifest


def main():
    """entrypoint for command-line execution"""
    argp = argparse.ArgumentParser(
        description="A tool for getting manifests from docker hub"
    )
    argp.add_argument(
        "repotag",
        nargs="+",
        type=str,
        help="<[namespace/]repository[:tag]> - the repo and tag of the desired manifest",
    )
    args = argp.parse_args()

    for repo_tag in args.repotag:
        if ":" in repo_tag:
            repo, tag = repo_tag.split(":")
        else:
            repo, tag = repo_tag, "latest"
        if "/" not in repo:
            repo = "library/" + repo
        pretty_print(manifest_for_repo(repo, tag))

    return 0


if __name__ == "__main__":
    sys.exit(main())
