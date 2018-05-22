---
layout: "post"
title: "What is TurtleCoin and why do I care?"
date: "2018-05-16 22:09"
category:
  - opinion
excerpt: What is this silly-named coin and why are you mining it?
---
Some weeks ago I stumbled across [TurtleCoin](https://turtlecoin.lol), while researching new cryptocurrencies to mine, on [cryptunit.com](https://cryptunit.com).

I rolled my eyes at the stupidity of the cryptogeeks, and moved on to mine some [RavenCoin](http://ravencoin.org/), which [r/gpumining](https://www.reddit.com/r/gpumining/) had told me was the new hotness.

As I returned to cryptounit over the next few days, I kept seeing TurtleCoin among the top 3-5 most profitable coins, and my curiosity got the better of me. I researched it, and found that it's a "fun-first" cryptocurrency forked from ByteCoin, and so based on cryptonote, which means it's a distant cousin of [Monero](https://getmonero.org/), reigning king of the privacy coins. In every description however, the **community** was highlighted as the distinguishing feature of TurtleCoin.

This was borne out in my experience, as I started lurking in the [discord chat](http://chat.turtlecoin.lol), and listened to episode #3 of Kevin Rose's [BlockZero podcast](https://itunes.apple.com/us/podcast/id1338620184), featuring TurtleCoin. Just a few days ago, [TurtleCoin won the 'Best Community' award](https://medium.com/@turtlecoin/turtlecoin-weekly-roundup-may-20-2018-41c896a76405) at the Crypto Influence summit, and it continues to build on its reputation for a user-friendly, welcoming community.

--------
**Aside**: In my gamer days in South Africa, I was part of a "gaming clan" called [CHKNHD](https://www.urbandictionary.com/define.php?term=chknhd) (_'Chicken Head', or "running around like headless chickens"_), an irreverant bunch of gamers who (_unlike most "clans"_) were more interested in having fun (_and drinking stroh rum, a process they termed "**devolution**"_) than succeeding at any sort of competitive gaming. TurtleCoin seems to embody that same spirit - focusing on building a dev community rather than hyping yet-another cryptocurrency.

--------

I soon discovered that there were no NZ (or AU) mining pools. So I mined [elsewhere](http://us.turtlepool.space/). But I'd been toying with the idea of running a mining pool for some time, and so this seemed like a good opportunity to (a) write a [Geek's Cookbook recipe re running a mining pool](https://geek-cookbook.funkypenguin.co.nz/recipies/turtle-pool/), and (b) learn more about blockchain tech by getting involved on the "ground floor".

So, I started with a [simple PR](https://github.com/turtlecoin/turtle-pool/pull/11) to correct a typo in the README for "turtle-pool", a fork of forknote-pool. Wanting to test my pool in a "dev environment", I started working on a [Docker container](https://github.com/turtlecoin/turtlecoin/blob/master/Dockerfile.test) to run a [testnet swarm](https://github.com/turtlecoin/turtlecoin/blob/master/testnet.yml).

I ended up creating the first (and only, AFAIK) NZ/AU docker-swarm-based TurtleCoin mining pool, [trtl.heigh-ho.funkypenguin.co.nz](https://trtl.heigh-ho.funkypenguin.co.nz/). After a few weeks, I was hit by the instable daemon issue, and [forced to wait 18 hours while my daemon resynced](https://www.reddit.com/r/TRTL/comments/8jftzt/funky_penguin_nz_mining_pool_down_with_daemon/). I built in an additional daemon for redundancy, plus another standby daemon which syncs-and-shuts-down once a hour, in case both daemons get hit with simultaneous "doomsday blocks". (_The daemon stability is an active developer focus_)

So, now I'm a contributor, and a regular member of the [discord chat](http://chat.turtlecoin.lol). I've met some friendly geeks, and learned about blocks, nodes, daemons, wallets, testnets and pools.

Want to **get involved with TurtleCoin**? Jump into the [discord chat](http://chat.turtlecoin.lol) and mention me (@funkypenguin), and I'll tip you some TRTL to play with ;)

Want to **mine** some TRTLs, using your CPU (or GPU?) Come over to [trtl.heigh-ho.funkypenguin.co.nz](https://trtl.heigh-ho.funkypenguin.co.nz/) and [mine with me](https://www.reddit.com/r/TRTL/comments/8hedcx/mining_buddies_wanted_down_under_in_nz/)!

Some links for further digestion:
* [Official blog](https://medium.com/@turtlecoin), with at least weekly dev roundups
* [Interview](https://www.youtube.com/watch?v=-qYV3IUqw1nI) with anonymous lead dev, "RockSteady"
* Kevin Rose's [interview with RockSteady ](https://itunes.apple.com/us/podcast/id1338620184)
