---
layout: post
title: Deduplication with bacula using base jobs
date: '2015-10-14 23:20'
categories:
  - howto
tags:
  - bacula
excerpt: Deduplicating common files across your bacula backups, using base jobs
---

## What's Bacula?

[Bacula](http://www.bacula.org) is an open-source set of tools (client and server) for network file-level backup and restore.

Features I like are:

* Optional encrypted transmission and storage (at rest) of data.
* Flexibility re backup scheduling, levels, target files, etc.
* Backs into a MySQL / PostgreSQL database, which makes custom reporting and monitoring possible.

Recently I've been working on updating our design from version 5.0.0 to update to version [7.0.5](http://blog.bacula.org/release-7-0-5/), and one of the features I wanted to leverage was the ability do "deduplicate" backups using [base jobs](http://www.bacula.org/7.0.x-manuals/en/main/File_Deduplication_using_Ba.html).

## Deduplication using Bacula Base Jobs

By using base jobs, it's possible to avoid backing up identical files on multiple hosts - in our case, we have tens of hosts running CentOS 6, all with ~800MB of operating system files, which are identical across hosts. By using a base job, I can backup all the OS files once (the base job), and all other backups will simply refer to the base job rather than backing up the files again.

Bacula's documentation is a little sparse on this, so I'm including a working example below.

## Working example of a bacula base job

A base job:

    # This exists to define a base for CentOS 6 hosts
    Job {
      Name = "base-centos6"
      JobDefs = "jd-base"
      Schedule = base
      Level = Base
      Client = <base-machine-hostname>-fd
    }

A normal job which depends on the base job:

    Job {
      Name = "<bacula-client-hostname>-daily"
      JobDefs = "jd-daily"
      Client = <bacula-client-hostname>-fd
      Base = <base os backup>
      Write Bootstrap = "/var/spool/bacula/<bacula-client-hostname>.bsr"
    }


A standard "daily" job definition. Note that this **must** be an "Accurate" job. If you leave out the "Accurate" directive, a base job will not be used.

    JobDefs {
      Name = "jd-daily"
      Type = Backup
      Level = Incremental
      Client = <bacula-client-hostname>-fd
      FileSet = "fs-linux"
      Schedule = "daily"
      Storage = vchanger
      Messages = Daemon
      Pool = daily
      Priority = 10
      Max Run Time = 360 minutes
      # Required for dedupe using base jobs
      Accurate = yes
      # Required to avoid putting jobs in DB before completion (avoids cancelled jobs in the DB)
      Spool Attributes = yes
    }

A corresponding "base" job definition. It's the same as the jd-daily definition above, except for the Level (base jobs are level Base, obviously), Schedule, and Pool (I like to run my base jobs roughly monthly, and keep their storage away from other jobs) fields. I set Client to the bacula client I want to use to create the base job:

    JobDefs {
      Name = "jd-base"
      Type = Backup
      Level = Base
      Client = <bacula-client-hostname>-fd
      FileSet = "fs-linux"
      Schedule = "base"
      Storage = vchanger
      Messages = Daemon
      Pool = base
      Priority = 9
      Max Run Time = 600 minutes
      # Required for dedupe using base jobs
      Accurate = yes
      # Required to avoid putting jobs in DB before completion (avoids cancelled jobs in the DB)
      Spool Attributes = yes
}

## Sample output of a bacula base job

You know your base job is working, if your job output includes the following on starting:

    14-Oct 23:08 bacula-dir JobId 21: Using Device "vchanger-0" to write.
    14-Oct 23:08 bacula-dir JobId 21: Using BaseJobId(s): 1
    14-Oct 23:08 bacula-dir JobId 21: Sending Accurate information to the FD.

And the following on completion:

    14-Oct 23:10 bacula-fd JobId 21: Space saved with Base jobs: 1665 MB
