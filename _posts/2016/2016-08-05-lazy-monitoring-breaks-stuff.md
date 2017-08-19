---
layout: post
category: opinion
date: 2016-08-05 22:44:18
title: "Lazy monitoring breaks stuff"
excerpt: "Lack of planning in establishing monitoring can increase unreliability"
tags: monitoring
crosspost_to_medium: false
---

In [Outage Postmortem - July 20, 2016](http://stackstatus.net/post/147710624694/outage-postmortem-july-20-2016), we read about how a (technically complex) programming flaw brought down StackOverflow for 34 minutes.  

Aside for the technical description of the bug (which is interesting), what stands out to me is that the impact of the bug was so severe because the automated system was non-deterministic (some might say, lazy). The loadbalancer uses the StackOverflow home page to determine whether the site is operable or not.

Since the contents of the home page is dynamic (and has to be generated every time it's checked), the dynamic nature of the homepage is what made this failure so severe. If the health check were more carefully written (say to parse a status page, whose success would indicate that all systems were operating normally) the bug would have gone unnoticed.

The lesson for me is that when designing *how* to monitor a system, it's necessary to consider not just how the system may fail, but how the monitoring itself may fail.

> The direct cause was a malformed post that caused one of our regular expressions to consume high CPU on our web servers. The post was in the homepage list, and that caused the expensive regular expression to be called on each home page view. This caused the home page to stop responding fast enough. Since the home page is what our load balancer uses for the health check, the entire site became unavailable since the load balancer took the servers out of rotation.
>
> Follow-up Actions
>
> Audit our regular expressions and post validation workflow for any similar issues
> Add controls to our load balancer to disable the healthcheck – as we believe everything but the home page would have been accessible if it wasn’t for the the health check
> Create a “what to do during an outage” checklist since our StackStatus Twitter notification was later than we would have liked (and a few other outage workflow items we would like to be more consistent on).

​
