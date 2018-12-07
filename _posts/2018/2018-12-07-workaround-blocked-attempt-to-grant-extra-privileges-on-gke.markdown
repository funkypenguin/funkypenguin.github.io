---
layout: "post"
title: "Workaround blocked attempt to grant extra privileges on GKE due to RBAC"
date: "2018-12-07 20:32"
tags:
  - kubernetes
  - gke
---
While attempting to deploy an [awesome set-it-and-forget-it volume snapshot solution](https://github.com/miracle2k/k8s-snapshots) for my GKE [cryptocurrency](https://mtip.heigh-ho.funkypenguin.co.nz/) [mining](https://trtl.heigh-ho.funkypenguin.co.nz/) [pool](https://msr.heigh-ho.funkypenguin.co.nz/) [empire](https://xmr.heigh-ho.funkypenguin.co.nz/), I stumbled across the following error when trying to create the necessary RBAC ClusterRoleBinding:

```
$ kubectl apply -f rbac.yaml
serviceaccount "k8s-snapshots" unchanged
clusterrolebinding.rbac.authorization.k8s.io "k8s-snapshots" configured
Error from server (Forbidden): error when creating "rbac.yaml": clusterroles.rbac.authorization.k8s.io "k8s-snapshots" is forbidden: attempt to grant extra privileges: <blah blah blah>
```

Being largely unfamiliar with RBAC, I spent some time [reading the docs](https://kubernetes.io/docs/reference/access-authn-authz/rbac/), only to come to the conclusion that the [supplied rbac.yml ](https://github.com/miracle2k/k8s-snapshots/blob/master/rbac.yaml)file was, in fact, correct.

So why was kubectl erroring on the creation of the ClusterRoleBinding?

I found the answer [here](https://github.com/coreos/prometheus-operator/issues/357):

> According to Google Container Engine docs:
>
> Because of the way Container Engine checks permissions when you create a Role or ClusterRole, you must first create a RoleBinding that grants you all of the permissions included in the role you want to create.
>
> An example workaround is to create a RoleBinding that gives your Google identity a cluster-admin role before attempting to create additional Role or ClusterRole permissions.
>
> This is a known issue in the Beta release of Role-Based Access Control in Kubernetes and Container Engine version 1.6.
>
> So in order to proceed without error, cluster-admin role should be added to current executing user, eg:
>
> ````
> kubectl create clusterrolebinding your-user-cluster-admin-binding --clusterrole=cluster-admin --user=your.google.cloud.email@example.org
> ````

So after I gave my own user the cluster-admin clusterrole...

```
$ kubectl create clusterrolebinding your-user-cluster-admin-binding --clusterrole=cluster-admin --user=davidy@funkypenguin.co.nz
clusterrolebinding.rbac.authorization.k8s.io "your-user-cluster-admin-binding" created
```

.. I was then able to successfully create the clusterrolebinding to give the k8s-snapshots service account the necessary ClusterRoles to perform its automated snapshots:

```
$ kubectl apply -f rbac.yaml
serviceaccount "k8s-snapshots" unchanged
clusterrole.rbac.authorization.k8s.io "k8s-snapshots" created
clusterrolebinding.rbac.authorization.k8s.io "k8s-snapshots" configured
```
