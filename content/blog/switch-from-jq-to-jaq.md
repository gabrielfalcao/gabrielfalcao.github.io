+++
title = "You should Switch From jq to jaq"
slug = "you-should-switch-from-jq-to-jaq"
date = "2026-07-17"
[taxonomies]
tags = ["sed", "jq", "rust", "jaq", "parsing", "SRE", "command-line"]
+++

Every software engineer probably already knows and uses
[jq](https://jqlang.org/) for parsing and transforming json files. JQ
is a great and powerful tool. It's only limitation is that it only works for JSON files.


This is where [`jaq`](https://crates.io/crates/jaq) comes in handy.

Jaq covers almost all, if not all features from JQ, but works not only
with JSON, but with JSON, YAML, CBOR, TOML, and XML.

So, switching from `jq` to `jaq` is a no-brainer.

Even you're not a rust developer it is a good idea to install rust so
that you can install `jaq` from source:

```shell
cargo install jaq
```

If you're not a security freak like myself who worries perhaps a bit
too much about using pre-compiled binaries, you can download the
latest (as to the time of this writing) pre-build release
[v.3.1.0](https://github.com/01mf02/jaq/releases/tag/v3.1.0)

Now simple replace your calls to `jq` to `jaq`, works wonders with TOML and YAML.

For instance, to list the dependencies of a rust crate:

```shell
jaq -r '.dependencies' Cargo.toml
```
