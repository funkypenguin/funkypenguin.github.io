#!/bin/bash

bundle exec jekyll serve -l -w -c _config.yml,_config_dev.yml --drafts --future

# Altetrnative method to use Docker (but it's slow)
#export JEKYLL_VERSION=3.8
#docker run --rm \
#  --volume="$PWD:/srv/jekyll" \
#  -p 35729:35729 \
#  -p 4000:4000 \
#  -it jekyll/jekyll:$JEKYLL_VERSION \
#  jekyll serve -l -w -c _config.yml,_config_dev.yml --drafts --future
