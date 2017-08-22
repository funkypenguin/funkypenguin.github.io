---
layout: "post"
title: "Miniflux, lightweight self-hosted rss reader"
date: "2017-08-19 14:28"
category: review
excerpt: "Tiny Tiny RSS vs Miniflux"
crosspost_to_medium: false
tags: rss
image:
  feature: miniflux_header.png
  path: /images/miniflux_header.png
---

## Guys, I broke up with my RSS reader...

Until recently, if you asked me to recommend a self-hosted RSS reader, I would have pointed you towards every geek's favorite, [Tiny Tiny RSS](https://tt-rss.org/).

For reasons I'll explain below, it's over.

I've turned off [my Tiny Tiny RSS docker stack](https://geek-cookbook.funkypenguin.co.nz/recipies/tiny-tiny-rss/), and demoted it from the "Chef's Favorites" back to the general menu, in favor of my new darling, [Miniflux](https://geek-cookbook.funkypenguin.co.nz/recipies/miniflux/).

## Farewell, Tiny Tiny RSS!

So why did I leave Tiny Tiny RSS?

1. **I don't like her parents**. I hadn't personally experienced the "[asshole dev](https://chrisshort.net/tiny-tiny-rss-loathe-the-asshole-devs/)" [factor](https://www.reddit.com/r/linux/comments/33oorc/you_cant_write_software_that_users_love_if_you/), but [the forum thread](https://discourse.tt-rss.org/t/gitlab-is-overbloated-shit-garbage/325/6) re a migration from GitLab sums up the dev culture, and I don't like it.
2. **We're not into the same things**. I realized that although it has all these **cool** features, I actually wasn't using any of them. (Some weren't easy to use, like [feediron](https://github.com/m42e/ttrss_plugin-feediron))
3. **I didn't feel good around her**. I realized I was avoiding using the webUI because the volume of feeds I follow, and all the unread indicators, simply overwhelmed me and made it feel like work. (_I do realize this is an issue of my own creation, and not specifically TTRSS's fault!_)
4. **I don't like the company she keeps**. TTRSS's website currently lists two sponsors, one of which is a shady "pay-for-instagram-followers" organization. That leaves a bad taste in my mouth.
5. **She was "high maintenance"**. [My recipe](https://geek-cookbook.funkypenguin.co.nz/recipies/tiny-tiny-rss/) to run (and backup) Tiny Tiny RSS was complicated and fiddly, with [workarounds for the app starting before the database](https://github.com/x86dev/docker-ttrss/pull/12), and for the incredibly slow upstream git repo.

Each of these issues I could have overlooked, but all combined, they had me unsatisfied with our relationship. I stuck it out until something better came along, and then I broke it off...

## Hello Miniflux

So what's so great about Miniflux?

1. **Her parents are well-respected**. The [github repo](https://github.com/miniflux/miniflux) shows 400 closed issues, 240 closed pull requests, and over 1,200 commits. The developer, [Frédéric Guillot](https://github.com/fguillot) also develops [Kanboard](https://kanboard.net/), the geek-favorite Kanban tool, which I hope to feature in a future recipe/review.
2. **She's classy**. Intentionally minimalist, there's only one way to read your feeds, and it's not the classic "_RSS-as-an-inbox_" paradigm which Google Reader popularized.
3. **She's true to herself**. While there are fewer "bells and whistles" in Miniflux, the features that are implemented work well, and stay out of the way. For example, you can download the full content of an article (rather than an excerpt) by hitting "d" on the webUI, or using a checkbox on the feed definition.
4. **She's not a burden**. By default (_and I've left my installation this way_), Miniflux uses an sqlite database. For an app used by a single geek a few times a day, sqlite works perfectly well, and is super-simple to backup/restore. The [container](https://geek-cookbook.funkypenguin.co.nz/recipies/miniflux/) I run uses a max of 5 concurrent Nginx processes, and my (_somewhat underpowered_)  [docker swarm cluster](https://geek-cookbook.funkypenguin.co.nz/ha-docker-swarm/design/) doesn't even feel the extra load.

## Miniflux review

So let me introduce you to her...

### The WebUI experience

Using Miniflux's native UI looks like a cross between Medium and every other minimalist bootstrap-based theme you've seen. Which I don't think is a bad thing. The UI is distinctly "un-sexy", and stays out of the way while you read RSS contents. Which is, you know, the point of an RSS reader.

![Miniflux default theme](https://www.dropbox.com/s/gdhg7skwle5uzcv/miniflux_default.png?raw=1)

You can theme the UI though - the screenshot below is best "dark" theme I've found, called "[sun](https://github.com/Cygnusfear/Miniflux-Theme-Sun)". Installing themes is simply a matter of got cloning the theme URL in the the /themes/ directory, and selecting the theme from preferences.

The UI is responsive, meaning anything you can do on the desktop UI, you can do on your mobile device, including editing feed settings to enable full content download.

![](https://www.dropbox.com/s/nhotifqe5gs12lg/miniflux_sun.png?raw=1)


### The mobile app experience

What originally attracted me to Miniflux was it's for the [Fever API](https://miniflux.net/documentation/fever). I wanted to use a mobile RSS reader (_I do most of my reading on my iPhone_), and all the best apps support the Fever API.

I use two iOS apps with miniflux. The first is "[Unread](https://www.goldenhillsoftware.com/unread/)", which eschews feed management and folder structure for a beautiful reading experience. See an example below - isn't that beautiful? (See a MacStories review [here](https://www.macstories.net/reviews/unread-review/))

![](https://www.dropbox.com/s/ssm7kmjrli31ugt/unread.png?raw=1)

The second is the RSS power-user's app of choice, [Fiery Feeds](http://cocoacake.net/apps/fiery/). This was my original go-to app for its TTRSS support, but it supports Fever API too, and provides an only-slightly-less-beautiful reading experience, with a wealth of sharing options.

![](https://www.dropbox.com/s/5xsccmjpln2qd6t/fieryfeeds.png?raw=1)

As you see, the two apps have two different use-cases. Fiery Feeds is for powering through your feed subscriptions, whereas Unread is for kicking back in the couch and enjoying a few articles.

### Downloading full content

I don't like seeing feed excerpts. I start reading an article which grabs my interest, and then after a paragraph or two, I'm forced to click through to the original site to read the remainder of the contents. This switches me from the UI of my choice to the site's own (_usually, content-heavy_) design. Typically the next thing I do is bring up Safari's "reader mode" to focus (once again) on the content.

What I want is to be able to see the entire article from my RSS reader. I could do this with Tiny Tiny RSS (_using the FeedIron plugin_) but it was a complicated PITA.

To download a full article, you click the "**download content**" link (_or type 'd'_) on an excerpt article to tell Miniflux to fetch the full content. If you want to preemptively fetch the full content for every article in a particular feed, you can enable this by editing your feed subscription. If you are so inclined, you can create and share your own grabber rules file. (There's a  [list of currently supported feeds](https://github.com/miniflux/miniflux/tree/master/vendor/miniflux/picofeed/lib/PicoFeed/Rules))

### Bookmarking articles

I've never really appreciated the "star" feature as popularize by GMail. I get that you'd want to "Like" a status update, or "Favorite" a tweet, since you're providing feedback to another user, but what good does it do to single out something that only you'll see?

Miniflux calls this feature "bookmarking", and it does just what "starring" does in other readers, but calling it "bookmarking" makes its purpose a little easier (_for this grumpy oldtimer_) to appreciate.

What's interesting is what you can do with bookmarked articles. Miniflux can automatically send your bookmarks to Pinboard or Instapaper, plus ol' familiar self-hosted tools Shaarli and Wallabag.

It works without confirmation or feedback. I set my instance up to send all bookmarks to a [pinboard tag](https://pinboard.in/u:funkypenguin/t:bon/) (_which auto-publishes a daily summary on my blog like [this](https://www.funkypenguin.co.nz/bookmarks/of-note-19-august-2017/)_)

You also get an RSS feed for all your bookmarked articles (_I pipe my bookmarked articles to [twitter](https://twitter.com/funkypenguin)_)

### Search

You can search Miniflux via the webUI, but in a quirk of minimalism, the search dialogue doesn't show up until you hit the keyboard shortcut ("/).

### History

Miniflux maintains a history of every article you've read. And yes, your reading history shows up in the search too.
