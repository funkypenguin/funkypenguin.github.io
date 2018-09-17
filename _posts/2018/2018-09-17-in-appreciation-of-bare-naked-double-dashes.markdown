---
layout: "post"
title: "In appreciation of bare (naked) double-D(ashes)"
date: "2018-09-17 21:37"
category:
  - note
tags:
  - bash
---
Today I was trying to grep through a directory structure full of PHP code, looking for a function which, inexplicably, returned ```-6```.

Grepping for anything with a dash as not as easy as one would think, since grep assumes the ```-``` indicates a command argument, and just pauses, waiting for further input, like this:

``` bash
[davidy:~/tmp] 130 % grep -6 stupid-php-files/*
^C
[davidy:~/tmp] 130 % grep "-6" stupid-php-files/*
^C
```

No problem, I figured, I'll just escape the dash. But nope, no, and na-da:

``` bash
[davidy:~/tmp] 130 % grep \-6 stupid-php-files/*
^C
```

### Bare double dash does do the deed!

Finally, Google leads me on a [journey of discovery](https://unix.stackexchange.com/questions/11376/what-does-double-dash-mean-also-known-as-bare-double-dash) of "bare double dashes".

It turns out, a double-dash (```--```) indicates to the built-in bash commands that we're done with command options, allowing the ```-6``` to be searched for as a plain string:

``` bash
[davidy:~/tmp] 130 % grep -- -6 stupid-php-files/*
     return(-6); # because stupid
[davidy:~/tmp] %
```

### What about brackets?

What about grepping for open/closing brackets? (hi, [@tjh](https://twitter.com/tjh))

Turns out that **is** just as simple as escaping the bracket, as illustrated below:

```
[davidy:~/tmp] % grep (because stupid-php-files/*
zsh: unknown file attribute: b
[davidy:~/tmp] 1 % grep \(because stupid-php-files/*
(because I can)
[davidy:~/tmp] %
```

### Practical test 🐒

When I shared my new, groundbreaking discovery, one of my colleagues pointed out that the following is therefore completely safe (_while at the same time quite terrifying_):

```
rf -- -rf /
```

To prove it (_yes, I tested on ```stupid-php-files``` first!_):

```
[davidy:~/tmp] 1 % rm -- -rf /
rm: -rf: No such file or directory
rm: /: is a directory
[davidy:~/tmp] 1 %
```
