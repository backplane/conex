# wireproxy

[scratch](https://hub.docker.com/_/scratch/)-based dockerization of [wireproxy](https://github.com/whyvl/wireproxy), the "wireguard client that exposes itself as a socks5 proxy"

As [the site](https://github.com/whyvl/wireproxy) says:

> wireproxy is a completely userspace application that connects to a wireguard peer, and exposes a socks5/http proxy or tunnels on the machine. This can be useful if you need to connect to certain sites via a wireguard peer, but can't be bothered to setup a new network interface for whatever reasons.

This image is built from the latest semantic version tag in the wireproxy repo and uses scratch instead of distroless. **IMPORTANT: we also apply the following patches**:

1. [001-update-deps-2-Feb-2026.patch](https://github.com/backplane/conex/blob/main/wireproxy/patches/001-update-deps-2-Feb-2026.patch) - Update go dependencies to resolve open CVEs
2. [002-apply-upstream-pr-187.patch](https://github.com/backplane/conex/blob/main/wireproxy/patches/002-apply-upstream-pr-187.patch) - Apply the currently-open upstream PR <https://github.com/whyvl/wireproxy/pull/187>
3. [003-swizzle-patched-socks5.patch](https://github.com/backplane/conex/blob/main/wireproxy/patches/003-swizzle-patched-socks5.patch) - Apply some PRs we've sent to things-go/go-socks5. [#113](https://github.com/things-go/go-socks5/pull/113) and [#114](https://github.com/things-go/go-socks5/pull/114), and a security-related dep bump

The build automatically applies all patches found in the https://github.com/backplane/conex/tree/main/wireproxy/patches subdirectory.

| Repo         | URL                                                      |
| ------------ | -------------------------------------------------------- |
| Docker File  | <https://github.com/backplane/conex/tree/main/wireproxy> |
| Docker Image | <https://hub.docker.com/r/backplane/wireproxy>           |

Note: The [wireproxy GitHub repo](https://github.com/whyvl/wireproxy) already has an excellent [Dockerfile](https://github.com/whyvl/wireproxy/blob/master/Dockerfile) with [official wireproxy images on GHCR](https://github.com/whyvl/wireproxy/pkgs/container/wireproxy), you may want to consider using those instead.

For usage information, see the [wireproxy](https://github.com/whyvl/wireproxy) repo.
