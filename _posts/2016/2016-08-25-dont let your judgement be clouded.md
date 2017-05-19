---
layout: post
category: postmortem
date: 2016-08-25 07:41:19
title: "Don't let your judgement be clouded"
excerpt: "Lessons learned from overreliance on cloud infrastructure"
tags: cloud, testing
---

In [Buildkite's Aug 22 outage post-mortem](https://building.buildkite.com/outage-post-mortem-for-august-23rd-82b619a3679b), I read the (refreshingly honest and transparent) story of a cascading set of failures with a __root cause of poor change-management__. An interesting takeaway from the story is that a large amount of the failures are unique to the "cloud" / IaaS platform design. 

I.e. "Cloud" takes some of the pain away from managing infrastructure and building platforms, but in doing so it also makes it easy to forget the necessary discipline and rigour to make the platforms reliable and supportable.

> Since we felt pressure to get these changes out sooner rather than later, we didn’t do our due diligence to figure out if this new database would perform under heavy load.
> 
> Lesson #1: Keep an eye on AWS credits so you’re not rushed to make significant infrastructure changes in a short period of time.

Plan your changes far in advance on a roadmap, so that pressure to act quickly doesn't cause you to judge poorly.

> We monitored it into our evening and what we thought was the beginning of the US peak period and everything seemed to be tracking okay, so we went to bed.

Monitoring production on the fly is not an adequate alternative to load-testing in dev. Modern systems are good at gathering detailed metrics, we should use these metrics (facts) rather than human observation ("everything seemed to be tracking okay") to evaluate the success of a change.

> we also moved to a centralised pgbouncer to pool connections across all of our servers in hopes to reduce the per-connection memory overhead.

Making untested changes "in hope" of an improvement is bound to end badly.

> Due to an error in how we bootstrapped these new servers and some of our recent infrastructure changes, the health checks failed which meant no new servers could come online to replace the ones that were removed.

Too much uncontrolled change, too fast.

> This works really well if buildkite.com is online… We always had the intention of improving this but other stuff just got in the way and it dropped off our radar.

This echoes the [SOHO outage](https://www.funkypenguin.co.nz/postmortem/Spacecraft-and-IT-systems-fail-for-the-same-reasons/) re known issues being deprioritized, forgotten, and then surfacing at the worst possible times.

> While all of this was happening, the Buildkite team were fast asleep.
> 
> We have various services watching Buildkite all the time: New Relic, Pingdom, Datadog, Calibre and CloudWatch. If any of them start seeing issues on Buildkite, they create a PagerDuty alert which phone calls the developer who’s been designated “on-call”. This week it was my turn.
> 
> I still haven’t figured out how this happened, but the “Immediately phone me” rule was somehow dropped as a “Notification” from my settings. I have “Do Not Disturb” turned on my phone in the evenings, but I allow PagerDuty to call me if anything comes up. Since I didn’t get a phone call (just push notifications which don’t make any sound) I didn’t get woken up.

The more complex the notification system (PagerDuty allows individuals to customize their notifications), the more chance it'll break down and fail at the worst moment. 

(At [Prophecy](http://www.prophecy.net.nz), we'Ve refined our system over time. We use redundant [Icinga](http://www.icinga.org) instances (which each monitor each other) which email, TXT (and even phone, depending on criticality) through a rostered oncall / escalation tree until someone takes ownership of an alert. There's no end-user configuration or apps needed, and it works on any brand of smartphone.)

> We logged into the AWS Console and tried upgrading the database, but due to IAM issues AWS was experiencing, the interface wouldn’t let us make the changes.

There's a hidden risk to totally relying on someone else's infrastructure to manage your own.