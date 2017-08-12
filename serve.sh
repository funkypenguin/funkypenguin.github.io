#!/bin/bash
bundle exec jekyll build --config _config.yml,_config_dev.yml --drafts --future
bundle exec jekyll liveserve --config _config.yml,_config_dev.yml --drafts --incremental  --future
#jekyll serve --config _config.yml,_config_dev.yml --drafts
