---
layout: page
title: "openssl-1.0.1e-30 broke sendmail, mysql on rhel/centos 5/6"
date: "2015-06-09 13:57"
redirect_from: /openssl-101e-30-broke-sendmail-mysql-on-rhelcentos-56/
categories:
  - note
---
After being abruptly awakened on Saturday morning at 4am (nightly cron job for yum updates), we found that an upstream RHEL/CentOS [update had changed the minimum acceptable length of DH keys to 768 bits][2].

The initial alarm which alerted us to this was from the Nagios check\_smtp plugin against our mail platform, which reported "_Cannot make SSL connection_", with extended info of:

    SSL routines:SSL3_CHECK_CERT_AND_ALGORITHM:dh key too small:s3_clnt.c:3304"

Subsequently, we also discovered that our MySQL replication (over SSL) broke at the same time.

Fixes documented below:

## Sendmail (RHEL/CentOS5)

Turns out the default sendmail installation uses < 768bit DH keys for TLS. To fore a large DH key, it's necessary to manually generate one, using:

    openssl dhparam -out /etc/mail/ssl/dhparam.pem -2 1024

And then add the following to sendmail.mc:

    define(`confDH_PARAMETERS',`/etc/mail/ssl/dhparam.pem')

Run "cd /etc/mail && make", followed by "service sendmail restart" to apply.


## MySQL

Whatever MySQL's default cipher is, doesn't support > 512bit DH keys. At the advice of [www.couyon.net][1], I added the following to /etc/my.cnf

    ssl-cipher=CAMELLIA128-SHA

And ran "service mysqld restart" to apply the changes


[1]: http://www.couyon.net/blog/if-all-of-your-mysql-ssl-clients-just-broke
[2]: https://rhn.redhat.com/errata/RHSA-2015-1072.html
