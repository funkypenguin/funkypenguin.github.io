---
title: Protect your website with htaccess
subheadline:  "While allowing individual IP addresses unrestricted access"
excerpt: "While allowing individual IP addresses unrestricted access"
layout: post
header: no
permalink: /how-to/protect-your-website-with-htaccess-while-allowing-individual-ip-addresses-unrestricted-access/
redirect_from: /tutorial/how-to-protect-your-website-with-htaccess-while-allowing-individual-ip-addresses-unrestricted-access/
categories:
  - how-to
tags:
  - apache
  - htaccess
---
Today we had the need to setup a htauth-secured WordPress blog for internal development purposes. We duly protected our web application with the vanilla .htaccess directives:<!--more-->

{% highlight conf %}
AuthName "Secured"
AuthUserFile /path/to/secret/location/.htpasswd
AuthType Basic
Require valid-user
{% endhighlight %}

We were using WordPress to generate RSS data feeds, and were pulling down those feeds into PHPList (we combined the two products using my <a title="WP-PHPList" href="../../project/wp-phplist" target="_blank">WP-PHPList WordPress plugin</a>). The problem was, PHPList pulls in RSS feeds via the command line, which (at least out-of-the-box) doesn't support htauth.

What I needed was a way to force all users to authenticate as normal, EXCEPT certain IPs (like localhost) to whom I'd give unrestricted access.

Some Googling resulted <a title="Article on conditional HTAuth access" href="http://www.askapache.com/htaccess/apache-authentication-in-htaccess.html#allow-conditional" target="_blank">this useful article</a> at <a title="AskApache.com" href="http://www.askapache.com/" target="_blank">AskApache.com</a>, which points out that all I needed was to add:

{% highlight conf %}
Allow from 127.0.0.1
Satisfy Any
{% endhighlight %}

to my directives, giving me the following:

{% highlight conf %}
AuthName "Secured"
AuthUserFile /path/to/secret/location/.htpasswd
AuthType Basic
Require valid-user
Allow from 127.0.0.1
Satisfy Any
{% endhighlight %}

The solution works perfectly - normal users are forced to authenticate, but PHPList can suck up RSS feeds without a problem.
