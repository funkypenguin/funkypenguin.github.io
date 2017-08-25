---
layout: "post"
title: "Accessing older iDRAC virtual consoles on MacOS"
date: "2017-08-25 23:14"
category: note
tags:
  - dell
  - idrac
  - java
  - workaround
crosspost_to_medium: true
---
I recently inherited some 2012-era Dell servers for development purposes. I wanted to use remote console to reinstall the OS, but ran into two problems:

## Problem #1 - "Launch console" downloads an unclickable shortcut

In Chrome, when you click the link to launch a virtual console, Chrome downloads a file (_which can't be double-clicked to launch_) named something like:

_viewer.jnlp(192.168.1.2@0@batman1,+PowerEdge+R320,+User-+root@150365966088@ST1=791985e23931d5d86bba90b525bc6441)_

I found a [Chrome extension](https://chrome.google.com/webstore/detail/fix-idrac-jnlp-file/knpcepbijjjpmlhbpmkjknghbeghiibo) which turns these downloads links into launchable .jnlp files, like:

_viewer(1192.168.1.2@0@batman1,+PowerEdge+R320,+User-+root@1503659646088@ST1=791985e23931d5d86bba90b525bc6441).jnlp_


## Problem #2 - New java doesn't trust old java

Turns out, if your iDrac version is too old, the .jar for the remote console is signed with MD5, and [Java >= 8u131](http://www.oracle.com/technetwork/java/javase/8u131-relnotes-3565278.html) treats it as unsigned (_and so refuses to run it)_.

I ended up with this error:

> Unsigned application requesting unrestricted access to system. The following resource is signed with a weak signature algorithm MD5withRSA and is treated as unsigned.

I found a helpful [article re the cause](https://www.cyberciti.biz/datacenter/bmc-ipmi-kvm-java-applets-broken-with-java-security-update/), which presented a quick workaround:

On MacOS El Capitan, edit /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/lib/security/java.security, so run:

```
sudo vi /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin\
/Contents/Home/lib/security/java.security +613
```

And change:

```jdk.jar.disabledAlgorithms=MD2, MD5, RSA keySize < 1024```

To:

```#jdk.jar.disabledAlgorithms=MD2, MD5, RSA keySize < 1024```

Reload the .jnlp, and it should successfully launch.
