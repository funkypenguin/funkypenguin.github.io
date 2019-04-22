---
layout: "post"
title: "Signing git commits from OSX"
date: "2019-04-23 10:36"
excerpt: "How I started signing my git commits from OSX (and you should too)"
category: "note"
tags:
  - git
  - gpg
image:
  path: "/images/verified-commit.png"
  thumbnail: "/images/verified-commit.png"
  caption: "Verified my commit like a boss!"
---
When cleaning up issues/PRs in [Funky Penguin's Geek's Cookbook repository](https://github.com/funkypenguin/geek-cookbook) today, I noticed that [PRs committed from the GitHub website included verified commits](https://github.com/funkypenguin/geek-cookbook/pull/46/commits), but my own commits (from my latop) were not verified.

Determined to correct this, I worked through GitHub's documentation on [commit signature verification](https://help.github.com/en/articles/managing-commit-signature-verification).

Here's the basic path I followed:

Installed GPG:

```bash
brew install gpg
```

I generated myself a key, using defaults and GitHub's recommendation of 4096 bits for my keysize:

```bash
[funkypenguin:~] 1 % gpg --full-generate-key
gpg (GnuPG) 2.2.15; Copyright (C) 2019 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

gpg: directory '/Users/funkypenguin/.gnupg' created
gpg: keybox '/Users/funkypenguin/.gnupg/pubring.kbx' created
Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection?
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

Real name: David Young
Email address: davidy@funkypenguin.co.nz
Comment: https://www.funkypenguin.co.nz
You selected this USER-ID:
    "David Young (https://www.funkypenguin.co.nz) <davidy@funkypenguin.co.nz>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: /Users/funkypenguin/.gnupg/trustdb.gpg: trustdb created
gpg: key 525EF417604A0541 marked as ultimately trusted
gpg: directory '/Users/funkypenguin/.gnupg/openpgp-revocs.d' created
gpg: revocation certificate stored as '/Users/funkypenguin/.gnupg/openpgp-revocs.d/3198CBB012FC221DD99BCA3F525EF417604A0541.rev'
public and secret key created and signed.

pub   rsa4096 2019-04-22 [SC]
      3198CBB012FC221DD99BCA3F525EF417604A0541
uid                      David Young (https://www.funkypenguin.co.nz) <davidy@funkypenguin.co.nz>
sub   rsa4096 2019-04-22 [E]

[funkypenguin:~] %
```

I listed my keys to find my key ID (in the example below, the key ID is `525EF417604A0541`)

```bash
[funkypenguin:~] 130 % gpg --list-secret-keys --keyid-format LONG
gpg: WARNING: server 'gpg-agent' is older than us (2.2.10 < 2.2.15)
gpg: Note: Outdated servers may lack important security fixes.
gpg: Note: Use the command "gpgconf --kill all" to restart them.
/Users/funkypenguin/.gnupg/pubring.kbx
--------------------------------------
sec   rsa4096/525EF417604A0541 2019-04-22 [SC]
      3198CBB012FC221DD99BCA3F525EF417604A0541
uid                 [ultimate] David Young (https://www.funkypenguin.co.nz) <davidy@funkypenguin.co.nz>
ssb   rsa4096/1CC86B12BD8AEEE6 2019-04-22 [E]

[funkypenguin:~] %
```

I exported the key, ASCII-armoured:

```
[funkypenguin:~] % gpg --armour --export 525EF417604A0541
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBFy+OLsBEADNKlxkp3tLddEK02BvHeqfoo8XxAgB87AM5hpvLkAbui8fnEgb
XhJ8v6SnhMNHPthsCq3LRVRggtPkIT0LemB2nibJgCqJhgzC5NE+Uu7WvDt5X860
GWZL7oqFnjq23VBAPNQRiDMiVsCwSqWSsyqCaJzL7UJZw8C88j05sEJEHx9anoBU
<snipped for brevity>
upLSmBs9tzGliP8+XYdPSSe8cQNEEv/sdrsj81VdBW9Zen2RSxEIqTLIHvbwljD0
jKj6Pat3l3oQfi1Be5DORer5r8YiVbdeKBm01vMp9pBkE4/VDUZrMsnQ27uc30sL
2m7atbQoAq3tCNJgZ+jjWx+oFG3hslEnVWe9lkhDpeGryVzQHb5pDYvLQTuTXRV/
d97VRAI+A7gQQFBT88Erdio1fmaa6VoytPBJIJEZ/viBrQGn
=rQDl
-----END PGP PUBLIC KEY BLOCK-----
[funkypenguin:~] %
```

I followed [GitHub's instructions](https://help.github.com/en/articles/adding-a-new-gpg-key-to-your-github-account) (Settings -> SSH/GPG keys) to add the public key to my account

I configured my local git (globally to use my GPG key, and enabled GPGP signing of commits by default:

```
git config --global user.signingkey 525EF417604A0541
git config --global commit.gpgsign true
```

Finally, since I don't want to have to type in my passphrase every time I commit, I installed GPG Suite using brew:

```bash
brew cask install gpg-suite-no-mail
```

The first time I ran a `git commit`, I was prompted by "Pinentry Mac" for my GPG passphrase. I typed my passphrase, and chose to save it in KeyChain.

![Pinentry Mac](/images/pinentry-mac.png)

I pushed a commit, and boom - a verified commit popped out the other end!

![Verified commit](/images/verified-commit.png)