---
title: Postfix config on OSX Mountain Lion (Server) not where you expect
layout: post
permalink: /note/postfix-config-on-osx-mountain-lion-server-not-where-you-expect/
header: no
categories:
  - note
---
I spent the better part of an hour wondering why my postfix main.cf config changes didn't apply on a OSX Mountain Lion server. Turns out that because "OSX Server" no longer exists (it’s just Server.app now), the postfix files specific to the Mail component of the server now live at:

    /Library/Server/Mail/Config/postfix/

Which is confusing, since the originals still exist at /etc/postfix

Anyway, files edited, service restarted, config applied!
