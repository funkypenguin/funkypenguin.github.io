---
layout: "post"
title: "Kubernetes design for self-hosting on public cloud"
date: "2019-02-09 22:31"
excerpt: You're a self-hoster, but you're over managing your own hardware? You want to learn Kubernetes? This cookbook is for you!
tags:
  - kubernetes
category:
  - note
---
For the last few months, I've been working on converting my [Docker Swarm "private cloud" design](https://geek-cookbook.funkypenguin.co.nz/ha-docker-swarm/design/) in the [Geek's Cookbook](https://geek-cookbook.funkypenguin.co.nz) into a Kubernetes design compatible with public cloud providers, but still friendly to self-hosted apps.

One of the most challenging elements was how to manage inbound connections into the cluster. I needed many (_currently 35_) inbound ports (_mining pools, mqtt, unifi, etc_), and providing ingress using my cloud provider's load balancer was cost-prohibitive.

I ended up home-brewing an HAproxy solution on an external VM with a webhook, so that my containers could "phone home" from the Kubernetes cluster and report the public IP of the node they were on. This allowed me to use NodePort to expose all the ports I wanted (_at no cost_) in the cluster, on hosts with unpredictable IP addresses, but to serve each port on the fixed public IP of my HAProxy VM.

This solution also bypassed the annoying fact that NodePort ports _have_ to start from 30000 upwards (_i.e., no 443 for you!_)

The entire design, from [why I like Kubernetes](https://geek-cookbook.funkypenguin.co.nz/kubernetes/start/), to [setting up a basic Kubernetes cluster with Digital Ocean](https://geek-cookbook.funkypenguin.co.nz/kubernetes/cluster/), to configuring a "[poor man's loadbalancer](https://geek-cookbook.funkypenguin.co.nz/kubernetes/loadbalancer/)", automated PV [snapshots](https://geek-cookbook.funkypenguin.co.nz/kubernetes/snapshots/) for backup, and [traefik for ingress HTTPS termination](https://geek-cookbook.funkypenguin.co.nz/kubernetes/traefik/), can be found [here](https://geek-cookbook.funkypenguin.co.nz/kubernetes/start/).

Here's highly technical and accurate diagram:

![](https://geek-cookbook.funkypenguin.co.nz/images/kubernetes-cluster-design.png)
