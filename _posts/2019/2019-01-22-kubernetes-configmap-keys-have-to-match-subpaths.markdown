---
layout: "post"
title: "Kubernetes ConfigMap keys have to match subpaths"
date: "2019-01-21 20:17"
excerpt: Your configmap is showing up, not as file named for your subpath, but as a directory? Here's why...
tags:
  - kubernetes
---
I use [Kubernetes ConfigMaps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) to expose static configuration data (_such as a configuration or password file_), where:

1. I'm OK with the config file being read-only within the container, and..
2. I don't want to bother using a (_minimum 1Gb_) persistent disk for a few scrawny files.

I'd been under the impression that I could create a configmap from any local file (_i.e. batman.txt_), and expose it to my pod with an arbitrary filename (_i.e. /etc/superman.txt_). As it turns out, that's not the case...

I tried my renaming trick in a recent [MQTT broker](https://geek-cookbook.funkypenguin.co.nz/recipes/mqtt/) deployment I've been working on. I created the configmap for a customized version of ```mosquitto.conf``` (_I already had a ConfigMap for a standard version_), as follows:

```
kubectl -n mqtt create configmap mosquitto-batman.conf \
--from-file=mosquitto-batman.conf
```

Then I tried to mount this into my pod as follows:

```
- name: mosquitto-batman-conf
  mountPath: /mosquitto/conf/mosquitto.conf
  subPath: mosquitto.conf
```

(_Why use a subPath? Because there was another ConfigMap also mounted inside the /mosquitto/conf directory_)

The result of the above, inside the container, was a empty **directory** (_not a file_), named /mosquitto/conf/mosqitto.conf/. Not what I wanted!

As I discovered by reading [this issue](https://github.com/kubernetes/kubernetes/issues/62156), if you're going to use a subPath, the value of the subPath **must** match the "_key_" of the ConfigMap. But wait, what's the key? Well, it's the name of the file we imported to create the ConfigMap.


You can identify the key by "_describing_" the ConfigMap:

```
[davidy:~] % kubectl describe configmap mosquitto-batman-conf -n mqtt
Name:         mosquitto-batman-conf
Namespace:    mqtt
Labels:       <none>
Annotations:  <none>

Data
====
mosquitto-batman.conf:
----
# Config file for mosquitto
#
# See mosquitto.conf(5) for more information.
#

# =================================================================
# General configuration
# =================================================================
<blah blah other stuff>
```

In this case, it's "_mosqitto-batman.conf_" - but I was trying to use a subPath of "_mosquitto.conf_"!

So, this ended up as a classic case of trying to be too clever for my own good. I renamed the file to "batman/mosquitto.conf", and recreated the ConfigMap by running:

```
kubectl -n mqtt create configmap mosquitto-batman.conf \
--from-file=batman/mosquitto.conf
```

Now when I _describe_ my ConfigMap, the key is correct:

```
Data
====
mosquitto.conf:
```

And I expose it to the container using:

```
- name: mosquitto-batman-conf
  mountPath: /mosquitto/conf/mosquitto.conf
  subPath: mosquitto.conf
```

Success!
