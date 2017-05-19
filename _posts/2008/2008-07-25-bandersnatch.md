---
title: 'Bandersnatch - The Jabber Logger'
author: David
header: no
excerpt: Bandersnatch is tool to log Jabber instant messaging traffic, and to generate meaningful usage statistics. Bandersnatch is designed for a corporate intranet environment. It is designed for administrators who wish to monitor the use / abuse of their Jabber servers.
layout: post
permalink: /project/bandersnatch/
categories:
  - project
tags:
  - bandersnatch
  - jabber
---
### What is Bandersnatch?

Bandersnatch is tool to log Jabber instant messaging traffic, and to generate meaningful usage statistics. Bandersnatch is designed for a corporate intranet environment. It is designed for administrators who wish to monitor the use / abuse of their Jabber servers.

### Peer-Policing

Bandersnatch is intended to be a deterrent to corporate users abusing a Jabber system for personal purposes. It is designed around the "peer-policing" theory, which hypothesizes that:

<p style="padding-left: 30px;">
  "If an individual is aware that their activities are publicly visible, they are likely to limit their activities to the public standard".
</p>

In other words, if your users know that their Jabber activity is logged, and that their peers can see how many remote (personal?) messages they've sent, they'll keep their behavior within reasonable boundaries.

### What information is publicly visible?

Statistics on total messages sent and received (both locally and remotely), and top user activity are publically visible. Individual  
message logs are not publicly visible.

### What information is visible to the administrator?

The administrator is able to view individual message logs. Administrators must "log in" in order to view logs.

### Privacy

Bandersnatch can be run with varying degrees of privacy:

  * Level 0 - Log everything
  * Level 1 - Mask out remote usernames
  * Level 2 - Mask out remote usernames and remote message bodies
  * Level 3 - Mask out remote usernames and all message bodies

For example, at Privacy Level 3, Bandersnatch will only record local usernames. It will be still report on local vs. remote usage, and message totals, but remote users will not be identifiable, and the actual text of the messages will not be logged.

### Download

Bandersnatch [source][1] is now hosted on <a title="GitHub" href="https://github.com/funkypenguin/bandersnatch" target="_blank">GitHub</a>

 [1]: https://github.com/funkypenguin/bandersnatch "source"
