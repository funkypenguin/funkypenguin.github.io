---
title: Clearing static nat on Cisco router
layout: post
permalink: /note/clearing-static-nat-on-cisco-router/
header: no
categories:
  - note
tags:
  - cisco
---
I was asked to change a incoming NAT translation on a Cisco router for a customer today - however since this NAT was used to deliver all their internal email, it was never **not** in use, and I got the standard message below when trying to clear it:

```%Static entry in use, cannot change
```

Thanks to [phirebird.net][1], I discovered that if (in conf mode) , I prefix my (pre-prepared and ready to paste) nat changes with `do clear ip nat translation`, I can clear and change them fast enough to avoid the problem.

[1]:http://www.phirebird.net/2009/07/cant-remove-ip-nat-entries-on-cisco-router-static-entry-in-use-cannot-remove/
