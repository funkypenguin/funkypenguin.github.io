---
layout: post
category: link
date: 2017-06-20 21:39:25
title: "Implicit 2TB limit breaks Instapaper for 31 hours"
excerpt: "What you don't know can hurt you"
tags: failure, aws
link: https://medium.com/making-instapaper/instapaper-outage-cause-recovery-3c32a7e9cc5f
---

In [Instapaper Outage Cause & Recovery – Making Instapaper – Medium](https://medium.com/making-instapaper/instapaper-outage-cause-recovery-3c32a7e9cc5f), I read a painful reminder that not everything that fails is within your control:

> This is any web application developer’s worst nightmare. A filesystem-based limitation we weren’t aware of and had no visibility into rendered not only our production database useless, but all our backups, too. Our only recourse was to restore the data to an entirely new instance on a new filesystem. This was further complicated by the fact that our only interface into the hosted instances is MySQL, which made filesystem-level solutions like rsync impossible without the direct assistance from Amazon engineers.
> 
> Even if we had executed perfectly, from the moment we diagnosed the issue to the moment we had a fully rebuilt database, the total downtime would have been at least 10 hours. Of course, that’s significantly less than the 31 hours of total downtime and five days of limited access, but we’d like to illustrate the severity of this type of issue even in a perfect world.