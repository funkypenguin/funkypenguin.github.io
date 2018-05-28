---
layout: "post"
title: "KVM VMs on kernel-2.6.32-696.30.1.el6.x86_64 on AMD-based hypervisor fail to boot"
date: "2018-05-28 20:26"
categories: note
---
At DayJob(tm), we run several older AMD-based KVM VM hosting platforms, running AMD FX 8150 CPUs on Gigabyte 990FXA-D3 motherboards.

Recently kernel-2.6.32-696.30.1.el6.x86_64 was released under [RHSA-2018:1651 - Security Advisory](https://access.redhat.com/errata/RHSA-2018:1651), and we updated our VMs accordingly, and rebooted.

Most (but not all) updated VMs subsequently failed to boot with message ```PANIC: early exception 0d rip 10:fffffffff810462b6 error 0 cr2 0``` on the console (screenshot below)

![Error message](../../images/error-message.png)

The only resolution we have at the moment is to reboot, catch the 5 second grub prompt, and revert to the previously-working kernel.

I've logged a RedHat bug at [https://bugzilla.redhat.com/show_bug.cgi?id=1583092](https://bugzilla.redhat.com/show_bug.cgi?id=1583092)
