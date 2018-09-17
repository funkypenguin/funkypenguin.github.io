---
layout: "post"
title: "How I removed a file from my git repo history"
date: "2018-09-19 22:50"
category: note
tag: git
---
While making my most recent commit to my blog, I discovered (_after the fact_) that I'd accidentally committed a screenshot from a customer project, into my /images/ subdirectory.

While not a big deal (_not as if it was a password file!_), it's still an embarrassing bungle, so I wanted to purge it from my git repo and all previous commits.

Some [research](https://www.theguardian.com/info/developer-blog/2013/apr/29/rewrite-git-history-with-the-bfg) led me to [The BFG](https://rtyley.github.io/bfg-repo-cleaner/), a java-based repo-scrubbing tool, which saved me from embarassment.

First, I downloaded the [latest version](http://repo1.maven.org/maven2/com/madgag/bfg/1.13.0/bfg-1.13.0.jar) of BFG, then I made a "bare" clone of my repo (_bare = the git data but not the actual files_).

I ran ```java -jar bfg-1.13.0.jar --delete-files "Screenshot at Oct 05 15-58-30.png" www.funkypenguin.co.nz.git``` against my bare repo, but stumbled on this issue:

```
Protected commits
-----------------

These are your protected commits, and so their contents will NOT be altered:

 * commit fdc05636 (protected by 'HEAD') - contains 1 dirty file :
	- images/Screenshot at Oct 05 15-58-30.png (410.1 KB)

WARNING: The dirty content above may be removed from other commits, but as
the *protected* commits still use it, it will STILL exist in your repository.

Details of protected dirty content have been recorded here :

/Users/davidy/Downloads/www.funkypenguin.co.nz.git.bfg-report/2018-09-17/22-35-19/protected-dirt/

If you *really* want this content gone, make a manual commit that removes it,
and then run the BFG on a fresh copy of your repo.
```

BFG warned me that I couldn't delete any files in a protected commit (_i.e. HEAD_), so I made a dummy commit to move HEAD on from the commit including the screenshot, re-bare-cloned the repo, and tried again. This time, success:

```
Deleted files
-------------

	Filename                            Git id
	-------------------------------------------------------
	Screenshot at Oct 05 15-58-30.png | b44c3154 (410.1 KB)


In total, 8 object ids were changed. Full details are logged here:

	/Users/davidy/Downloads/www.funkypenguin.co.nz.git.bfg-report/2018-09-17/22-37-28

BFG run is complete! When ready, run: git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

As instructed, I chdir'd into my repo directory, and ran ```git reflog expire --expire=now --all && git gc --prune=now --aggressive``` to complete the purge.

Now the screenshot is gone, and scrubbed from my git repo history 👍
