---
layout: "post"
title: "Beware the hidden newlines in Kubernetes secrets"
date: "2019-01-20 20:27"
excerpt: When creating secrets for Kubernetes, always use ```echo -n``` to create the files you intend to import as secrets using ```kubectl create secret```
tags:
  - kubernetes
---
## TL;DR

When creating secrets for Kubernetes, always use ```echo -n``` to create the files you intend to import as secrets using ```kubectl create secret```.

## The longer story

I've been working on a new series of [Geek's Cookbook](https://geek-cookbook.funkypenguin.co.nz) recipes, utilising my new favorite container orchestrator, [Kubernetes](https://kubernetes.io/).

In building a recipe for a LetsEncrypt-certified MQTT broker, I thought I'd take the opportunity to learn to use [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/), so that I could publish my .yaml configs verbatim, without worrying about exposing my CloudFlare API key.

Secrets allow you to safely store and pass sensitive information to your pods without storing these in your config files. Secrets can be passed to pods either as environment variables or as filesystem created on the filesystem.

Semi-distracted, I read (_skimmed_) though the docs, echo'd my secrets into individual files, and used kubectl to create a secret for me:

```
echo "myapikeyissosecret" > cloudflare-key.secret
kubectl create secret -n mqtt generic mqtt-credentials \
   --from-file=cloudflare-key.secret \
   --from-file=cloudflare-email.secret \
   --from-file=letsencrypt-email.secret
```

And then I found that certbot / cloudflare scripts would fail. I shelled into my pod (```kubectl exec -n mqtt mqtt-8876bcf6d-g99bc  -it -- /bin/ash```), and ran ```env``` to confirm the secrets were there, and yes, there they were!

(_Queue the ominous music - I failed to take cognisance of the blank lines separating some of the environment variables_)

Atfer **much** debugging, I finally found that the secrets had ended up as environment variables within the pod, with an trailling newline. Which was, of course, breaking my carefully scripted curl API calls.

Google found me some [resources discussing the hidden newlines](https://github.com/kubernetes/kubernetes/issues/23404), and looking back on the docs, I see that I **was** instructed to use ```echo -n```, but unaware of the implication of ```-n```, I'd simply used ```echo```.

So, as a note for future dumbasses following in my footsteps - always use ```echo -n``` when creating secrets to import with kubectl!
