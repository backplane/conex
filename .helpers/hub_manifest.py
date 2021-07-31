#!/usr/bin/env python3
""" a tool for getting manifests from docker hub """
# forked from https://github.com/TomasTomecek/download-manifest-from-dockerhub
import argparse
import json
import sys
import urllib.request as url
from typing import Any, Dict, Final, List, Optional, Union

LOGIN_URL: Final = "https://auth.docker.io/token?service=registry.docker.io&scope=repository:{repository}:pull"
MANIFEST_URL: Final = "https://registry.hub.docker.com/v2/{repository}/manifests/{tag}"
BLOB_URL: Final = "https://registry.hub.docker.com/v2/{repository}/blobs/{digest}"


def get_json(request_url: str, headers: Optional[Dict[str, str]] = None):
    """requests a JSON document from the given URL with the given headers"""
    if headers is None:
        headers = dict()

    if "Accept" not in headers:
        headers["Accept"] = "application/json"

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
    if isinstance(obj, str):
        print(obj)
        return
    print(json.dumps(obj, indent=2))


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


def manifest_for_repo(repo, tag):
    """
    returns the manifest for the corresponding Docker Hub repo and tag
    repo: string, repository (e.g. 'library/fedora')
    tag:  string, tag of the repository (e.g. 'latest')
    """
    response = get_json(LOGIN_URL.format(repository=repo))
    token = response["token"]
    request_headers: Dict[str, str] = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.docker.distribution.manifest.v2+json",
    }

    manifest = get_json(
        MANIFEST_URL.format(repository=repo, tag=tag),
        headers=request_headers,
    )

    try:
        digest = get_keypath(manifest, "config.digest")
    except KeyError:
        digest = get_keypath(manifest, "manifests.0.digest")

    blob = get_json(
        BLOB_URL.format(repository=repo, digest=digest),
        headers=request_headers,
    )

    return blob


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
    argp.add_argument(
        "--keypath",
        type=str,
        help="retrieve only the given '/'-delimited keypath from the manifest document",
    )
    args = argp.parse_args()

    for repo_tag in args.repotag:
        repo_tag: str
        if ":" in repo_tag:
            repo, tag = repo_tag.split(":", 1)
        else:
            repo, tag = repo_tag, "latest"
        if "/" not in repo:
            repo = "library/" + repo

        manifest = manifest_for_repo(repo, tag)
        if args.keypath:
            pretty_print(get_keypath(manifest, args.keypath, delimiter="/"))
        else:
            pretty_print(manifest)

    return 0


if __name__ == "__main__":
    sys.exit(main())
