---
layout: "post"
title: "LVM-backed devicemapper for Docker on CentOS 7.3"
date: "2017-05-24 21:51"
excerpt: Changing from overlay to devicemapper
tags: docker
crosspost_to_medium: true
---
I've been running Docker on CentOS 7 in my "home lab" for several years, but haven't really changed any default settings. It's worked well enough, and my goal has always been to keep my applications and config separate from the OS installation, making it easy to reinstall / upgrade the docker host.

By default, even the [latest docker](https://docs.docker.com/engine/installation/linux/centos/) ("docker-ce" now) defaults to the "overlayfs" storage driver, which results in poor performance and a messy filesystem.

Partially because I kept running out of space on /var/lib/docker, I decided to update my installation to make use of LVM-backed devicemmapper storage driver instead. I found [this post](https://sumpfgottheit.net/2016/02/27/docker-storage-with-lvm-and-centos-7-2/) which referenced Docker 1.12, but we're already on docker-ce 1.17, so it's a bit out of date.

The following is still necessary:

Create pool and meta volumes, and then combine them to a thin-pool:
````
lvcreate -n docker-pool -L 28G VG-bigdisk
lvcreate -n docker-meta -L 900M VG-bigdisk
lvconvert --type thin-pool --poolmetadata VG-bigdisk/docker-meta VG-bigdisk/docker-pool
````

Create an override file for docker.service, by running
````systemctl edit docker.service````

Paste in the following (find your volume name in /dev/mapper):
````
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon --storage-driver devicemapper --storage-opt dm.thinpooldev=VG--bigdisk---docker--pool
````

And start docker with ````systemctl start docker````

Examine docker with ````docker info````, and confirm your driver is set to "devicemapper":
````
[root@kvm ~]# docker info | grep Storage
Storage Driver: devicemapper
[root@kvm ~]#
````

I can't really see much of a difference yet. Docker still seems to use **/var/lib/docker** to mount some container data, so my mount table is still messier than I'd like, but ````lvs```` and ````docker info```` do show me that my LVM space is being used, so I conclude that the filesystem usage (example below) is unavoidable.

````
<snip>
/dev/dm-18                       10474496     271728  10202768   3% /var/lib/docker/devicemapper/mnt/f868aa6421282ea87d017bbb81fb223606ce0a2528d8f22b1d158a2322ab4e9a
shm                                 65536          0     65536   0% /var/lib/docker/containers/56245f329eff5a3c00e194c2f970301f61a7585531346c7797b4da9e6cb28d5d/shm
/dev/dm-17                       10474496     442224  10032272   5% /var/lib/docker/devicemapper/mnt/93a96fda5dfded65044533d9b444caed9b1b56a7247fe8eb5bb24b34601aef49
shm                                 65536          0     65536   0% /var/lib/docker/containers/5f7a5d54c45a8632f779466a743783698f5e937d3caed9763f2baf657e5bca18/shm
/dev/dm-19                       10474496     887392   9587104   9% /var/lib/docker/devicemapper/mnt/e7ec196c47c87d8c5a73feef2f79ad4e2676a7f60b44ad270d542fac0112ab82
shm                                 65536          0     65536   0% /var/lib/docker/containers/5d8fe3602340660d40debae2d162c2739ee3815a5c57ec09797a00951662df73/shm
[root@kvm ~]#
````
