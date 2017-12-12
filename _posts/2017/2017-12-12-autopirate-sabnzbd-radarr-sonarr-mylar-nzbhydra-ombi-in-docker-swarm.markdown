---
layout: "post"
title: "AutoPirate : SABnzbd and friends in a docker swarm"
date: "2017-12-12 21:26"
category: "project"
exceeurpt: "Now available in a handy swarm format"
excerpt: "Here's a recipe for SABnzbd and friends (Radarr, Sonarr, Mylar, NZBHydra, Ombi) in a docker swarm"
---
In 2015, I [published](/project/dockerized-htpc-suite-sabnzbd-couchpotato-plex-nzbdrone/)  a docker-compose stack I'd developed to automate media discovery and management with SABnzbd and related tools (_Radarr, CouchPotato, etc_).

I've just finished turning this stack into a [recipe](https://geek-cookbook.funkypenguin.co.nz/recipies/autopirate/) in my [Geek's Cookbook](https://geek-cookbook.funkypenguin.co.nz/) -  here's the introduction:

## Autopirate

Once the cutting edge of the "internet" (_pre-world-wide-web and mosiac days_), Usenet is now a murky, geeky alternative to torrents for file-sharing. However, it's **cool** geeky, especially if you're into having a fully automated media platform.

A good starter for the usenet scene is Reddit's [_r/usenet_](https://www.reddit.com/r/usenet/). Because it's so damn complicated, a host of automated tools exist to automate the process of finding, downloading, and managing content. The tools included in this recipe are as follows:

![Autopirate Screenshot](https://d33wubrfki0l68.cloudfront.net/23ed1c51e673d10fd61bf1416b9f21174d577aa9/7cfa5/images/autopirate.png)

* **[SABnzbd](http://sabnzbd.org)** : downloads data from usenet servers based on .nzb definitions
* **[NZBHydra](https://github.com/theotherp/nzbhydra)** : acts as a "meta-indexer", so that your downloading tools (radarr, sonarr, etc) only need to be setup for a single indexes. Also produces interesting stats on indexers, which helps when evaluating which indexers are performing well.
* **[Sonarr](https://sonarr.tv)** : finds, downloads and manages TV shows
* **[Radarr](https://radarr.video)** : finds, downloads and manages movies
* **[Mylar](https://github.com/evilhero/mylar)** : finds, downloads and manages comic books
* **[Headphones](https://github.com/rembo10/headphones)** : finds, downloads and manages music
* **[Lazy Librarian](https://github.com/itsmegb/LazyLibrarian)** : finds, downloads and manages ebooks
* **[ombi](https://github.com/tidusjar/Ombi)** : provides an interface to request additions to a plex library using the above tools
* **[plexpy](https://github.com/JonnyWong16/plexpy)** : provides interesting stats on your plex server's usage

This recipe presents a method to combine these tools into a single swarm deployment, and make them available securely...

See the complete recipe [here](https://geek-cookbook.funkypenguin.co.nz/recipies/autopirate/).
