---
layout: post
title: Allocate the same OpenVPN client IP across multiple OpenVPN server instances
category: howto
date: '2015-10-30 21:25'
---

## Background

At [Prophecy](http://www.prophecy.net.nz), we use OpenVPN to provide our staff (all over the world) with secured access to our internal resources, and to customer systems.

We run multiple copies of OpenVPN as a server, to permit our staff to connect via UDP or TCP, on various ports. This helps retain access to our systems when staff are working from a more restrictive environment.

We also use custom client configuration files to allocate VPN addresses to our users, so that each user always receives the same VPN address. This makes things like internal web-server logs and ACLs possible.


## The Problem

Historically we'd allocated individual VPN client IP ranges to each OpenVPN instance, but this is a nuisance to manage and scale, since each server instance requires a CCD file, DNS records, etc.


## The Solution

Having recently refreshed our OpenVPN platform, we've managed to run multiple OpenVPN server instances using an overlapping VPN address range. Normally this can't be done (because each VPN instance needs a route to send traffic back to clients), but I found a useful workaround at [Thomas Gouverneur's blog](http://thomas.gouverneur.name/2014/02/openvpn-listen-on-tcp-and-udp-with-tun/), which I adapted for FreeBSD (which drives our [pfsense](http://www.pfsense.org) OpenVPN servers).

## Requirements

For this solution to work out-of-the-box, you need:

a) OpenVPN users all configured for static IP allocations, using CCD files. If you permitted dynamic allocations, you'd quickly end up with users stepping on each other's IPs, since the multiple OpenVPN server instances share a client IP address pool.

b) OpenVPN running as root. This is required for access to modify the kernel routing table. I'm sure this can easily be accomplished with sudo.

## The solution

The solution works by taking advantage of OpenVPN's "learn-address" argument, to run an operating-system script when a new address is learned by the OpenVPN process. Every time a user connects, the script (a) deletes any previous route for that user, and (b) adds a route to the kernel routing table, so that OpenVPN sends traffic for that specific user to the correct OpenVPN instance.

## How to implement

To implement, save the gist below, and add the following to '''each''' openVPN server config:

````
learn-address /path/to/learn-address.sh
````

## learn-address.sh (BSD-specific)

Create learn-address.sh as follows:
<script src="https://gist.github.com/funkypenguin/effb077c7e780b81392b.js"></script>

## Operation

You can now tail /tmp/learn.log to watch as routes are added/removed as users connect/disconnect.
