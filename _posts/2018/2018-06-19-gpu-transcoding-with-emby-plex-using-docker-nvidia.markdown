---
layout: "post"
title: "GPU transcoding with Emby / Plex using docker-nvidia"
date: "2018-06-19 08:27"
tags:
  - docker
category: note
excerpt: How to use nvidia-docker to transcode with Emby / Plex using your GPU
---

Recently I helped a [Patron](https://www.patreon.com/funkypenguin) to setup an instance of my [Emby](https://geek-cookbook.funkypenguin.co.nz/recipies/emby/) docker-swarm recipe, but with the extra bonus of having all transcoding done using his GPU. Note that this would work equally well for [Plex](https://geek-cookbook.funkypenguin.co.nz/recipies/plex/), or any other "Dockerized" application which would, technically, support GPU processing.

{% include toc %}

## What's the big deal about accessing a GPU in a docker container?

Normally, passing a GPU to a container would be a hard ask of Docker - you'd need to:

1. Figure out a way to pass through a GPU device to the container,
2. Have the (_quite large_) GPU drivers installed within the container image and kept up-to-date, and you'd
3. Loose access to the GPU from the host platform as soon as you launched the docker container.

Fortunately, if you have an NVIDIA GPU, this is all taken care of with the [docker-nvidia](https://github.com/NVIDIA/nvidia-docker) package, maintained and supported by NVIDIA themselves.

There's a detailed introduction on the [NVIDIA Developer Blog](https://devblogs.nvidia.com/nvidia-docker-gpu-server-application-deployment-made-easy/), but to summarize, nvidia-docker is a wrapper around docker, which (_when launched with the appropriate ENV variable!_) will pass the necessary devices and driver files from the docker host to the container, meaning that **without any further adjustment**, container images like [emby/emby-server](https://hub.docker.com/r/emby/embyserver/) have full access to your host's GPU(s) for transcoding!

## How do I enable GPU transcoding with Emby / Plex under docker?

If you want to learn - read the [NVIDIA Developer Blog](https://devblogs.nvidia.com/nvidia-docker-gpu-server-application-deployment-made-easy/) entry.

If you just want the answer, follow this process:

1. Install the [latest NVIDIA drivers](http://www.nvidia.com/drivers) for your system
2. Have a [supported version](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#which-docker-packages-are-supported) of Docker
3. Install nvidia-docker2 (below)

### Ubuntu

```bash
# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
```

### RedHat / CentOS

```bash
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo yum remove nvidia-docker

# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | \
  sudo tee /etc/yum.repos.d/nvidia-docker.repo

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo yum install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
```

### Make nvidia-docker the default runtime

You could stop here, and manage your containers using the nvidia-docker runtime. However, I like to edit ```/etc/docker/daemon.json```, and force nvidia-docker to be used by **default**, by adding:

```
"default-runtime": "nvidia",
```

And **then** restarting docker with ```sudo pkill -SIGHUP dockerd```

## Launching a container with docker-nvidia GPU support

Even with the default nvidia runtime, the magic GPU support doesn't happen **unless** you launch a container with the ```NVIDIA_VISIBLE_DEVICES=all``` environment variable set. (_Thanks to @flx42 for [clarifying this](https://github.com/NVIDIA/nvidia-docker/issues/766) for me_)

The advantage to adding the ```default-runtime``` argument above, is that you can now deploy your [Emby](https://geek-cookbook.funkypenguin.co.nz/recipies/emby/)/[Plex](https://geek-cookbook.funkypenguin.co.nz/recipies/plex/)/Whatever app under swarm exactly as usual, but gain all the benefits of having your GPU available to your app!

## Monitoring docker-nvidia GPU usage (with Munin)

Since nvidia-docker now exposes the GPU to the container while still keeping it available to the host OS, you can run ```nvidia-smi``` on the host to monitor how the GPU is performing.

I've been working on a recipe for a [Munin]([Emby](https://geek-cookbook.funkypenguin.co.nz/recipies/munin/)) server, so I added the [nvidia_ wildcard plugin](https://github.com/munin-monitoring/contrib/blob/master/plugins/gpu/nvidia_gpu_) to monitor nvida GPU stats. Being a "wildcard", it's necessary to copy the plugin to ```/usr/share/munin/plugins```, and then symlink it mulitple times to ```/etc/munin/plugins/``` as below:

```bash
ln -s /usr/share/munin/plugins/nvidia_gpu_ /etc/munin/plugins/nvidia_gpu_temp
ln -s /usr/share/munin/plugins/nvidia_gpu_ /etc/munin/plugins/nvidia_gpu_mem
ln -s /usr/share/munin/plugins/nvidia_gpu_ /etc/munin/plugins/nvidia_gpu_fan
ln -s /usr/share/munin/plugins/nvidia_gpu_ /etc/munin/plugins/nvidia_gpu_power
ln -s /usr/share/munin/plugins/nvidia_gpu_ /etc/munin/plugins/nvidia_gpu_utilization
```
