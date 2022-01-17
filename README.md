## Overview

This is the source code for my [Jekyll](https://jekyllrb.com/)-based blog:
[http://nynim.org/](http://nynim.org).

Use a Docker container to compartmentalize the `jekyll` build environment, all
managed via `docker-compose.yml`.

## Bootstrap Setup

```sh
# Clone jekyll source files
git clone git@github.com:tonyduckles/blog_source.git
cd blog_source

# Clone deployed jekyll _site
git clone git@github.com:tonyduckles/tonyduckles.github.io.git _site

# Initialize jekyll container
./script/bundle
```

## New Posts

1. `./script/octopress new post "Title"` to create a new `_post` page.
2. `./script/octopress new draft "Title"` to create a new `_draft` page.

## Updating Gemfile

1. `./script/bundle` to install gems based on `Gemfile`.
2. `./script/bundle update` to check for any gem updates and update `Gemfile.lock`.

## Testing

1. `./script/jekyll-serve` to run `jekyll serve` and build the site in
   local-serve mode.
2. `./script/htmlproofer` to run
   [html-proofer](https://github.com/gjtorikian/html-proofer) to check for
   broken intra-site links, etc.

## Deploying

1. `./script/jekyll-build` to run `jekyll build` in production mode.
2. Run `git diff` in the `_site` subfolder to inspect the differences since the
   last published commit.
3. `./script/site-commit` to `git commit` the site files in the `_site`
   subdirectory.
4. `./script/site-deploy-push` to `git push` any new revisions to the `deploy` remote.
