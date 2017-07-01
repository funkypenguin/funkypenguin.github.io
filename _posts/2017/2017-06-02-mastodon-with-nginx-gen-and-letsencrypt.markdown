---
layout: "post"
title: "Mastodon with nginx-gen and letsencrypt"
excerpt: Speedbumps setting up a mastodon instance
date: "2017-06-02 20:45"
---
I recently setup a [mastodon instance](https://mastodon.funkypenguin.co.nz), on my docker host, using a combination of [nginx-gen](https://github.com/jwilder/nginx-proxy), nginx, and [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)

nginx-gen allows addition of custom nginx config to each virtual host, based on the name of the virtual host, as defined by the VIRTUAL_HOST variable.

All the instructions I found online for mastodon and nginx included proxypass to /api/v1/streaming, to the streaming container on port 4000, but in the case of nginx-proxy, you get a virtual host per-container.

In order to forward just the /api/v1/streaming URL, I added the following to vhost.d/mastodon.funkypenguin.co.nz:

    location /api/v1/streaming {
      proxy_pass http://172.18.0.6:4000;
    }
