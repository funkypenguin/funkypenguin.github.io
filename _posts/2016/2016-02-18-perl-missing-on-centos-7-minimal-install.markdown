---
layout: post
title: Perl missing on CentOS 7 minimal install
date: '2016-02-18 21:16'
category: note
---

When trying to install some Nagios plugins on my minimal CentOS 7 host, I was frustrated for a while when the plugins failed to run with errors about:

 _use: command not found_.

As it turns out, my CentOS 7 system didn't include perl at all.

The resolution was to simply install perl by running:
````
    yum install perl
````
