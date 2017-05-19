---
title: Making postie work with cron jobs, fails with wp-config.php outside of web root
author: David
layout: post
header: no
permalink: /note/making-postie-work-with-cron-jobs-fails-with-wp-config-php-outside-of-web-root/
categories:
  - note
tags:
  - wordpress
---
I use the excellent [Postie][1] plugin to post to this blog via email. I&#8217;ve been battling for days to get it to automatically check the mailbox for new message though, and while I still haven&#8217;t got it working using [WP-Cron][2] (WordPress&#8217; "pseudo-cron&#8221;), I&#8217;ve finally managed to get it working via a direct cron job.

What *didn&#8217;t* work : any form of call to wp-content/plugins/postie/get_mail.php when my wp-config.php file was [one directory up][3] from the root of my wordpress directory (a security enhancement). I was getting errors like this:

    PHP Fatal error: require_once(): Failed opening required ‘/home/funkypenguin/wp-settings.php’
    (include_path=’.:/usr/share/pear:/usr/share/php’) in /home/funkypenguin/wp-config.php on line 79

Once I moved wp-config.php back into the web root directory, I got happy messages like this instead:

    [Wed May 14 22:10:04 2014] [error] [client 2407:1000:1:7::161:79] Postie: Starting mail fetch [Wed May 14
    22:10:04 2014] [error] [client 2407:1000:1:7::161:79] Postie: Postie is in
    /home/funkypenguin/public_html/wp-content/plugins/postie

Since I can no longer locate wp-config out of the web-accessible portion of my directory structure, I added the following to .htaccess instead:

{% highlight conf %}
<files wp-config.php>
order allow,deny
deny from all
 </files>
{% endhighlight %}

[1]: http://postieplugin.com/
[2]: http://code.tutsplus.com/articles/insights-into-wp-cron-an-introduction-to-scheduling-tasks-in-wordpress--wp-23119
[3]: http://codex.wordpress.org/Hardening_WordPress#Securing_wp-config.php
