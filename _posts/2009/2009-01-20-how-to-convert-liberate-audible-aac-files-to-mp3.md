---
title: Convert (liberate) Audible AAC files to MP3
layout: post
permalink: /how-to/convert-liberate-audible-aac-files-to-mp3/
redirect_from: /note/how-to-convert-liberate-audible-aac-files-to-mp3/
header: no
categories:
  - how-to
---
I was an [Audible][1] subscriber for over 2 years, and although I'm no longer active on a plan, I still have 50+ books that I've legitimately purchased. Each of them, however, is locked to my Audible username and password. I don't tolerate DRM where possible, and I've done enough system reloads / iPod upgrades to be frustrated at the need to authorize my new devices, and de-authorize my old ones. (and get Audible to reset my devices, since it's impossible to de-authorize a dead computer!)

Here are the steps required to convert your Audible titles to standard, un-restricted MP3 files, which you can then do what you want with. Note to scurvy pirates: the process still requires your Audible username and password!<!--more-->

  * Download [Audible Manager for Windows][2]
  * Download [dBpoweramp Music Converter][3] (dMC-r10.exe is the last freeware version, newer ones will expire after 30 days)
  * Download the latest "[lame_enc.dll][4]" (it's in the zipfile version)
  * Download [dBpoweramp DirectShow Decoder][5] (use this direct link, it's for the older version)
  * Download the [Audible Media Player Filter][6] (or [search for it][7])
  * Install dBpoweramp and the DirectShow Decoder.
  * Extract lame_enc.dll to C:\Program Files\Illustrate\dBpowerAMP\Compression\Lame\
  * Add ".aa" to DSExt.txt by clicking Start -> Programs -> DB Poweramp -> Configure DirectShow..
  * Install Audible Media Player Filter. You may also need to download [msvcr70.dll][8] and [msvci70.dll][9] to get it to install successfully
  * Download one of your Audible books from your Library, and play it in Audible Manager. You will need to enter your Audible username and password. Remember to put the playback position back to the beginning for the book, else conversion will only start where you last stopped playback!
  * Once you're able to play a downloaded book, open dBpoweramp Music Converter, choose your source file, and set the following sensible defaults:
      * Check that you're converting to "MP3 (Lame)"
      * Set Target to Bit Rate (CBR) : 32kbps
      * Under "Advanced", uncheck the "Original" option<figure id="attachment_1112" style="width: 300px;" class="wp-caption aligncenter">


![](http://www.funkypenguin.co.nz/wp-content/uploads/2009/01/TinyXP-Rev08-1-300x150.jpg)

  * Click "Convert"

![](http://www.funkypenguin.co.nz/wp-content/uploads/2009/01/TinyXP-Rev08-300x138.jpg)


  * Update [28 July 2009] : Added specific links to download older versions of dBpoweramp and friends, to avoid expiry of MP3 encoder.

 [1]: http://www.audible.com
 [2]: http://www.audible.com/software/
 [3]: http://web.archive.org/web/20110224225448/http://afewbeers.com/stuff/programs/dMC-r10.exe "dBpoweramp Music Converter"
 [4]: http://lame.buanzo.com.ar/ "Latest lame_enc.dll"
 [5]: http://www.dbpoweramp.com/codecs/dBpowerAMP-codec-DirectShowDecoder.exe "dBpoweramp DirectShow Decoder"
 [6]: http://www.coolutils.com/Downloads/AudibleMediaPlayerFilter.exe "Audible Media Player Filter"
 [7]: http://www.google.co.nz/search?q=AudibleMediaPlayerFilter.exe
 [8]: http://www.google.co.nz/search?q=msvcr70.dll
 [9]: http://www.google.co.nz/search?q=msvci70.dll
