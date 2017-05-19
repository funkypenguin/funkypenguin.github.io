---
layout: page
title: "Enable VLAN on WAN interface for Cisco SRP527W"
date: "2015-07-01 20:20"
categories:
  - howto
---
Several years ago, I advised a [friend of mine][c3766e96] to buy the Cisco SRP527W, a SME DSL router with built-in voice capabilities. At the time, it was one of the supported devices for his broadband provider's VOIP services.

  [c3766e96]: http://www.rumoursofworship.com "Rumours of Worship"

Another motivation was the (_uncommon at that time_) ability to provide multiple WiFi SSIDs, so that he could maintain a "guest wifi" as well as his "trusted wifi".

It took us several hours at the time, to setup the guest wifi (_hint: add a VLAN, DHCP server config, then associate with an SSID_), but since then it's been working reliably, and the guest wifi has been a hit.

I recently helped the same friend move to a fibre broadband service. In New Zealand, if you want to terminate your fibre (PPPOE) connection on your own device, you need to configure it for a WAN sub-interface on VLAN 10.

Since it took us several hours (again!) to configure the SRP527W this way, I decided to record the process for anyone else struggling.

## Step 0 : Reset the config (may not be required)

My friend's SRP527W had been auto-provisioned by his previous DSL-VOIP provider, and certain administrative functions were disabled. We had to perform a system reset (_default admin password is admin/admin, and user password is cisco/cisco_) to restore functions. This may not be required under all circumstances.

## Step 1 : Switch off DSL support to enable ethernet WAN

Before we could use the 4th Ethernet port as a WAN port, it was necessary to disable the DSL interface. This is done under __Administration__ -> __Switch Setting__, and will reset and reboot the device.

![Disable DSL interface on SRP527W](/images/srp527w_disable_dsl.png)

## Step 2 : Configure WAN interface

This stumped us for hours. You can't configure a VLAN ID on the WAN interface. The dialogue box is there, but it's greyed out. Eventually in frustration, I configured the WAN interface as an untagged, DHCP client interface, intending to connect it to the provider-supplied router.

After configuring a WAN interface, only __then__ did it become possible to add a sub-interface, which permitted me to specify a VLAN ID.

![Add sub-interface to SRP527W](/images/srp527w_add_subinterface.png)

So, happy ending. My friend has his SME router running dual-SSID, VLAN-isolated networks, happily connected to his new fibre provider.
