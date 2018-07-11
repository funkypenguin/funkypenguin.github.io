---
layout: "post"
title: "OpenStack LBAASv2 failed connection debugging"
date: "2018-07-10 22:44"
category: note
tag: openstack
---
I deployed Load-Balancer-As-A-Service (LBAAS) in my lab OpenStack deployment early on, and it worked (_setup in Horizon_) as advertised (_load-balancing inbound HTTP connections to multiple docker swarm nodes_), until I broke the stack by [fiddling with MTU settings](https://lists.gt.net/openstack/operators/64106).

After this breakage and subsequent repair, the LBAAS didn't work properly. Assuming it was something I'd messed up with my MTU schenanigans, I ignored it, setup round-robin DNS as a crude load balancer, and got on with my day.

Looking back now, I remember noticing at the time that a few of my running instances were unreachable, and quickly discovered this was because they had no security groups applied. Questioning my sanity, I reapplied the intended security groups, and the instances were reachable again. I reasoned that perhaps the dev environment (_the unfortunate victim of my learning OpenStack_) had somehow been running for some time with security groups disabled, and my recent work had restored correct function.

Tonight, working on a recipe for a [Masari mining pool](https://geek-cookbook.funkypenguin.co.nz/recipies/masari-pool/), I again banged my head against the Docker Swarm "mesh routing" [ingress SNAT issue](https://github.com/moby/moby/issues/25526), which obscures the original source IP of all inbound traffic (_not great for a mining pool which bans bad/misconfigured miners based on source IP_)

Knowing that employing LBAAS **instead** of swarm routing mesh would solve this problem, I started reading up on [debugging LBAAS](https://docs.openstack.org/liberty/networking-guide/adv-config-lbaas.html), and stumbled across the (linked) instruction to apply a security group to the ```vip_port_id``` belonging to the Load Balancer.

Now, I **know** I had this working before **without** applying a security group. But I decided to test applying a group permitting HTTP ingress to the LB, so I ran ```neutron port-update --security-group sg_david.http-in c7c997e2-5fb9-4b5f-a6f8-679f3e8483bc```.

Boom. Inbound HTTP load balancing started working again.

Befuddled but happy, I added another security group permitting HTTPS. Again, great success.

.. Until I re-tested HTTP, which failed :(

It seems as if it's only possible to associate a **single security group** with a ```vip_port_id``` belonging to a load balancer.

My current solution is to create a single security group, permitting all the ingress ports I need, and applying that group to my load balancer.
