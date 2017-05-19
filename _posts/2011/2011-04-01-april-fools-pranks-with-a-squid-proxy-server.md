---
title: April Fools Pranks with a Squid Proxy Server
layout: post
redirect_from: /tutorial/april-fools-pranks-with-a-squid-proxy-server/
permalink: /how-to/april-fools-pranks-with-a-squid-proxy-server/
header: no
categories:
  - how-to
tags:
  - centos
  - imagemagick
  - perl
  - prank
  - squid
---
## Use Squid to turn the internet upside-down, change Google to Klingon

For this year's April Fools Day, I went with the [classic][1] "turn the internet upside-down" squid trick, with a few tweaks. I didn't want to be too obvious, so I avoided changing images on the majority of Google' pages, but instead changed the default language to Klingon. Here are the results:

<div id='gallery-1' class='gallery galleryid-1126 gallery-columns-2 gallery-size-thumbnail'>
  <figure class='gallery-item'>

  <div class='gallery-icon landscape'>
    <a href='/images/google_in_klingon.png'><img width="150" height="150" src="/images/google_in_klingon-150x150.png" class="attachment-thumbnail" alt="Set Google&#039;s language to &quot;Klingon&quot;" aria-describedby="gallery-1-1127" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-1-1127'> Set Google's language to "Klingon" </figcaption></figure><figure class='gallery-item'>

  <div class='gallery-icon landscape'>
    <a href='/images/images_upside_down.png'><img width="150" height="150" src="/images/images_upside_down-150x150.png" class="attachment-thumbnail" alt="Turn random (but not all) images upside-down" aria-describedby="gallery-1-1128" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-1-1128'> Turn random (but not all) images upside-down </figcaption></figure>
</div>

It's easy and fun to do, and you get to learn a bit about Squid, perl, and regular expressions. Here's how it's done:<!--more-->

## Squid, Apache, and ImageMagick

We use CentOS on our systems, so these examples assume default paths etc, but can easily be modified to your own environment.

  * Squid : "*yum install squid*" - I already had this in place, so I'm not going to cover setting up Squid Proxy. Obviously, this trick works best if you're using it for transparent proxying
  * Apache : "*yum install apache*" - This is needed to serve the modified images back to the victim
  * ImageMagick : "*yum install ImageMagick*" - This is needed for the "mogrify" command, which turns the images upside-down

## Redirector configuration in squid.conf

I configured Squid to classify my "victim" as "browser\_firefox" or "browser\_ie", based on their user-agent header. (I also turned on logging of user agent headers so I could tweak this). Then using the "url\_rewrite\_access" directive, I could selectively target my victims. Note that inverse matches (i.e., "!browser_firefox") also work here.

{% highlight conf %}
acl browser_firefox browser Mozilla
acl browser_ie browser MSIE
url_rewrite_access allow LOADBALANCER
url_rewrite_program /etc/squid/aprilfoolsprank.pl
url_rewrite_bypass on
url_rewrite_children 1
useragent_log /var/log/squid/useragent.log
{% endhighlight %}

I configured Squid to classify my "victim" as "browser\_firefox" or "browser\_ie", based on their user-agent header. (I also turned on logging of user agent headers so I could tweak this). Then using the **url\_rewrite\_access** directive, I could selectively target my victims. Note that inverse matches (i.e., "!browser_firefox") also work here.

The **url\_rewrite\_bypass** directive tells squid not to wait for free redirector children, but to bypass the redirector rather than allowing it to become a bottleneck. I did this to (a) avoid tipping off the victims, and (b) I figured a random few upside images on a website, as opposed to every image, would be more subtle. As my victims started noticing the prank effects, I gradually increased the amount of **url\_rewrite\_children** from 1 to 3.

## Perl script to invert images and other mischief

I created /etc/squid/aprilfoolsprank.pl as follows:

{% highlight perl %}
#!/usr/bin/perl
$|=1;
$count = 0;
$pid = $$;
while (&lt;&gt;) {
 chomp $_;
 # Allow google static content, unmolested
 if ($_ =~ /(.*gstatic.*)/i) {
 $url = $1;
 print "$url\n";

 }
 # Change google language to Klingon
 elsif ($_ =~ /(.*google.*)/i) {
 $url = $1;
 $url =~ s/hl=en/hl=xx-klingon/;
 print "$url\n";

 }
 elsif ($_ =~ /(.*\.jpg)/i) {
 $url = $1;
 system("/usr/bin/wget", "-q", "-O","/var/www/html/images/$pid-$count.jpg", "$url");
 system("/usr/bin/mogrify", "-flip","/var/www/html/images/$pid-$count.jpg");
 print "http://127.0.0.1/images/$pid-$count.jpg\n";
 }
 elsif ($_ =~ /(.*\.gif)/i) {
 $url = $1;
 system("/usr/bin/wget", "-q", "-O","/var/www/html/images/$pid-$count.gif", "$url");
 system("/usr/bin/mogrify", "-flip","/var/www/html/images/$pid-$count.gif");
 print "http://127.0.0.1/images/$pid-$count.gif\n";

 }
 elsif ($_ =~ /(.*\.png)/i) {
 $url = $1;
 system("/usr/bin/wget", "-q", "-O","/var/www/html/images/$pid-$count.png", "$url");
 system("/usr/bin/mogrify", "-flip","/var/www/html/images/$pid-$count.png");
 print "http://127.0.0.1/images/$pid-$count.png\n";

 }
 else {
 print "$_\n";;
 }
 $count++;
}  
{% endhighlight %}


Each successive "if" statement checks the requested URL against a regular expression, and if it matches, performs some tricky on it. Because we're using "if" statements, the first match wins. The first stanza avoids upside-downing google's static content (because we don't want to tip anybody off by making search results look weird), and the following one changes the default language from english to Klingon. (You can substitute any value here, just search for "google whatever-country", and identify the "hl=xx" string used).

The final 3 stanzas perform the classic "flip" action using ImageMagick's mogrify.

&nbsp;

 [1]: http://www.ex-parrot.com/pete/upside-down-ternet.html
