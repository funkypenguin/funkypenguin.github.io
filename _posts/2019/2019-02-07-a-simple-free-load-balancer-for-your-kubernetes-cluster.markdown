---
layout: "post"
title: "A simple, free, load balancer for your Kubernetes Cluster"
date: "2019-02-06 20:47"
excerpt: "Work around expensive cloud provider load balancer options with a simple, haproxy/webhook-based solution"
tags:
  - kubernetes
category:
  - project
---
This is an excerpt from a recent addition to the [Geek's Cookbook](https://geek-cookbook.funkypenguin.co.nz), a design for the use of an [external load balancer](https://geek-cookbook.funkypenguin.co.nz/kubernetes/loadbalancer/) to provide ingress access to containers running in a Kubernetes cluster.

For implementation details, see [this loadbalancer recipe](https://geek-cookbook.funkypenguin.co.nz/kubernetes/loadbalancer/).

---

Because we're Cloud-Native now, it's complex to get traffic **into** our cluster from outside. We basically have 3 options:

1. **HostIP**: Map a port on the host to a service. This is analogous to Docker's port exposure, but lacking in that it restricts us to one host port per-container, and it's not possible to anticipate _which_ of your Kubernetes hosts is running a given container. Kubernetes does not have Docker Swarm's "routing mesh", allowing for simple load-balancing of incoming connections.

2. **LoadBalancer**: Purchase a "loadbalancer" per-service from your cloud provider. While this is the simplest way to assure a fixed IP and port combination will always exist for your service, it has 2 significant limitations:
    1. Cost is prohibitive, at roughly $US10/month per port
    2. You won't get the _same_ fixed IP for multiple ports. So if you wanted to expose 443 and 25 (_webmail and smtp server, for example_), you'd find yourself assigned a port each on two **unique** IPs, a challenge for a single DNS-based service, like "_mail.batman.com_"

3. **NodePort**: Expose our service as a port (_between 30000-32767_) on the host which happens to be running the service. This is challenging because you might want to expose port 443, but that's not possible with NodePort.

To further complicate options #1 and #3 above, our cloud provider may, without notice, change the IP of the host running your containers (_O hai, Google!_).

Our solution to these challenges is to employ a simple-but-effective solution which places an HAProxy instance in front of the services exposed by NodePort. For example, this allows us to expose a container on 443 as NodePort 30443, and to cause HAProxy to listen on port 443, and forward all requests to our Node's IP on port 30443, after which it'll be forwarded onto our container on the original port 443.

We use a phone-home container, which calls a simple webhook on our haproxy VM, advising HAProxy to update its backend for the calling IP. This means that when our provider changes the host's IP, we automatically update HAProxy and keep-on-truckin'!

Here's a high-level diagram:

![Kubernetes Design](https://geek-cookbook.funkypenguin.co.nz/images/kubernetes-cluster-design.png)

## Overview

So what's happening in the diagram above? I'm glad you asked - let's go through it!

### Setting the scene

In the diagram, we have a Kubernetes cluster comprised of 3 nodes. You'll notice that there's no visible master node. This is because most cloud providers will give you "_free_" master node, but you don't get to access it. The master node is just a part of the Kubernetes "_as-a-service_" which you're purchasing.

Our nodes are partitioned into several namespaces, which logically separate our individual recipes. (_I.e., allowing both a "gitlab" and a "nextcloud" namespace to include a service named "db", which would be challenging without namespaces_)

Outside of our cluster (_could be anywhere on the internet_) is a single VM servicing as a load-balancer, running HAProxy and a webhook service. This load-balancer is described in detail, [in its own section](/kubernetes/loadbalancer/), but what's important up-front is that this VM is the **only element of the design for which we need to provide a fixed IP address**.

### 1 : The mosquitto pod

In the "mqtt" namespace, we have a single pod, running 2 containers - the mqtt broker, and a "phone-home" container.

Why 2 containers in one pod, instead of 2 independent pods? Because all the containers in a pod are **always** run on the same physical host. We're using the phone-home container as a simple way to call a webhook on the not-in-the-cluster VM.

The phone-home container calls the webhook, and tells HAProxy to listen on port 8443, and to forward any incoming requests to port 30843 (_within the NodePort range_) on the IP of the host running the container (_and because of the pod, tho phone-home container is guaranteed to be on the same host as the MQTT container_).

### 2 : The Traefik Ingress

In the "default" namespace, we have a Traefik "Ingress Controller". An Ingress controller is a way to use a single port (_say, 443_) plus some intelligence (_say, a defined mapping of URLs to services_) to route incoming requests to the appropriate containers (_via services_). Basically, the Trafeik ingress does what [Traefik does for us under Docker Swarm](/docker-ha-swarm/traefik/).

What's happening in the diagram is that a phone-home pod is tied to the traefik pod using affinity, so that both containers will be executed on the same host. Again, the phone-home container calls a webhook on the HAProxy VM, auto-configuring HAproxy to send any HTTPs traffic to its calling address and customer NodePort port number.

When an inbound HTTPS request is received by Traefik, based on some internal Kubernetes elements (ingresses), Traefik provides SSL termination, and routes the request to the appropriate service (_In this case, either the GitLab UI or teh UniFi UI_)

### 3 : The UniFi pod

What's happening in the UniFi pod is a combination of #1 and #2 above. UniFi controller provides a webUI (_typically 8443, but we serve it via Traefik on 443_), plus some extra ports for device adoption, which are using a proprietary protocol, and can't be proxied with Traefik.

To make both the webUI and the adoption ports work, we use a combination of an ingress for the webUI (_see #2 above_), and a phone-home container to tell HAProxy to forward port 8080 (_the adoption port_) directly to the host, using a NodePort-exposed service.

This allows us to retain the use of a single IP for all controller functions, as accessed outside of the cluster.

### 4 : The webhook

Each phone-home container is calling a webhook on the HAProxy VM, secured with a secret shared token. The phone-home container passes the desired frontend port (i.e., 443), the corresponding NodeIP port (i.e., 30443), and the node's current public IP address.

The webhook uses the provided details to update HAProxy for the combination of values, validate the config, and then restart HAProxy.

### 5 : The user

Finally, the DNS for all externally-accessible services is pointed to the IP of the HAProxy VM. On receiving an inbound request (_be it port 443, 8080, or anything else configured_), HAProxy will forward the request to the IP and NodePort port learned from the phone-home container.
