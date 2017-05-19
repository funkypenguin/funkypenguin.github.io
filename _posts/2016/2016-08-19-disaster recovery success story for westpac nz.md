---
layout: post
category: opinion
date: 2016-08-19 20:55:36
title: "Disaster Recovery success story for Westpac NZ"
excerpt: "There's something satisfying about actually surviving the disaster you prepared for"
tags: disasterrecovery
---

In [The Four Hundred--Bank Says 'HA' to System i Hardware Failure](http://www.itjungle.com/tfh/tfh081716-story03.html), I read the success story of the DR replication platform established to protect against the failure of a critical server for back-end processing for WestPac:

> Over the years, the company tested the Maxava software and its preparedness by conducting role swaps between the production system and the backup system, which was located in a different data center on the other side of Auckland. Those tests proved valuable when the backplane failure occurred.
> 
> "Once we knew there was a problem and nobody could sign on, and in conjunction with IBM and the incident management team, we made the decisions that we would need to flip the switch," McCauley says. "The decision was made and the process was kicked off. And it was quite quick. We had the DR server available and running and everybody was able to connect and log on and keep going.
> 
> There weren't any surprises during the actual failover, which McCauley says took about 10 minutes to complete. After making a network change to redirect Westpac's front-end trading system to the backup machine, the system was back up and running, with nary a lost trade.

This is what you want. Regular tests to simulate a disaster, and smooth failover when the disaster actually happens.
​