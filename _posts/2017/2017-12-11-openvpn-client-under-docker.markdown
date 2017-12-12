---
layout: "post"
title: "OpenVPN client under docker"
date: "2017-12-11 21:09"
category: note
excerpt: "How to get openvpn client in a docker container"
---
Recently I needed to connect my Docker swarm manager nodes (running CentOS Atomic) to my OpenVPN server, running on a [pfsense](http://www.pfsense.org) firewall.

Turns out it's not quite straightforward - I recorded the steps required in a [reference note](https://geek-cookbook.funkypenguin.co.nz/reference/openvpn/) on the Geek Cookbook.
