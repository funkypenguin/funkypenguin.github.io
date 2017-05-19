---
title: WP-PHPList
author: David
header: no
excerpt: The WP-PHPlist plugin integrates PHPList into your Wordpress blog, giving you all the mailing list power of PHPList, within the beautiful styling, theme, and widgets of your Wordpress theme.
layout: post
categories:
  - project
tags:
  - phplist
  - wordpress
---
The [WP-PHPlist plugin][1] integrates PHPList into your WordPress blog, giving you all the mailing list power of PHPList, within the beautiful styling, theme, and widgets of your WordPress theme. This tutorial will take you through the installation of the plugin, assuming that you're starting with a vanilla install of PHPList. <!--more-->

## Getting Started

What you'll need to start:

  * A working, un-modified <a title="PHPlist" href="http://www.phplist.com/" target="_blank">PHPList</a> installation (2.10.10 is the latest)
  * A working <a title="Wordpress" href="http://www.wordpress.org/" target="_blank">WordPress</a> installation with pretty permalinks enabled (any version)
  * The corresponding <a title="WP-PHPList plugin" href="https://github.com/funkypenguin/wp-phplist" target="_blank">WP-PHPList plugin</a> (2.10.10 is the latest)
  * Best results with PHPList and WordPress sharing one database (using their default wp_ and phplist_ prefixes)

Unpack the wp-phplist plugin zipfile. You should see the following files and folders:

  * lists
  * wp-phplist
  * README.TXT
  * phplist-2.10.10.patch

## PHPList modifications for WP-PHPList

Copy the contents of the "lists" folder into your PHPList "lists" folder. The objective is to overwrite the following files:

  * lists/index.php
  * lists/admin/commonlib/lib/userlib.php
  * lists/admin/processqueue.php
  * lists/admin/subscribelib2.php

WARNING - If you've made modifications to your PHPList installation, this may overwrite those modifications, and BREAK IT. I've provided a diff (phplist-2.10.8.patch) in case you want to manually update PHPList.

Make sure your PHPList installation is setup correctly, required path and URL configuration settings are correct, etc. Also, make sure that you have at least one active list, else the plugin won't display anything.

## WordPress installation for WP-PHPList

Make sure you have "Pretty Permalinks" enabled in WordPress. WP-PHPList uses this to cretae the "slug" below.

Copy the "wp-phplist" folder into your WordPress wp-content/plugins folder. You must end up with the folder structure wp-content/plugins/wp-phplist/.

Activate the plugin in WordPress, and double-check the options under Admin -> Options -> PHPList.

  * **PHPList public pages slug** : The WordPress "slug" you want PHPList to be accessible as, for example: http://your.blog.com/newsletter.
  * **PHPList default subscribe page** : PHPList lets you define multiple subscribe pages, each requesting different information from users, and making different lists available. Enter the number of the subscribe page you want to use (default is 1), or leave it blank to let PHPList prompt you.
  * **PHPList embedded page title** : The title WordPress will display on PHPList's page. (Formatted the same as a default blog post title)
  * **PHPList relative path** : The path to your PHPList "lists" directory, relative to your WordPress root. By default the plugin assumes that the "lists" directory is a subdirectory of your WordPress install. If PHPList is installed in the same directory as WordPress, this will be "../phplist".

## Test PHPList in WordPress

That's it. Go to http://yourblog/slug (*you chose the slug above*) and check that it works.

Remember to change your subscribe / unsubscribe / confirmation URLs in PHPList to reflect the new path that your users will use (*http://yourblog/slug/?p=confirm, for example*).

## Caveats

### Theme Integration

The "wp-phplist/wp-phplist-page.php" is based on the default template's "single.php" file. Your template may use other CSS class values, and you'll need to adjust "wp-phplist-page.php" accordingly.

### Shared Databases

You'll get best results if your WordPress and PHPList installations share a single database. It may be easy to avoid, but it seems like if you start pulling values from PHPList's independent database, a bunch of the queries that WordPress uses for its template will fail. You'll see messages like this:

WordPress database error Table &#8216;newsletter\_phplist.wp\_terms' doesn't exist for query SELECT t.\*, tt.\* FROM wp_terms..

Combining your databases shouldn't be a problem, since PHPList defaults to a table prefix of "phplist\_", and WordPress to "wp\_".

### PHPList standalone

We've "broken" the PHPList index file, which displays your subscribe pages, to make it fit into your blog. If you still want to use PHPList's interface **as well as** the interface within WordPress, you'll probably want another (unaltered) copy of lists/index.php.

Let's assume you call it "index\_for\_wordpress.php". Edit wp-content/plugins/wp-phplist/wp-phplist-page.php, look for "index.php", and change it to "index\_for\_wordpress.php".

## Optional extra

Using <a title="Urban Giraffe" href="http://urbangiraffe.com/" target="_blank">Urban Giraffe</a>&#8216;s **awesome** <a title="Urban Giraffe's Redirection Plugin" href="http://urbangiraffe.com/plugins/redirection/" target="_blank">Redirection</a> plugin, you can add the following redirection rules for some cosmetic improvements on your unsubscribe / preferences links:

  * /member/preferences\?(.*)$ -> /member/?p=preferences&$1 (301 redirect, with regex enabled)
  * /member/unsubscribe\?(.*)$ -> /member/?p=unsubscribe&$1 (301 redirect, with regex enabled)

This means that I can now modify my unsubscribe / preferences links in PHPList to [http://example.com/member/unsubscribe/?id=whatever][2] - not a big deal maybe, but in my case, I had a few years of historical links pointing to these sorts of URLs, and the redirection plugin was ideal. (And a good idea for anyone interested in SEO on WordPress)

**Download**

WP-PHPList is hosted at <a title="GitHub" href="https://github.com/funkypenguin/wp-phplist" target="_blank">GitHub</a> now.

 [1]: https://github.com/funkypenguin/wp-phplist
 [2]: http://example.com/member/unsubscribe/?id=whatever "http://example.com/member/unsubscribe/?id=whatever"
