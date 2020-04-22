#!/usr/bin/env python3
""" a tool for getting manifests from docker hub """
# forked from https://github.com/TomasTomecek/download-manifest-from-dockerhub
import argparse
import json
import sys

try:
    # python 3
    import urllib.request as url
except ImportError:
    # python 2
    import urllib2 as url


LOGIN_URL = "https://auth.docker.io/token?service=registry.docker.io&scope=repository:{repository}:pull"
MANIFEST_URL = "https://registry.hub.docker.com/v2/{repository}/manifests/{tag}"


def get_json(request_url, headers=None):
    """ requests a JSON document from the given URL with the given headers """
    if headers:
        request_headers = headers
    else:
        request_headers = dict()

    if "accept" not in request_headers:
        request_headers["accept"] = "application/json"

    req = url.Request(request_url)
    for header_name, header_value in request_headers.items():
        req.add_header(header_name, header_value)

    resp = url.urlopen(req)
    if resp.getcode() != 200:
        pretty_print(resp)
        sys.exit(1)

    return json.loads(resp.read())


def pretty_print(obj):
    """ prints the given object in human-readable json format """
    print(json.dumps(obj, indent=2))


def manifest_for_repo(repo, tag):
    """
    returns the manifest for the corresponding Docker Hub repo and tag
    repo: string, repository (e.g. 'library/fedora')
    tag:  string, tag of the repository (e.g. 'latest')
    """

    manifest_types = (
        "application/vnd.docker.distribution.manifest.list.v2+json,"
        "application/vnd.docker.distribution.manifestv2+json"
    )

    response = get_json(LOGIN_URL.format(repository=repo))
    token = response["token"]

    manifest = get_json(
        MANIFEST_URL.format(repository=repo, tag=tag),
        headers={"Authorization": "Bearer {}".format(token), "accept": manifest_types},
    )

    return manifest


def main():
    """ entrypoint for command-line execution """
    argp = argparse.ArgumentParser(
        description="A tool for getting manifests from docker hub"
    )
    argp.add_argument(
        "repotag",
        nargs="+",
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
