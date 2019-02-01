---
layout: post
category: opinion
date: 2019-01-28 22:58:27
title: "Why I chose Kubernetes over Docker Swarm"
teaser: "On choosing the best tool for the job"
tags: kubernetes
---

In [Funky Penguin's Geek Cookbook - Kubernetes Start](https://geek-cookbook.funkypenguin.co.nz/), I introduced Kubernetes concepts with an explanation of why I chose Kubernetes for running cloud workloads:

> Why would you want to use Kubernetes for your self-hosted recipes over simple Docker Swarm? Here's my personal take..
> 
> I use Docker swarm both at home (on a single-node swarm), and on a trio of Ubuntu 16.04 VPSs in a shared lab OpenStack environment.
> 
> In both cases above, I'm responsible for maintaining the infrastructure supporting Docker - either the physical host, or the VPS operating systems.
> 
> I started experimenting with Kubernetes as a plan to improve the reliability of my cryptocurrency mining pools (the contended lab VPSs negatively impacted the likelihood of finding a block), and as a long-term replacement for my aging home server.
> 
> What I enjoy about building recipes and self-hosting is not the operating system maintenance, it's the tools and applications that I can quickly launch in my swarms. If I could only play with the applications, and not bother with the maintenance, I totally would.
> 
> Kubernetes (on a cloud provider, mind you!) does this for me. I feed Kubernetes a series of YAML files, and it takes care of all the rest, including version upgrades, node failures/replacements, disk attach/detachments, etc.

Read the whole post (_plus the children’s video!_) at [Funky Penguin's Geek Cookbook - Kubernetes Start](https://geek-cookbook.funkypenguin.co.nz/)
