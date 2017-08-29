---
layout: "post"
title: "NAT on pfsense with multilple OpenVPN instances"
date: "2017-08-29 15:14"
tags:
  - openvpn
  - pfsense
crosspost_to_medium: true
category: note
---
I make use of [pfSense](https://www.pfsense.org) in many of my network designs. It's lightweight and versatile, and runs well as a VM under low-to-medium usage.

I often connect networks together using a pfSense VM and OpenVPN, and this design usually involves NAT. As a result, I end up with a NAT rule somewhere with a source address of "OpenVPN", as illustrated below.

![Bad idea](../../images/pfsense_nat_openvpn.png)

As I've discovered to my pain, this is a "Bad Idea(tm)" if you have multiple OpenVPN instances. pfSense will _alternate_ the source NAT between your various instances, making at least 50% of your sessions through the NAT **spectacularly fail**.

So how to do NAT over OpenVPN interface then, if you can't select a **specific** interface? Avoid using the interface dropdown, and instead explictily state the NAT address as a /32 subnet in full CIDR notation, as illustrated below.

![Better idea](../../images/pfsense_nat_openvpn_solution.png)

Provided your rule only matches the traffic you want it to match (_i.e., you've specified a source and destination in the NAT rule_), your OpenVPN NAT will now perform the way you'd naturally expect it to. :wink:
