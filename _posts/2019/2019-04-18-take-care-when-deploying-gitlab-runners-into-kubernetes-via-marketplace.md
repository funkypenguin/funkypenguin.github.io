---
layout: post
category: note
date: 18-04-2019 21:59:02
title: "Avoid deploying GitLab Runner application into Kubernetes (use helm instead)"
excerpt: "Unless you’re careful, you could end up running an untrusted docker image in privileged mode on your cluster."
tags:  
  - kubernetes
  - gitlab
---
I’ve recently been reading [Connecting GitLab with a Kubernetes cluster ](https://docs.gitlab.com/ee/user/project/clusters/#security-implications), and I noted the following:

> GitLab Runners have the [privileged mode](https://docs.gitlab.com/runner/executors/docker.html#the-privileged-mode) enabled by default, which allows them to execute special commands and running Docker in Docker. This functionality is needed to run some of the [Auto DevOps](../../../topics/autodevops/index.html) jobs. This implies the containers are running in privileged mode and you should, therefore, be aware of some important details.

> The privileged flag gives all capabilities to the running container, which in turn can do almost everything that the host can do. Be aware of the inherent security risk associated with performing `docker run` operations on arbitrary images as they effectively have root access.

> If you don’t want to use GitLab Runner in privileged mode, first make sure that you don’t have it installed via the applications, and then use the [Runner’s Helm chart](../../../install/kubernetes/gitlab_runner_chart.html) to install it manually.

If I ever end up deploying GitLab to Kubernetes, you can bet I’ll be avoiding privileged mode for my runners, unless I was building the containers myself from scratch!
