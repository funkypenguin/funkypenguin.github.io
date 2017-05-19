---
layout: page
title: "Merge git forked repo with upstream changes"
date: "2015-04-08 22:38"
excerpt: "Merging upstream improvements into my forked repo turned out to be easier than I expected"
categories:
  - how-to
---
I forked Phlow's excellent "[Feeling Responsive][1]" repository about a month ago, to create this website. I hacked away at config files, added posts, and deleted demo data.

[1]:https://github.com/Phlow/feeling-responsive

Since I'd starred Phlow's repo on GitHub, I noticed that he was continuing to commit fixes and improvements (after I'd forked the repo), and I wanted to incorporate those fixes into __my__ fork, without having to worry about all my changes conflicting with the original demo content.

I tried to get my head around ````git rebase````, but that although I found some [useful instructions](http://think-like-a-git.net/sections/rebase-from-the-ground-up/using-git-cherry-pick-to-simulate-git-rebase.html), I don't think I've entirely understood how this is supposed ot work.

Instead, I managed to use ````git merge```` with great success, by doing the following:

1. Add upstream repo as a remote:

````git remote add upstream https://github.com/Phlow/feeling-responsive.git````

2. "Fetch" the upstream repo (I guess this creates a local copy of the upstream repo's commits)

````git fetch upstream````

3. "Merge" the upstream repo
    it really was as simple as ````git merge upstream/gh-pages````

I ended up with two conflicts:


    [david:~/Documents/Projects/blog] test_merge ± git merge upstream/gh-pages
    Auto-merging pages/documentation.md
    CONFLICT (modify/delete): pages/changelog.md deleted in HEAD and modified in upstream/gh-pages. Version upstream/gh-pages of pages/changelog.md left in tree.
    Auto-merging index.md
    CONFLICT (content): Merge conflict in index.md
    Removing assets/img/windows-8-tile-icon-144x.png
    Removing assets/img/touch-icon-iphone-retina-120x.png
    Removing assets/img/touch-icon-iphone-60x.png
    Removing assets/img/touch-icon-ipad-retina-152x.png
    Removing assets/img/touch-icon-ipad-76x.png
    Removing assets/img/touch-icon-android-152x.png
    Removing assets/img/favicon-32x.png
    Auto-merging _drafts/design/2015-10-11-no-header.md
    Auto-merging _drafts/design/2014-09-10-portfolio.md
    Auto-merging _config.yml
    CONFLICT (content): Merge conflict in _config.yml
    Auto-merging README.md
    Automatic merge failed; fix conflicts and then commit the result.
    [david:~/Documents/Projects/blog] test_merge(+42/-0) 1 ± git status
    On branch test_merge
    You have unmerged paths.
      (fix conflicts and run "git commit")


I ran ````git status```` to identify any issues which needed fixing, and manually resolved 2 minor conflicts. I used ````git rm```` to delete a file I'd already deleted in my local repo.

After ````git status```` reported no more issues (just files which were going to be added / deleted / changed), I was able to run ````git commit -m 'merged with upstream'````, and successfully merged all the upstream goodness!
