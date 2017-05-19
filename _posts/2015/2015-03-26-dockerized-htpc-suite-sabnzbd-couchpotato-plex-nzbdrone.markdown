---
layout: page
title: "Dockerized HTPC Suite (sabnzbd, couchpotato, nzbdrone, plex)"
categories:
  - project
header: no
tags:
  - usenet
date: "2015-03-26"
excerpt: A "One Ring" to control a dockerized suite of HTPC apps, each in their own isolated container
---

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

## Introduction

Introducing [docker-htpc-suite](https://github.com/funkypenguin/docker-htpc-suite), a set of automated / manual scripts to control an integrated set of "dockerized" HTPC suite of tools, including:

* [sabnzbd][1]
* [couchpotato][2]
* [sonarr][3]
* [plex][4]
* [plexrequests][5]
* [plexpx][6]
* [nzbhydra][7]
* [headphones][8]
* [mylar][9]
* [rtorrent][10] + [rutorrent][11]


[1]: https://sabnzbd.org
[2]: https://couchpota.to/
[3]: https://sonarr.tv/
[4]: https://www.plex.tv
[5]: http://plexrequests.8bits.ca/
[6]: https://github.com/JonnyWong16/plexpy
[7]: https://github.com/theotherp/nzbhydra
[8]: https://github.com/rembo10/headphones
[9]: https://github.com/evilhero/mylar
[10]: https://wiki.archlinux.org/index.php/RTorrent
[11]: https://github.com/Novik/ruTorrent

## Quick Start (using docker-compose)

On a docker-enabled, host, clone the repo:
```` https://github.com/funkypenguin/docker-htpc-suite.git ````

Then change into the working directory:

````
cd docker-htpc-suite
````

Edit docker-compose.yml, and change the media location folder on line 4.

Add a local user to the base docker host named "htpc" with UID 4242 (the meaning of 2 lives). Make sure this user has all the necessary access to the media folder location.

````
useradd -u 4242 -g 4242 -d /path/to/media htpc
````

Start up the docker containers by running ```docker-compose up -d```

This will do the following:

1. Establish a data container for common data access to a path on your filesystem (/srv/data by default), belonging to the user "htpc" with UID 4242

2. Start each app container, creating a subdirectory in the current working directory for its persistent config (database, settings, etc), and linking /data to the data container

You can now connect to your suite on the following URLs:

* sabnzbd : http://localhost:8080
* couchpotato : http://localhost:5050
* nzbdrone : http://localhost:8989
* plex : http://localhost:32400/web/

## Manual Container Management (without docker-compose)

For greater flexibility, you can also manually start each container. The scripts/ folder includes startup scripts for each container, which are intended to be executed from the main repo directory.

For example:

{% highlight bash %}
./scripts/datastore.sh
./scripts/sabnzbd.sh
./scripts/plex.sh
./scripts/couchpotato.sh
./scripts/nzbdrone.sh
{% endhighlight %}

## Planned Enhancements

* Integration of container for rtorrent / rutorrent
* Integration of container to run cron scripts against tools in suite
* Integration of container for nginx configured to proxy each tool, so that only a single port needs to be exposed via docker for management
