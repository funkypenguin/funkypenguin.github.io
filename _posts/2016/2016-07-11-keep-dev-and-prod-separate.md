---
layout: post
category: postmortem
date: 2016-07-11 07:53:33
title: Separate production and dev
excerpt: VMs are cheap. Outages are expensive.
tags: linked, postportem
crosspost_to_medium: true
---

In [Postmortem: Server compromised due to publicly accessible Redis — Kevin Chen](https://kevinchen.co/blog/postmortem-server-compromised/) I read the painful confession of a technically-savvy engineer whose server was compromised due to a lack of separation between production and dev environments:

> I had previously played around with an app that used Redis, and installed Redis using both the package manager and direct download from redis.io. When I was done, I only remembered to uninstall the one from the package manager.

This would have been mitigated by separating production from testing/dev environments

> Redis accepts connections from anywhere and has no password.

Dev environment (especially if you're going to be trialling packages and introducing rapid change) should include some conservative firewalling to permit access from known address ranges only.

> Rather than type the program in like an animal, I found David Butler’s JS console one-liner that automates typing into DigitalOcean’s web VNC client.

A clever workaround - author is obviously technically skilled.

> It doesn’t support any characters that require the shift key, so I encoded the script as hex, then wrote this Python script on the server to decode it ... It took awhile for execsnoop to catch anything, but when it did, I felt like an idiot


> It’s important to know what’s installed! At a medium or large company, this documentation would probably take the form of a Puppet or Chef configuration, but I think I can get away with just writing things down.
> Install things through the package manager when possible. This makes it easier to uninstall the software cleanly.

One of our rules for deployment is that _everything_ is deployed using a package manager. This means that:

1. The package manager's database itself (i.e. yum) is the authoritative source for what applications are installed.
2. The system could recreated based on the above package database, and only config files and data would be required to be restored from backup (as opposed to binaries and dependencies)

> VMs are cheap — don’t reuse them. VMs used for experiments should be deleted afterwards.

This :) Disposable VMs, (or simply containers) for development reduce the risk of change to production systems.

> Follow security best practices even for “throwaway” setups: in this case, it means running Redis as an unprivileged user (no shell, limited filesystem access), binding it to localhost, and setting a password.

In [Prophecy](http://www.prophecy.net.nz), we mitigate these risks with:

1. Deployment checklist requires manual confirmation of every process listening on non-localhost interface
2. Automated external scans (via a slow-running, stealthy nmap process) of exposed IPs and services across our ranges, so that we're advised of unexpected changes to publicly available services.

> Disable root SSH even if password authentication is already disabled. Generally, disable everything that’s not expected to be used.

Or, if key-based root ssh is required, permit it on a per-source-IP basis in /etc/ssh/sshd.conf
