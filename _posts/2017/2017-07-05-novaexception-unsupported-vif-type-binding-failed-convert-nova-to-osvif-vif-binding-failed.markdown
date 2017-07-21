---
layout: "post"
title: "Recovering from '_nova_to_osvif_vif_binding_failed'"
excerpt: Or how to catastrophically break (and recover) your nova compute node with a failed live-migration
date: "2017-07-05 19:39"
category: note
tag: openstack
---
I was showing off my OpenStack dev cluster to a co-worker, and spouting off about how easy and user-proof live-migration is. I challenged him to try it, and he subsequently **broke my OpenStack**, by trying to live-migrate instances to a compute node targets whose FQDN doesn't exist (_using client CLI commands_). Apparently this makes nova sit in a permanent "migration" state (see bug #[1643623](https://bugs.launchpad.net/nova/+bug/1643623)).

Then, in trying to help solve this embarrassing problem, I reset one of my two controllers (in HA, of course, what could go wrong?). Immediately rabbitmq died on the **other** (non-rebooted) controller. (Insert **second** bug report ___here___).

I fixed rabbitmq by manually restarting the containers on both controller nodes, but somehow while I wasn't looking, I'd ignored database errors, and turned my 3-node Galera cluster into single, non-Primary node, and so I had no working database (_luckily I didn't loose data, since the non-primary node kept running_).

After recovering from the **Galera** fault (````mysql -e "SET GLOBAL wsrep_provider_options='pc.bootstrap=yes';"````), I found that one of my 3 compute nodes was refusing to start nova-compute. (_It's possible that this actually is where my problems **started**_).

The error in nova-compute.log was:

````NovaException: Unsupported VIF type binding_failed convert '_nova_to_osvif_vif_binding_failed'````

Based on the context of the error, it happened just after trying to attach a bridge interface to an instance:


````
2017-07-05 16:15:22.982 29499 INFO os_vif [req-fc8fcaa8-47e9-4db2-98ab-bda00e3f9411 - - - - -] Successfully plugged vif VIFBridge(active=True,address=54:52:00:22:40:76,bridge_name='brq8c6701b4-66',has_traffic_filtering=True,id=44d3ea78-fc43-4943-be66-e96d84190aed,network=Network(8c6701b4-6676-4605-b4aa-314ae64bbd04),plugin='linux_bridge',port_profile=<?>,preserve_on_delete=True,vif_name='tap44d3ea78-fc')
2017-07-05 16:15:23.036 29499 ERROR oslo_service.service [req-fc8fcaa8-47e9-4db2-98ab-bda00e3f9411 - - - - -] Error starting thread.
2017-07-05 16:15:23.036 29499 ERROR oslo_service.service Traceback (most recent call last):
<snip>
2017-07-05 16:15:23.036 29499 ERROR oslo_service.service NovaException: Unsupported VIF type binding_failed convert '_nova_to_osvif_vif_binding_failed'
2017-07-05 16:15:23.036 29499 ERROR oslo_service.service
````

Googling ````_nova_to_osvif_vif_binding_failed```` brings up a whole **two** results, one of which is a [RedHat support page](https://access.redhat.com/discussions/2905491), describing a similar issue fixed with a "database massage" (_don't ask_). This led me to look into the MySQL ````nova```` database, in the ````instance_info_caches```` table, where I found the following:

````
<snip>
| 2017-05-07 08:54:06 | 2017-05-08 10:45:54 | NULL                |  23 | [{"profile": {}, "ovs_interfaceid": null, "preserve_on_delete": true, "network": {"bridge": "brq8c6701b4-66", "subnets": [{"ips": [{"meta": {}, "version": 4, "type": "fixed", "floating_ips": [], "address": "124.155.224.76"}], "version": 4, "meta": {"dhcp_server": "124.155.224.116"}, "dns": [{"meta": {}, "version": 4, "type": "dns", "address": "202.170.160.1"}], "routes": [], "cidr": "124.155.224.64/26", "gateway": {"meta": {}, "version": 4, "type": "gateway", "address": "124.155.224.65"}}], "meta": {"injected": false, "tenant_id": "1873e656f0d74a318b799d4e69f68903", "should_create_bridge": true, "mtu": 1500}, "id": "8c6701b4-6676-4605-b4aa-314ae64bbd04", "label": "network-pnl-dev"}, "devname": "tap44d3ea78-fc", "vnic_type": "normal", "qbh_params": null, "meta": {}, "details": {"port_filter": true}, "address": "54:52:00:22:40:76", "active": true, "type": "bridge", "id": "44d3ea78-fc43-4943-be66-e96d84190aed", "qbg_params": null}]        | aeb25e9c-938a-48e4-9555-e034e6ec9de5 |       0 |
| 2017-05-07 09:35:00 | 2017-07-04 03:48:58 | NULL                |  26 | [{"profile": {"migrating_to": "nbs-dh-03"}, "ovs_interfaceid": null, "preserve_on_delete": true, "network": {"bridge": null, "subnets": [{"ips": [{"meta": {}, "version": 4, "type": "fixed", "floating_ips": [], "address": "124.155.224.82"}], "version": 4, "meta": {"dhcp_server": "124.155.224.116"}, "dns": [{"meta": {}, "version": 4, "type": "dns", "address": "202.170.160.1"}], "routes": [], "cidr": "124.155.224.64/26", "gateway": {"meta": {}, "version": 4, "type": "gateway", "address": "124.155.224.65"}}], "meta": {"injected": false, "tenant_id": "1873e656f0d74a318b799d4e69f68903", "mtu": 1500}, "id": "8c6701b4-6676-4605-b4aa-314ae64bbd04", "label": "network-pnl-dev"}, "devname": "tapcfb58bf7-5b", "vnic_type": "normal", "qbh_params": null, "meta": {}, "details": {}, "address": "54:52:00:22:40:82", "active": false, "type": "binding_failed", "id": "cfb58bf7-5b97-46a3-b9f0-c3c964c1c513", "qbg_params": null}]                                 | aeab9f54-163b-4c4e-9cac-16fd7e264b59
<snip>
````

Note the first (working) entry includes a bridge definition: ````"network": {"bridge": "brq8c6701b4-66",````, whereas the second entry (_suspiciously including the text_ ___migrating_to___) defines ````"network": {"bridge": null,````...

Not experienced, brave, or dumb enough to "_massage_" the database myself, I just deleted the instance (_which fortunately was configured with a persistent volume_). I restarted nova-compute on the troublesome compute node, and **boom**, nova started up properly.

I recreated my deleted instance, attached it to its original volumes, and now all my compute nodes are up again.

---

So, here's how I think it went down:

1. Nova started live-migration, but failed to complete due to co-worker (_let's blame him_).
2. The database's ````nova.instance_info_caches```` table consequently recorded incomplete data for the instance which was being migrated (probably because of me screwing around with the controllers and breaking Galera quorum).
3. When I tried to restart nova-compute on my compute node, nova polled the database to find its running instances, tried to start an instance based on the incomplete data for the being-migrated node, failed, and so nova-compute died.
4. When I deleted the instance, the database record for it was removed, allowing nova-compute to start normally

What have I learned?

1. Monitor **all** the HA, and check with monitoring **before** rebooting HA-protected nodes
2. More than just monitoring processes, monitor the actual __function__ of the processes. This means testing rabbitmq, galera, etc end-to-end (_rabbitmq process was actually alive but the logfile recorded it was killed, and the container was stopped_)
3. CLI commands (_as opposed to Horizon UI_) are powerful and can break stuff which Horizon wouldn't permit you to break.
