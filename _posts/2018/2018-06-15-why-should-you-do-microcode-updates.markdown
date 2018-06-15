---
layout: "post"
title: "Should you do microcode updates?"
date: "2018-06-15 09:25"
category: opinion
tags: security
---
A [colleague](https://twitter.com/tjh) and I were discussing my recent [rant re a RedHat-issued kernel update breaking VMs on all my AMD systems](https://www.funkypenguin.co.nz/note/kvm-vms-on-kernel-2-6-32-696-30-1-el6-x86-64-on-amd-based-hypervisor-fail-to-boot/). Notwithstanding the fact that [my RedHat bug report about the issue](https://bugzilla.redhat.com/show_bug.cgi?id=1583092) is set to "private" and Bugzilla (_1990 called wants its UI back, to hang out with Miranda IM_) won't let me change it, he asked me "we've applied the latest microcode, right?"

I said, "What microcode?"

So began my schooling in the murky world of CPU microcode - what seems to be "realtime patches" to the hardcoded firmware in your CPU processor. I've probably misunderstood much of this, but I imagine something like this:

## What are microcode updates?

Let's say we have a CPU with some buggy code, we'll call it the AME Venom. The CPU will always calculate 2+2=5. Disaster. Shortly after this is discovered, OS vendors release a microcode update which tells the operating system, "_When you boot, if you're running on an AME Venom, then ignore what the CPU tells you about 2+2. The answer is actually 4_"

OS vendors will routinely issue updated microcode packages, which (_when installed_) will update your initrd, so that on boot, your kernel will load this "_software band-aid_" and not become confused by faulty old CPU code.

## Should you apply microcode updates?

Well, it depends on what you want to protect against. The latest in a series of horrible microcode updates from Intel will either [suck your performance](https://www.theverge.com/2018/1/9/16868290/microsoft-meltdown-spectre-firmware-updates-pc-slowdown), or [ransom the security of your CPU](https://www.theregister.co.uk/2018/01/22/intel_spectre_fix_linux/), calling it a "feature". And the dreaded [SPECTRE/MELTDOWN](https://www.wired.com/story/meltdown-and-spectre-vulnerability-fix/) vulnerability only impacts you if you're already allowing untrusted miscreants to run code (or VMs) on your platforms.

But, if like me, you're running some 3+-year-old AMD platforms which have never had a microcode update, you might find yourself unable to boot newer kernels 😡, without applying the [dis_ucode_ldr fix ](https://www.happyassassin.net/2016/07/07/psa-failure-to-boot-after-kernel-update-on-skylake-systems/)as a kernel boot argument.

## How do you apply microcode updates?

Under a RedHat-based distribution, just run ```yum install microcode_ctl```. Under Debian/Ubuntu, run ```microcode.ctl```. And reboot. Job's done.

To confirm your version of microcode on your distribution/CPU platform, run ```cat /proc/cpuinfo | grep microcode```.

## You've totally misunderstood microcode

Probably. I've only known about it for a few hours. Let's discuss. See below :)
