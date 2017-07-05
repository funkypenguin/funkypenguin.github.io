---
layout: "post"
title: "Tiny Tiny RSS"
date: "2017-07-04 21:58"
#image:
#  feature: tiny-tiny-rss.png
#  thumb: tiny-tiny-rss-thumbnail.jpg #keep it square 200x200 px is good
excerpt: Self-hosted alternative to Google Reader
tags:
  - postgresql
  - ruby
  - nginx
  - docker
---


# Introduction

[Tiny Tiny RSS][ttrss] is a self-hosted, AJAX-based RSS reader, which rose to popularity as a replacement for Google Reader. It supports advanced features, such as:

* Plugins and themeing in a drop-in fashion
* Filtering (discard all articles with title matching "trump")
* Sharing articles via a unique public URL/feed

---
* TOC
{:toc}

# Ingredients (Required)

1. Webserver
2. Database (postgresql/mysql)


# Ingredients (Optional)

1. Email server

# Preparation

## Setup database

## Do something ELSE

1. aeuaeou
2. oaeuaoeu
3. aoeueoau

[ttrss]: https://tt-rss.org/fox/tt-rss/wikis/home

## Enable similar-post detection

Launch postgresql (in this case, I launched it within its docker environment)
````
[root@kvm nginx]# docker exec -it ttrss_postgres_1 /bin/sh
# su - postgres
No directory, logging in with HOME=/
$ psql
psql (9.6.3)
Type "help" for help.
````

Add the trgm extension to your ttrss database:
````
postgres=# \c ttrss
You are now connected to database "ttrss" as user "postgres".
ttrss=# CREATE EXTENSION pg_trgm;
CREATE EXTENSION
ttrss=# \q
````
