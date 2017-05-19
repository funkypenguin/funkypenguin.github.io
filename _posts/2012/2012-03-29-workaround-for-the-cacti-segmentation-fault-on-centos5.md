---
title: Workaround for the Cacti segmentation fault on CentOS5
layout: post
permalink: /note/workaround-for-the-cacti-segmentation-fault-on-centos5/
header: no
categories:
  - note
tags:
  - cacti
  - centos
---
Seems a little dumb, and I'm not sure how other distributions deal with it, but if you install Cacti from RPM on CentOS, and then browse to your /cacti/ directory via HTTP, you'll find that it dies with a segmentation fault. You know this is you if every other website on your host works, but everytime you go to your /cacti/ URL, your browser reports that the site is totally unavailable (as if apache weren't even running).

In /var/log/httpd/error.log, you'll see the following:

> \[Thu Mar 29 00:14:32 2012\] \[notice\] child pid 2690 exit signal Segmentation fault (11)  
> \[Thu Mar 29 00:14:36 2012\] \[notice\] child pid 2683 exit signal Segmentation fault (11)

The workaround for this is to import cacti.sql into your (pre-created) database, by running:

> mysql cacti -u cacti -p < /var/www/cacti/cacti.sql

(The above is assuming your database and user are both called "cacti")

Once you've imported the schema, and you go to the /cacti/ URL, you'll be presented with the Cacti setup screen, and all will be well <img src="https://www.funkypenguin.co.nz/wp-includes/images/smilies/icon_smile.gif" alt=":)" class="wp-smiley" />
