---
layout: page
title: "Automatically create VLAN bridge interfaces for KVM on RHEL 5-6"
date: "2015-04-17 13:03"
categories:
  - note
---
At [Prophecy][1], we make extensive use of [KVM Virtualization on CentOS6][1]. A VM host can have multiple bridge interfaces (each on a separate VLAN) on which we can run virtual machines.

This lets us (for example) run a dev VM (inside a dev network) on the same physical VM host as a staging VM (in a separate staging network).

Creating these bridge interfaces requires (each time) creating two network config files (one for an ethernet sub-interface, and one for the bridge), and then starting up both interfaces. It's time-consuming and error-prone.

While doing some work on optimizing [pfSense][3] VMs, I wrote this little script to automate the process of creating bridge interfaces. It's specific to the interface configuration syntax on RHEL5/6
<script src="https://gist.github.com/funkypenguin/a5491793741151ba9d02.js"></script>


[1]: http://www.prophecy.net.nz
[2]: http://wiki.centos.org/HowTos/KVM
[3]: https://www.pfsense.org/
