---
layout: "post"
title: "Continuous Integration for helm charts"
date: "2019-04-19 21:41"
tags:
  - kubernetes
  - helm
  - travis-ci
  - continous-integration
category:
  - note
---
I've recently been working on a [comprehensive helm chart](https://github.com/funkypenguin/docker-mailserver/tree/add-helm-chart/helm-chart/docker-mailserver) for [docker-mailserver](https://github.com/tomav/docker-mailserver).

Since it's a complicated chart with some logic re which features are in/out, I thought it'd be helpful to setup some continuous integration (CI), so that I can have CI test for valid syntax, as well as run unit and regression testing as I make ongoing changes.

I did a bit of searching, and didn't find all that much around an established way to do CI with helm charts. After some effort, I'm quite satisfied with the level of coverage I have, so I wanted to share what works for me.

![no-alignment]({{ 'https://www.dropbox.com/s/j1mj35nn1og54nb/C522136A-12C3-4C4C-A294-71053AC7597B.jpeg?raw=1' | absolute_url }})

{% include toc %}

## What to test

### Helm syntax

To give me confidence that my chart will work when a user deploys it (_and this found me **lots** of bugs!_), I first run it through helm's standard `--lint` command. This confirms that my chart template syntax is good - I haven't left out any template fields, and I don't have any unbalanced if/else statements. It's quick to do, and catches the first basic level of errors:

```bash
# helm lint docker-mailserver
==> Linting docker-mailserver
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, no failures
# add-helm-chart ±
```

### Kubernetes manifest syntax

The helm lint doesn't tell me whether or not **Kubernetes** will accept my generated manifests though. For this, I use [@garethr's kubeval](https://github.com/garethr/kubeval) package. kubevel takes a kubernetes version number (_i.e. 1.13.0_) as an argument, and then validates any manifests passed to it via stdin. (*note: this is also a great way to confirm your chart is compatible with older versions of Kubernetes*)

In theory, evaluating all generated manifests is as easy as running `helm template <my chart> | kubeval -v 1.13.0`.

Unfortunately, kubeval [currently can't process CustomResourceDefinitions](https://github.com/garethr/kubeval/issues/47) (_which I'm using to create certificates with [cert-manager](https://github.com/jetstack/cert-manager)_), so I have to resort to a dirty-but-effective workaround. Any custom resource templates have "-crd" suffixed to their names, and then I exclude them from kubeval processing like this:

```bash
mkdir manifests
helm template helm-chart/docker-mailserver --output-dir manifests
find manifests/ -name '*.yaml' | grep -v crd | xargs kubeval -v $KUBERNETES_VERSION
```

Here's some truncated example output:

```
# find manifests/ -name '*.yaml' | grep -v crd | xargs kubeval -v 1.13.0
<snip>
The document manifests//docker-mailserver/templates/service_rainloop.yaml contains a valid Service
The document manifests//docker-mailserver/templates/service.yaml is empty
The document manifests//docker-mailserver/templates/service.yaml contains a valid Service
The document manifests//docker-mailserver/templates/pvc.yaml is empty
The document manifests//docker-mailserver/templates/pvc.yaml contains a valid PersistentVolumeClaim
The document manifests//docker-mailserver/templates/ingress_rainloop.yaml contains a valid Ingress
The document manifests//docker-mailserver/templates/deployment_rainloop.yaml is empty
The document manifests//docker-mailserver/templates/deployment_rainloop.yaml contains a valid Deployment
The document manifests//docker-mailserver/templates/configmap.yaml is empty
The document manifests//docker-mailserver/templates/configmap.yaml contains a valid ConfigMap
The document manifests//docker-mailserver/templates/secret.yaml is empty
The document manifests//docker-mailserver/templates/secret.yaml contains a valid Secret
The document manifests//docker-mailserver/templates/pvc_rainloop.yaml is empty
The document manifests//docker-mailserver/templates/pvc_rainloop.yaml contains a valid PersistentVolumeClaim
#
```

### Unit tests

While the above 2 tests confirm that syntactically, the generated config is good, they wouldn't catch a logic error, like the mis-typing of a resource name leading to a field in `values.yaml` which doesn't have the desired effect.

The answer here was a helm plugin, [helm-unittest](https://github.com/lrills/helm-unittest), a BDD-styled unit test framework for helm charts.

Once installed, the plugin integrates with the `helm` cli command to execute your defined tests against your charts. For example you might write a test which confirms that changing a value in values.yaml has the intended downstream effect in your Deployment definition.

Here's an example of one of my tests:

```
- it: should configure imaps port 10993 for rainloop if enabled (and haproxy enabled)
  set:
    rainloop.enabled: true
    haproxy.enabled: true      
  asserts:
    - matchRegex:
        path: data.dovecot\.cf
        pattern: rainloop
```

Run the unit tests by installing the plugin, and then running ```helm unittest <my chart>```. Here's some sample output:

```
# helm unittest docker-mailserver

### Chart [ docker-mailserver ] docker-mailserver

 PASS  haproxy	docker-mailserver/tests/haproxy_test.yaml
 PASS  pvc_rainloop	docker-mailserver/tests/pvc_rainloop_test.yaml
 PASS  pvc creation	docker-mailserver/tests/pvc_test.yaml
 PASS  service_rainloop	docker-mailserver/tests/service_rainloop_test.yaml
 PASS  configmap	docker-mailserver/tests/configmap_test.yaml
 PASS  deployment_rainloop	docker-mailserver/tests/deployment_rainloop_test.yaml
 PASS  deployment tests	docker-mailserver/tests/deployment_test.yaml
 PASS  disable_spf_tests	docker-mailserver/tests/spf_test.yaml
 PASS  ingress_rainloop	docker-mailserver/tests/ingress_rainloop_test.yaml
 PASS  oobe	docker-mailserver/tests/oobe_test.yaml
 PASS  secret	docker-mailserver/tests/secret_test.yaml

Charts:      1 passed, 1 total
Test Suites: 11 passed, 11 total
Tests:       34 passed, 34 total
Snapshot:    11 passed, 11 total
Time:        9.801965981s

#
```


In addition to these pre-defined tests, helm-unittest supports creating a "snapshot" of the generated manifest. This snapshot gets stored with your tests, and allows you to compare the generated manifest with a known-good snapshot taken at a point in time. If your config legitimately changes, you update your snapshots by running `helm unittest -u <chart name>`

### Integrating tests with Travis-CI

Once the 3 tests above can be run locally, you can run them all via your automated CI environment. I used [Travis CI](https://travis-ci.org/funkypenguin/docker-mailserver) - here's an example of my [.travis.yml](https://github.com/funkypenguin/docker-mailserver/blob/3e1571c20e1465b7eb99ef64955c798635308143/.travis.yml) file which includes all 3 stages of testing above:

```
language: C
sudo: false
before_install:
  - wget https://kubernetes-helm.storage.googleapis.com/helm-v2.13.1-linux-amd64.tar.gz
  - tar xzvf helm-v2.13.1-linux-amd64.tar.gz
  - mv linux-amd64/helm helm
  - chmod u+x helm
  - wget https://github.com/garethr/kubeval/releases/download/0.7.3/kubeval-linux-amd64.tar.gz
  - tar xzvf kubeval-linux-amd64.tar.gz
  - chmod u+x kubeval
  - mv helm kubeval /home/travis/bin/
  - helm init -c
env:
  - KUBERNETES_VERSION="1.12.0"
jobs:
  include:
    - stage: lint chart syntax
      script:
        - helm lint helm-chart/docker-mailserver
    - stage: kubeval generated manifests
      script:   
        - mkdir manifests
        - helm template helm-chart/docker-mailserver --output-dir manifests
        - find manifests/ -name '*.yaml' | grep -v crd | xargs kubeval -v $KUBERNETES_VERSION
    - stage: execute unit tests
      script:  
        - mkdir -p helm-chart/docker-mailserver/config/opendkim/keys/example.com
        - cp helm-chart/docker-mailserver/demo-mode-dkim-key-for-example.com.key helm-chart/docker-mailserver/config/opendkim/keys/example.com/mail.private
        - echo "sample data for unit test" > helm-chart/docker-mailserver/config/opendkim/ignore.txt
        - travis_retry helm plugin install https://github.com/lrills/helm-unittest
        - helm unittest helm-chart/docker-mailserver
```

As an aside, I discovered the `travis_retry` wrapper during this process. Sometimes [a build fails for network timeout reasons](https://docs.travis-ci.com/user/common-build-problems/#timeouts-installing-dependencies), and `travis_retry` will re-attempt (rather than fail) any commands up to 3 times before failing.

Got any ideas for improvements? Hit me up below, or jump over to the [Discord server](http://chat.funkypenguin.co.nz)!
