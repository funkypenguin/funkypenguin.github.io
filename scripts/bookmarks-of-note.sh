#!/bin/bash
./scripts/webexcursions.rb
/usr/bin/git pull

# Do a build to trigger the crossposting to Medium
bundle exec jekyll build

/usr/bin/git add .jekyll-crosspost_to_medium
/usr/bin/git add _posts

# Only commit and push if we actually have new content
/usr/bin/git status | grep nothing
if [ $? -ne 0 ]
then
	/usr/bin/git commit -m "Updated bookmarks of note (automatically)"
	/usr/bin/git push
fi
