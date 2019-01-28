---
layout: post
category: postmortem
date: 2016-08-27 08:06:43
title: Manual processes fail to scale.
excerpt: Puny humans are puny.
tags: 
  - scaling
  - postmortem
crosspost_to_medium: false
---
In [Linode Blog » The Twelve Days of Crisis – A Retrospective on Linode’s Holiday DDoS Attacks](https://blog.linode.com/2016/01/29/christmas-ddos-retrospective/), I read about the scale of a DDOS attack on Linnode infrastructure:

> Of course, this was not the first time that our routers have been attacked directly. Typically, special measures are taken to send blackhole advertisements to our upstreams without blackholing in our core, stopping the attack while allowing customer traffic to pass as usual. However, we were unprepared for the scenario where someone rapidly and unpredictably attacked many dozens of different secondary IPs on our routers. This was for a couple of reasons. First, mitigating attacks on network gear required manual intervention by network engineers which was slow and error-prone. Second, our upstream providers were only able to accept a limited number of blackhole advertisements in order to limit the potential for damage in case of error.

Manual processes fail at scale.

> As was the case with our own infrastructure, this method of attack was not novel in and of itself. What made this method so effective was the rapidity and unpredictability of the attacks. In many of our datacenters, dozens of different IPs within the upstream networks were attacked, requiring a level of focus and coordination between our colocation partners and their transit providers which was difficult to maintain. Our longest outage by far – over 30 hours in Atlanta – can be directly attributed to frequent breakdowns in communication between Linode staff and people who were sometimes four-degrees removed from us.

Again, it's the human components that failed to scale.

> First, in several instances we were led to believe that our colocation providers simply had more IP transit capacity than they actually did. Several times, the amount of attack traffic directed toward Linode was so large that our colocation providers had no choice but to temporarily de-peer with the Linode network until the attacks ended.

Test and baseline when the sun shines, so that when it rains, you're comfortable.

> Linode’s capacity management strategy for IP transit has been simple: when our peak daily utilization starts approaching 50% of our overall capacity, then it’s time to get more links.

Define standard capacity management / growth policies so that ever-expanding capacity requirements are dealt with as a low-effort, low-friction business process. This avoids getting caught under-capacity due to manual effort required.

> It’s important that we acknowledge when we fail, and our lack of detailed communication during the early days of the attack was a big failure.
>
> Providing detailed technical updates during a time of crisis can only be done by those with detailed knowledge of the current state of affairs. Usually, those people are also the ones who are firefighting. After things settled down and we reviewed our public communications, we came to the conclusion that our fear of wording something poorly and causing undue panic led us to speak more ambiguously than we should have in our status updates. This was wrong, and going forward, a designated technical point-person will be responsible for communicating in detail during major events like this. Additionally, our status page now allows customers to be alerted about service issues by email and SMS text messaging via the “Subscribe to Updates” link.

This is an excellent improvement to the standard "we have an outage, will keep you informed" process followed in general. Within [Prophecy](http://www.prophecy.net.nz) our internal incident management process normally calls for the operations center staff to manage customer communications, because (as noted) the technical resources are busy firefighting. In our case, customers expect us to abstract the technical details from them (we provide full-range IT services). However, we might benefit from a semi-automated system with some standard boilerplate details that ops could refer our clients to, and which wouldn't take the technical resources long to initiate. Maybe a checklist-based form for technical resources to quickly identify affected systems, expected restore time, and escalation processes, to further empower staff who are dealing with multiple disgruntled customers.

> Our nameservers are now protected by Cloudflare

Is this a recommended mitigation technique? It would seem so, and (AFAIK) at minimal or no cost.
