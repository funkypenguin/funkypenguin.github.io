---
layout: "post"
title: "The geekiest thing I've done in 2017"
date: "2017-09-04 21:07"
category: note
excerpt: "I was recently asked what the geekiest thing I've done recently is..."
---
I was recently asked what the geekiest thing I've done recently is.

My response:

> Ever. That's a hard question. Probably the most _challenging_ has been building an HA OpenStack cluster. The _geekiest_ though, would be..

I use [Home Assistant](https://home-assistant.io/) for my home automation platform. I bought a [Xiaomi Smart Home kit](https://xiaomi-mi.com/sockets-and-sensors/xiaomi-mi-smart-home-kit/) to integrate into it (_I don't speak Chinese, so I had some help_), but I wanted it on my guest wifi and not my trusted wifi (_where HA lives_). Due to the way Xiaomi employs multicast for device discovery/control, you can't simply _route_ traffic to the gateway, and I had to expose a second interface into a docker network attached to my HA instance.

That's not the geeky part though..

Part of the Xiaomi package was a "wireless switch". Basically, it's a power outlet controlled from the hub.

I have an old Raspberry Pi B, which is hooked up to an awesome little [Dayton DTA-1 amplifier](https://www.amazon.com/gp/product/B001PNOH2I/ref=oh_aui_detailpage_o00_s00?ie=UTF8&psc=1) and runs [Shairport-sync](https://github.com/mikebrady/shairport-sync), allowing me to airplay music to a pair of speakers in my dining room. I attached the wireless switch to the amp, and wrote small start/stop scripts for Shairport, using the [Home Assistant API](https://home-assistant.io/developers/rest_api/) to turn the switch on/off when I was streaming music.

End result - the amp is turned off (_and not using any power_) under normal circumstances, but when I start playing music, the amp automatically turns on. It turns off again when the music stops.

Definitely the geekiest thing in recent memory ;)
