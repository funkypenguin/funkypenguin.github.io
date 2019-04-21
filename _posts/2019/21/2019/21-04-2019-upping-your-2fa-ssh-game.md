---
date: 2019/21-04-2019
title: "Upping your 2FA SSH game"
excerpt: "Think you’ve setup your SSH securely enough? So did I. I was wrong."
category: "opinion"
image:
  path: "https://www.dropbox.com/s/qrvkfk5f97d1gxu/IMG_0442.jpeg?raw=1"
  thumbnail: "https://www.dropbox.com/s/70pkwcyuq7y1lf0/thumbnails.jpeg?raw=1"
  caption:
tags: 
  - ssh

---

I just read this [interesting tutorial](https://gist.github.com/lizthegrey/9c21673f33186a9cc775464afbdce820) by [@lizthegrey](https://twitter.com/lizthegrey) on adding 2 factor auth (2FA) to SSH, using either TOTP (_time-based one-time password_) or hardware auth tokens.

> Hi! I'm Liz, a Developer Advocate at honeycomb.io, and I spent my first weeks at the company doing security hardening of our infrastructure. I'd like to share what I'd learned with you, so that you can benefit from my reading of dozens of scattered pages of documentation and my ruling out of numerous dead ends.

Thanks Liz! I’ve tried to implement security hooks into pam on Linux systems before, and I fully appreciate the PITA that dead ends and arcane old docs is!

> First, start by enabling numerical time-based one time password (TOTP) for SSH authentication. Is it perfect? No, since a malicious host could impersonate the real bastion (if strict host checking isn't on), intercept your OTP, and then use it to authenticate to the real bastion. But it's better than being wormed or compromised because you forgot to take basic measures against even a passive adversary.

OK, that’s a great first step, I agree. It’ll be a nuisance to have to look up my OTP on every session though, I hope there’s a better way.. (_spoiler: read on, there is, but it’s geeky_)

> Convert it and put it into a phone-based authenticator app: Run oathtool -v [key] to convert it to the format (“Base32 secret”) that mobile authenticators use.

Possible improvement here might be to pipe it through to URL (_[http://goqr.me/api/](http://goqr.me/api/), for example)_ which could turn it into a scannable QR code. Why? I don’t fancy retyping that Base32 secret into Authy on my iPhone if I don’t have to!

> Let's check that we're asking for TOTPs:
> 
> ➜ ssh -A bastion
> Enter passphrase for key '[snip]': 
> One-time password (OATH) for '[user]': 
> Welcome to Ubuntu 18.04.1 LTS...

That’s neat, and simple too!

> Follow these instructions from a Linux host to set up a basic working hardened YubiKey SSH key:

The instructions here are for Linux only. Can I make it work with a YubiKey from a MacOS host?

In summary, I found this post highlighted how little I know about some of the ways to further secure SSH. Thanks Liz for the upgrade, and for pointing me to [Krypt.co’s explanation](https://krypt.co/docs/ssh/using-a-bastion-host.html) of why AgentForwarding is **Bad**, and ProxyCommand is **Good**.
