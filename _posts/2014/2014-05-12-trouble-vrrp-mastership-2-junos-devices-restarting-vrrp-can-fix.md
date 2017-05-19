---
title: Restart VRRP on JUNOS to fix master/master issues
author: David
layout: post
permalink: /note/trouble-vrrp-mastership-2-junos-devices-restarting-vrrp-can-fix/
header: no
categories:
  - note
tags:
  - junos
  - vrrp
---
I spent about 30 min this evening chasing a non-existing VRRP issue between 2 JUNOS SRX devices after a hardware drop-in replacement. One was configured as master, one as backup. Both were in the _master_ status (normally indicating a lack of L2 connectivity), but each could ping the other on their interface address. The solution, ultimately, was to run `restart vrrp gracefully` on each router, which restored the expected master / backup behavior.
