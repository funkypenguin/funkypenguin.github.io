---
layout: page
title: "Proxy one virtual host to another virtual host in Apache"
date: "2015-07-03 21:41"
categories:
  - howto
tags:
  - apache
---
We've had several reasons to use Apache's ProxyPass features in the past, and a basic configuration (to redirect one website to another) is easy to find online.

I ran into a tricker variation of this requirement today - I needed to redirect one **virtualhost** (on server A) to **another** virtualhost (on server B).

Since virtualhosts rely on the HTTP "Host:" header, it was necessary to use the following syntax **within** the virtualhost configuration:

{% highlight conf %}
RequestHeader set Host "target.host.whichisvirtual.com"
ProxyPreserveHost On

ProxyPass / http://target.host.whichisvirtual.com/
ProxyPassReverse / http://target.host.whichisvirtual.com/
{% endhighlight %}

Without setting (and then preserving) the host header, the target server would return a 404, since it wouldn't be able to match the request with a configured virtual host.

As an optional extra, adding :
{% highlight conf %}
LogLevel debug
{% endhighlight %}

Into the virtualhost config provides additional details on the ProxyPass process in the configured error log.
