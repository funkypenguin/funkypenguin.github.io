---
layout: "post"
title: "Openstack neutron could not load ... InterfaceDriver warnings are.. mostly harmless"
date: "2017-02-06 21:03"
tags: openstack
categories: note
excerpt: Unless they're a CRITICAL error, ignore the damn red herrings
crosspost_to_medium: true
---
I've been working on an OpenStack lab, and one of the (_many_) issues I encountered was that my instances (_VMs_) wouldn't get their DHCP addresses from the neutron controller.

This ended up being due to the fact that I'd built CentOS 7 off a security-focused kickstart which set the IPTables FORWARD policy to "DROP" (_a bad idea for an OpenStack node, along with SELinux and umask changes_).

Before I reached this conclusion, in the process of debugging, I discovered the following disturbing error messages from __stevedore.named__ in linuxbridge-agent.log:

````
Could not load neutron.agent.linux.interface.BridgeInterfaceDriver
Could not load neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
````

These had me concerned for a while (_I wasted several hours debugging_), since they seemed directly related to the fault I was experiencing.

Turns out, they're completely **unrelated**, and they're **harmless**.

As I [discovered]( https://ask.openstack.org/en/question/98761/newton-dhcp-agent-problem/), provided the error is a __WARNING__, it can be ignored. It's simply an artifact of the fact that stevedore (_whatever that is_) can't load the class by alias, since we are supplying a class path. If the error was serious, it would be a __CRITICAL__ error, which would stop the DHCP agent from loading altogether.

So, if you encounter this error, but your DHCP agent is still running per ```neutron agent-list```, ignore it and look for your problem elsewhere :)
