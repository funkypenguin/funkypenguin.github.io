---
layout: "post"
title: "Wife-friendly script to transfer media to USB from linux server"
date: "2018-05-29 20:56"
categories: note
tags: geeklife
---
My home media is on a [Plex](https://geek-cookbook.funkypenguin.co.nz/recipies/plex/) installation running on a headless server in my (_detached_) home office, and my wife recently arranged to copy some content onto a USB drive for a friend.

To make it easier for her to transfer the media to the USB drive, I wrote up a script, as follows:

<script src="https://gist.github.com/funkypenguin/96d1f2b972811d88691338f6a68f2602.js"></script>

Then I created a local shell account for her, and appended the following to ```~/.bash_profile```, so that the script could only run once, and she could (_theoretically_) drive it from her laptop _or_ her phone:

```
# Launch tmux session
[ -z "$TMUX"  ] && { tmux attach || exec tmux new-session 'sudo /root/scripts/copy_media.sh' && exit;}
```

Finally, I created ```/etc/sudoers.d/wifeysaurus```, setting up sudo access:

```
wifeysaurus ALL= NOPASSWD: /root/scripts/copy_media.sh
```

On her (Mac) laptop, I opened Termial.app, ran ```ssh-keygen``` (no password) followed by ```ssh-copy-id <servername>```, to setup passwordless SSH.

Finally, I temporarily aliased ```ilovedave``` to ```ssh <servername>```, and now she's happily sitting on the couch and transferring content, without having to worry about driving the underlying CentOS6 OS 😁
