---
layout: "post"
title: "Automatically backup postgres docker container"
date: "2017-08-12 23:55"
category: note
tags: docker
published: false
---
While working on the [Tiny Tiny RSS recipe](https://geeks-cookbook.funkypenguin.co.nz/recipies/tiny-tiny-rss/) in the [Geek Cookbook](https://geeks-cookbook.funkypenguin.co.nz/) today, I discovered a handy way to automatically take database dumps of running postgresql containers.

## Why would you want to do this?

Well, at some stage you'll care about backing up the data in your database container. You can't simply backup the data from the docker volume (bind-mounted or not), since the database is running, and the result wouldn't be a clean backup.

I've included an excerpt from the docker-compose v3 recipe for Tiny Tiny RSS below:
```
version: '3'

services:
    db:
      image: postgres:latest
      env_file: /var/data/ttrss/ttrss.env
      volumes:
        - /var/data/ttrss/database:/var/lib/postgresql/data
      networks:
        - internal

<snip>
    db-backup:
      image: postgres:latest
      env_file: /var/data/ttrss/ttrss.env
      volumes:
        - /var/data/ttrss/database-dump:/dump
      entrypoint: |
        bash -c 'bash -s <<EOF
        trap "break;exit" SIGHUP SIGINT SIGTERM
        sleep 2m
        while /bin/true; do
          pg_dump -Fc > /dump/dump_\`date +%d-%m-%Y"_"%H_%M_%S\`.psql
          (ls -t /dump/dump*.psql|head -n $$BACKUP_NUM_KEEP;ls /dump/dump*.psql)|sort|uniq -u|xargs rm -- {}
          sleep $$BACKUP_FREQUENCY
        done
        EOF'
      networks:
      - internal
<snip>
```

See the "db-backup" service? It uses exactly the same container image as the "db" service (so no additional space required), but all it does is sit around running "pg_dump", cleaning up old backups, and waiting.

You need the following variables to make this fly, and the amount of backups to retain, and frequency of backups, are configurable.

```
# Variables for pg_dump running in postgres/latest (used for db-backup)
PGUSER=mydatabaseuser
PGPASSWORD=mypassword
PGHOST=db
BACKUP_NUM_KEEP=3
BACKUP_FREQUENCY=1d
```
