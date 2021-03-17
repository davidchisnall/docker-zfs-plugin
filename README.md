# docker-zfs-plugin

This is an opinionated fork of [TrilliumIT/docker-zfs-plugin](https://github.com/TrilliumIT/docker-zfs-plugin)
that philosophically disagrees with the parent project about the use of
fully-qualified dataset names. In particular, this fork **does not** require
(or even accept) them. Instead, when launching the plugin, a parent dataset is
passed in. All further requests to the plugin are scoped underneath that
dataset.


## FAQ

### But why?

Portability. If you have multiple nodes, they may very well use distinct
tank names. (In fact, this is recommended practice according to ZFS devs). With
the parent project's version, you would have to have node-specific configuration
for each container/service, which kind of defeats the purpose of using the
plugin altogether. If you were going to be editing your `docker-compose` file
for each node, why not just do a local bind mount for its mount point?

### What if I want to use different parent datasets for different containers?

Just run multiple instances of the plugin, registered with Docker under
different names.


## Installation

Download the latest binary from Github releases and place it in
`/usr/local/bin/`.

If using a systemd based distribution, copy
[docker-zfs-plugin.service](docker-zfs-plugin.service) to `/etc/systemd/system`.
Then enable and start the service with `systemctl daemon-reload && systemctl
enable docker-zfs-plugin.service && systemctl start docker-zfs-plugin.service`.

## Usage

After the plugin is running, you can interact with it through normal `docker
volume` commands.

Recently, support was added for passing in ZFS attributes from the `docker
volume create` command:

```bash
docker volume create -d zfs -o compression=lz4 -o dedup=on
--name=tank/docker-volumes/data
```

