---
layout: "post"
title: "Sabnzbd docker container updated, now includes sickbeard_mp4_automator"
date: "2017-01-23 20:42"
category: note
excerpt: "Easily post-process downloaded media for Plex Direct Play, subtitles, sorting, etc."
---

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

# Background

I use the excellent [linuxserver.io](https://hub.docker.com/r/linuxserver/sabnzbd/) docker sabnzbd container for the [sabnzbd](http://sabnzbd.org) component of the [dockerized HTPC suite](/project/dockerized-htpc-suite-sabnzbd-couchpotato-plex-nzbdrone/), my collection of tools and services to automate and consume my home media collection.

A blog reader recently pointed me to the [sickbeard_mp4_automator](https://github.com/mdhiggins/sickbeard_mp4_automator) script. It's a tool which automates the "polishing" of your downloaded media, including adding tags, changing formats, and renaming files based on online databases.

There are many ways to incorporate mp4_automator into your tools - it can do post-processing on Sonarr, CouchPotato, etc. In my case, since sabnzbd downloads all my content, I just wanted to add it as a post-processing step to sabnzbd.

Initially I thought I had no need for post-processing but after some research, I realized it offered the following benefits:

# What will mp4_automator do for me?

1. All my media would be transcoded into an [AppleTV-friendly format](https://support.plex.tv/hc/en-us/articles/200250387-Streaming-Media-Direct-Play-and-Direct-Stream) after downloading, meaning my server, running Plex (in a container, as part of the aforementioned HTPC suite) wouldn't have to transcode media on-the-fly (and potentially stutter).

2. I could have subtitles automatically downloaded and incorporated into my media. This would be useful because typically, by the time I realize my movie is missing subtitles, the popcorn is getting cold, the lights are off, and it's too late to do anything about it!

# How do I get it?

With this in mind, I submitted a [pull request](https://github.com/linuxserver/docker-sabnzbd/pull/19#issuecomment-274387831) to linuxserver.io, to include mp4_automator in the sabnzbd container. I modified the Dockerfile to include all the necessary dependencies (ffmpeg, etc), and to clone the latest version for use. However, this more than doubled the size of the image, and so quite rightly, my pull request was closed.

If you don't care about image size though, mp4_automator is a useful addition to the HTPC toolset, so made my fork of the original docker container available at [funkypenguin/sabnzbd](https://hub.docker.com/r/funkypenguin/sabnzbd/). I've also updated my [dockerized HTPC suite](/project/dockerized-htpc-suite-sabnzbd-couchpotato-plex-nzbdrone/) compose.yml accordingly.

This refreshed build includes the added bonus of providing sabnzbd v1.2.0, the latest version at the time.

# How to use mp4_automator with sabnzbd docker image

By default, you won't notice anything different. Your sabnzbd container (___htpc_sabnzbd_1___, if you use my docker-compose.yml file) will contain an extra directory, /mp4_automator. This is cloned from https://github.com/mdhiggins/sickbeard_mp4_automator at the time of the build.

This doesn't actually matter, as much as the fact that all the mp4_automator dependencies are now installed. You could just clone mp4_automator __again__ into /config from your docker host.

I just "exec'd" into the container:

````
docker exec -it htpc_sabnzbd_1 /bin/bash
````

and copied /mp4_automator to /config/mp4_automator, which is mounted on a volume exposed from my docker host. Then from the docker host, I created autoProcess.ini as described in the [README](https://github.com/mdhiggins/sickbeard_mp4_automator), and configured it as a post-processing script where appropriate.
