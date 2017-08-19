---
layout: post
title: Errors when installing OpenStack Newton on CentOS7 with packstack
date: '2017-02-11 19:50'
category: note
tags: 'openstack, centos7, rdo'
crosspost_to_medium: false
---

While establishing a new OpenStack Newton installation on CentOS7 using [packstack](https://www.rdoproject.org/install/quickstart/), I encountered the following error after running ````packstack --allinone```` (_doing a multi-node install made no difference, though_)

````
Applying Puppet manifests                         [ ERROR ]

ERROR : Error appeared during Puppet run: 172.16.83.2_controller.pp
Error: Could not prefetch keystone_role provider 'openstack': Could not authenticate
You will find full trace in log /var/tmp/packstack/20170210-132054-KQp_cn/manifests/172.16.83.2_controller.pp.log
Please check log file /var/tmp/packstack/20170210-132054-KQp_cn/openstack-setup.log for more information
Additional information:
````

This stumped me for days, until I thought to check the Keystone http logs at **/var/log/httpd/keystone_wsgi_admin_error.log**

````
[Fri Feb 10 14:03:51.563880 2017] [core:error] [pid 8667] (13)Permission denied: [client 172.16.83.2:59776] AH00035: access to / denied (filesystem path '/var/www/cgi-bin/keystone/keystone-admin') because search permissions are missing on a component of the path
[Fri Feb 10 14:04:41.853147 2017] [core:error] [pid 8671] (13)Permission denied: [client 172.16.83.2:59780] AH00035: access to / denied (filesystem path '/var/www/cgi-bin/keystone/keystone-admin') because search permissions are missing on a component of the path
````

Finally, a clue! This led me to a [bug](https://bugs.launchpad.net/puppet-keystone/+bug/1645299) affecting the permissions when **$keystone_wsgi_script_path** is created, if this system is using a more-restrictive-than-usual umask (_mine is_). The bug has been fixed in **puppet-keystone 10.1.0**, but RDO's CentOS7 repo only includes **puppet-keystone-9.4.0-1.el7.noarch**.

I fixed this in the short term after the failure, by running:
````chmod 755 /var/www/cgi-bin/keystone````.

I then re-ran ````packstack --allinone````, and my installation completed successfully.
