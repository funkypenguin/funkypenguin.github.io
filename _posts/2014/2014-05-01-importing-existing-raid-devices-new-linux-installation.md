---
title: Importing existing RAID devices into new Linux installation
author: David
layout: post
permalink: /note/importing-existing-raid-devices-new-linux-installation/
header: no
categories:
  - note
tags:
  - centos
  - linux
  - mdadm
  - raid
---
Recently I had to rebuild a CentOS5 VM host as CentOS6. My VMs were stored on a RAID1 pair (seperate from the OS disks). To avoid any possibility of impacting the VM data during the re-installation, I removed the VM data disks from the host during the reinstall.

After successfully re-installing CentOS6 on the host (having wiped out any previous OS data), I needed to restore the VMs. Re-installing the pair of VM data drives (sdc and sdd), I ran:

    mdadm --assemble --scan

And expected a new md device to be discovered and available. It was not.

I discovered that I first had to remove /etc/mdadm.conf, before running the "assemble" command above, after which my device was successfully discovered.

    [root@myhost ~]# mdadm --assemble --scan
    mdadm: /dev/md/2_0 has been started with 2 drives.
    [root@myhost ~]#

Then I needed to recreate /etc/mdadm.conf by running

    mdadm --detail --scan >> /etc/mdadm.conf

And make any device numbering adjustments as required.
