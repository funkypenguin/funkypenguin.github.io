---
layout: "post"
title: "DRBD on RHEL/CentOS 6 fails to sync with UnknownMandatoryTag error"
date: "2017-02-01 12:16:00Â"
category: note
excerpt: Because error messages just ruin the surprise!
---
We use [DRBD](https://www.drbd.org/en/) as part of [Linux HA](http://linux-ha.org/wiki/Main_Page) designs. I was recently tasked with setting up DRBD 8.4 for a new customer installation. I chose a complicated, 64-character random string as my shared secret, and configured both nodes.

Big mistake.

DRBD __appeared__ to start, but both nodes were in "Standby" mode, and drbd wouldn't even start listening on TCP port 7788.

When I ran "drbdadm connect drbd0" on one of the nodes, I got an error like this:

````
drbd0: Failure: (126) UnknownMandatoryTag
````

I changed the shared secret to something less complex ("_supersecrit_"), restarted drbd on both nodes, and suddenly drbd started, the nodes synced, and my day improved :)
