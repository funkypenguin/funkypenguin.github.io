---
title: Allowed memory size of xxx bytes exhausted with WordPress on Debian
author: David
layout: post
permalink: /note/allowed-memory-size-of-xxx-bytes-exhausted-with-wordpress-on-debian/
header: no
categories:
  - note
tags:
  - debian
  - wordpress
---
My Debian Squeeze host started having trouble performing WordPress 3.5 core or plugin updates &#8211; in the error logs, I'd see messages like:

> Allowed memory size of xxx bytes exhausted

After scouring the internet, attempting to adjust memory limits on php.ini, apache, etc, I eventually discovered the solution was to add:

> *USE\_ZEND\_ALLOC*=0

to /etc/apache2/envvars. Problem solved.
