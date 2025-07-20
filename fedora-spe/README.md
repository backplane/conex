# fedora-spe

[`fedora:latest`](https://hub.docker.com/_/fedora)-based image with the `@server-product-environment` package group installed.

Aside from installing `@server-product-environment`, no other changes are made in the container.

Repo         | URL
------------ | -------------------------------------------------------------
Source Code  | <https://github.com/backplane/conex/tree/main/fedora-spe>
Docker Image | <https://hub.docker.com/r/backplane/fedora-spe>


## `@server-product-environment` contents

The Fedora package groups are defined in the `comps.xml` file associated with a package repo. The sources for the official Fedora groups live in the [fedora-comps repo](https://pagure.io/fedora-comps) in release-specific files (e.g. `comps-f43.xml.in`).

As of 11-Mar-2025, the definition of `server-product-environment` for Fedora 43 is:

```xml
  <environment>
    <!-- Intended only for the Fedora Server product; other products will not
         show this because they don’t include the fedora-release-server
         package.  Please keep this mostly in sync with
         infrastructure-server-environment. -->
    <id>server-product-environment</id>
    <!-- Translators: Don't translate this product name -->
    <_name>Fedora Server Edition</_name>
    <!-- Should eventually say “with a web UI accessible right after installation”
         or something else to differentiate from
         infrastructure-server-environment. -->
    <_description>An integrated, easier to manage server.</_description>
    <display_order>2</display_order>
    <grouplist>
      <groupid>server-product</groupid>
      <groupid>standard</groupid>
      <groupid>core</groupid>
      <groupid>headless-management</groupid>
      <groupid>hardware-support</groupid>
      <groupid>networkmanager-submodules</groupid>
    </grouplist>
    <optionlist>
      <groupid>container-management</groupid>
      <groupid>domain-client</groupid>
      <groupid>guest-agents</groupid>
      <groupid>server-hardware-support</groupid>
    </optionlist>
  </environment>
```
