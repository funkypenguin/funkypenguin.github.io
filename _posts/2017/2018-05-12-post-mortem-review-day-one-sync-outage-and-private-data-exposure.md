---
layout: post
category: opinion
date: 2018-05-11 17:15:42
title: "Post-mortem review : DayOne sync outage and private data exposure"
excerpt: "Lessons from a series of predictable, avoidable failures"
tags: post-mortem
---
I’m a long-term user of [Day One](http://DayOne app.com), the premier journaling app for  iOS/MacOS. In 2017, Day One introduced end-to-end encryption on user journals (*which I use*), to protect the journal data synced with their proprietary service (*that became mandatory after Dropbox sync was dropped in v2*)

This morning, I read the  [May 2018 Day One Outage Postmortem](http://help.dayoneapp.com/day-one-sync/may-2018-day-one-outage-postmortem), describing how a hardware failure, followed by a questionable restore decision, and exacerbated by failed backups, led to the the worst possible outcome - the sharing of a user’s private journal entries with another user...

> A hardware failure on May 7 caused an initial sync outage. In the process of restoring sync service on May 8, a small number of new accounts were accidentally assigned the same account ID as existing accounts due to the use of an incomplete backup. This led to these new accounts gaining access to journals created by the original owner of that account ID. We disabled sync again as soon as we became aware of this. This issue affected 106 users, less than 0.01% of our accounts.

I read post-mortems as an exercise to improve my own post-mortem skills (_I’ve been in involved in a **lot** of incidents at [Prophecy](http://www.prophecy.net.nz) over the years!_), and the following is my response to this one.

> The rebalancing operation failed. This began our initial sync outage. In the interest of restoring sync service quickly, we decided to build a new database cluster and restore it from a recent backup. A new cluster was provisioned and restored from the backup.

​A decision made **during** an outage is unlikely to be as careful or considered as a pre-plan made beforehand, when seas are calm. In this case, the "shortcut" taken to address the rebalancing failure created a far-worse fault (*the unintended sharing of personal journal data*)

> On the morning of Wednesday, May 9, we determined the root cause of the issue. The backup we had used in the restore was incomplete—it contained all the journal data, but was missing some user accounts. Specifically, it was missing all accounts created after March 22. One result of this missing data was that accounts created after that date were unable to log in. Another result was a limited amount of unintentional data sharing.

I think this is a bigger issue which needs to be understood. How can you be confident that the backup you restored contains all the data, if you can’t explain why the user accounts are missing? Why didn’t backup/restore tests identify the loss (*e.g. comparing a total of users accounts and journal entries from the restored backup with the production database*)

> We discovered a few configuration errors that were causing constantly-increasing load on the database over the course of the rebalance, which was causing it to eventually fail.

Were these configuration issues also present in your dev environment, and did you see similar failures when attempting a rebalance in dev?

> We made the decision to delay restoring sync service until Thursday morning, when our engineering and support staff would be available to address any concerns

This was a good decision. Even if your technical fix is sound, the back-online user experience is what’s going to make users outraged or placated.

> Affected users will have 30 days after installing to sign into their Day One account, which will allow the app to verify that they are the original owner of that content and will restore access to the journal. The app will notify users if they are affected by this change.

So, if an infrequent user auto-updates their app but doesn’t *use* it for 30 days, then the app will *permanently delete* their content without notice (because they didn’t open the app). I’d be afraid this would end badly.

> When creating a new account ID, we will verify that no journals exist referencing that account ID.
> New account IDs will be created with a random two-digit number appended to the primary incrementing ID. This means that even if we were to accidentally start creating account IDs at a too-low number in the future, the chance of any account ID collision would be very small.

Both of these seem like a bit of a after-the-fact workaround. Isn’t there a more suitable, long-term solution which can be employed, such as [UUID](https://en.m.wikipedia.org/wiki/Universally_unique_identifier)?

## Root Cause

The root cause of the incident, in my opinion, is a lack of:
1. A testing environment simulating production (*all of this should have been tested in dev/preprod*)
2. A test regime for predictable failures (*hardware issues*)
3. Rigorous backup/restore testing processes (*an untested backup is a failed backup*)

## Notes

DayOne are to be congratulated on their transparency, even if it reflects poorly on their internal processes. I’d suggest an additional next-action of reviewing processes and preplans such that similar hardware failures could be handled as a routine operation in future.