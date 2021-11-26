#!/usr/bin/env python3
""" a tool for getting manifests from docker hub """
# forked from https://github.com/TomasTomecek/download-manifest-from-dockerhub
import json
import sys
import urllib.request as url
from typing import Any, Dict, Final, List, Optional, Union
from urllib.error import URLError

LOGIN_URL: Final = "https://auth.docker.io/token?service=registry.docker.io&scope=repository:{repository}:pull"
MANIFEST_URL: Final = "https://registry.hub.docker.com/v2/{repository}/manifests/{tag}"
BLOB_URL: Final = "https://registry.hub.docker.com/v2/{repository}/blobs/{digest}"


def get_json(request_url: str, headers: Optional[Dict[str, str]] = None) -> Any:
    """requests a JSON document from the given URL with the given headers"""
    if headers is None:
        headers = dict()

    if "Accept" not in headers:
        headers["Accept"] = "application/json"

    req = url.Request(request_url)
    for name, value in headers.items():
        req.add_header(name, value)

    try:
        resp = url.urlopen(req)  # nosec - url derived from the constants above
    except URLError:
        return None

    if resp.getcode() != 200:
        # fixme: this is not great. throw an exception, catch it
        pretty_print(resp)
        sys.exit(1)

    return json.loads(resp.read())


def pretty_print(obj: Any) -> None:
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


def manifest_for_repo(repo, tag) -> Any:
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


def manifest_for_repotag(
    repotag: str,
    keypath: Optional[str] = None,
    keypath_delimiter: str = "/",
) -> Any:
    """
    returns the manifest for the corresponding Docker repotag ([namespace/]repository[:tag])
    """
    if ":" in repotag:
        repo, tag = repotag.split(":", 1)
    else:
        repo, tag = repotag, "latest"
    if "/" not in repo:
        repo = f"library/{repo}"

    manifest = manifest_for_repo(repo, tag)
    if not manifest:
        return None

    if not keypath:
        return manifest

    try:
        return get_keypath(manifest, keypath, keypath_delimiter)
    except KeyError:
        return None
