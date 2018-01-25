---
layout: post
title: "Migrating From Octopress 2 to Octopress 3"
date: 2017-08-26T18:06:26-05:00
comments: true
description: "Migrating from Octopress 2 to Octopress 3"
keywords: "octopress, octopress upgrade, octopress3, blog, jekkyl"
categories:
- Blog
---

I recently upgraded this blog to [Octopress
3](https://github.com/octopress/octopress), as part of rebuilding (and
[Docker](https://www.docker.com/)-ifying) my blog
[Jekyll](https://jekyllrb.com/) build environment. This post is a guide of my
upgrade experience and to talk about various workarounds I needed to make to
get everything working.

<!-- more -->

## Introduction to Octopress 3

With [Octopress 2](https://github.com/imathis/octopress), the [paradigm I
used]({% post_url 2011-12-19-hello-octopress %}) was to fork the canonical
Octopress Git repository and maintain all my posts and theme files as a branch
forked off of the Octopress "master" branch. I then periodically ran `git merge
octopress/master` to pull upstream core Octopress infrastructure changes into
my custom branch.

As mentioned in the official "[Octopress 3.0 Is
Coming](http://octopress.org/2015/01/15/octopress-3.0-is-coming/)"
announcement, there were various downsides to the Octopress 2 paradigm.  The
main pain-point revolves around how Octopress 2 is basically just the skeleton
of a Jekyll blog that you need to fork and modify &ndash; which means that when
you want to take upstream changes of the Octopress 2 infrastructure, you need
to merge those upstream changes into your local forked branch and work through
any merge-conflicts. Sometimes easy, sometimes time-consuming.

With Octopress 3, all of this has been re-thought so that your site is a Jekyll
site first-and-foremost and all the extra Octopress "goodies" are delivered via
gems which can be used as [Jekyll plugins](http://jekyllrb.com/docs/plugins/).
That creates a nice clean separation between your site content versus the Jekyll
site-building tools. Neat!


### Octopress 3 is Dead, Long Live Octopress 3 ...?

Side note: it's unclear what the future of Octopress 3 is.

Octopress 3 development was active and vibrant circa 2015, but all the activity
in the [Octopress plugin repositories](https://github.com/octopress) seemed to
tail-off towards the beginning of 2016. It's a shame, but I understand how
these things sometimes go &ndash; priorities change, and life comes first.

I opted to embrace Octopress 3 as-is because I was a big Octopress 2 fan and I
really like the Octopress 3 vision.  Also, I wanted the small quality-of-life
features which Octopress added above-and-beyond the default Jekyll scaffolding.

But I did run into some small bumps along the way &ndash; more on that later.


## Setup Docker

I created a `docker-compose.yml` file to compartmentalize Jekyll build
environment:

{% codeblock docker-compose.yml lang:yaml %}
version: '3'
services:
  jekyll:
    image: jekyll/jekyll:latest
    environment:
      BUNDLE_PATH: /srv/bundle
    ports:
      - 4000:4000
    volumes:
      - .:/srv/jekyll
      - data-bundle-cache:/srv/bundle
volumes:
  data-bundle-cache:
{% endcodeblock %}

Some key points:

- Use the standard `jekyll/jekyll:latest` [Docker
  image](https://hub.docker.com/r/jekyll/jekyll/).
- Use a persistent Docker volume as the `$BUNDLE_PATH` to avoid needing to
  re-download and re-install all the `Gemfile` gems for each `docker-compose
  run` container.

Using Docker containers means everything is compartmentalized and that it's
easy to bootstrap my blog build environment onto another machine.  Containers
for the win.


## Setup a New (Octopress 3-Flavored!) Jekyll Site

Create a new directory for your brand-new Jekyll site:
```plain linenos:false
$ mkdir blog
$ cd blog
```

Copy your `docker-compose.yml` file into the new directory.

Use `docker-compose run` to start a shell into a new Docker container:
```plain linenos:false
$ docker-compose run --rm --service-ports jekyll /bin/sh
```

Install the Octopress gem:
```plain linenos:false
# gem install octopress
Fetching: titlecase-0.1.1.gem (100%)
Successfully installed titlecase-0.1.1
...
Parsing documentation for octopress-3.0.11
Installing ri documentation for octopress-3.0.11
Done installing documentation for titlecase, octopress-deploy, octopress-hooks, octopress-escape-code, redcarpet, octopress after 1 seconds
6 gems installed
```

Use the `octopress new` command to create a new Octopress-flavored Jekyll site:
```plain linenos:false
$ octopress new -f .
Running bundle install in /srv/jekyll...
  Bundler: Don't run Bundler as root. Bundler can ask for sudo if it is needed, and
  Bundler: installing your bundle as root will break this application for all non-root
  Bundler: users on this machine.
  Bundler: The dependency tzinfo-data (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x86-mswin32, x64-mingw32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java`.
  Bundler: Fetching gem metadata from https://rubygems.org/...........
  Bundler: Fetching version metadata from https://rubygems.org/..
  Bundler: Fetching dependency metadata from https://rubygems.org/.
  Bundler: Resolving dependencies...
  Bundler: Fetching public_suffix 3.0.0
  Bundler: Installing public_suffix 3.0.0
  Bundler: Using bundler 1.15.3
...
  Bundler: Fetching jekyll 3.5.1
  Bundler: Installing jekyll 3.5.1
  Bundler: Fetching jekyll-feed 0.9.2
  Bundler: Installing jekyll-feed 0.9.2
  Bundler: Fetching minima 2.1.1
  Bundler: Installing minima 2.1.1
  Bundler: Bundle complete! 4 Gemfile dependencies, 22 gems now installed.
  Bundler: Bundled gems are installed into /srv/bundle.
New jekyll site installed in /srv/jekyll.
Added Octopress scaffold:
 + _templates/
 +   draft
 +   page
 +   post
```

(*Tip: You'll need to pass the `-f` flag to `octopress new` because you're
trying to install into a directory which already exists*)

Edit the `Gemfile` (created during `octopress new`) and minimally add the
baseline Jekyll and Octopress gem dependencies:
{% codeblock lang:ruby title:Gemfile %}
source "https://rubygems.org"

gem 'jekyll'

group :jekyll_plugins do
  gem 'octopress'
end
{% endcodeblock %}

At this point, you have a brand-new empty Jekyll site with a few extra
Octopress-flavored bits (like the `_templates` directory), and you can run
[normal Jekyll commands](https://jekyllrb.com/docs/usage/) like 'jekyll serve',
`jekyll build`, etc.


## Managing Jekyll Plugin Gems

Jekyll supports several ways of [managing gem-based
plugins](https://jekyllrb.com/docs/plugins/).

I opted to manage all my gem plugins via a Bundler group in the `Gemfile` file.
This just seemed the most straight-forward approach. It also seemed like a good
idea to track both the `Gemfile` file and counterpart `Gemfile.lock` file via
source-control (e.g. Git), but your mileage may vary.

There are several neat Octopress 3 gem plugins, but I found that several of the
plugins didn't work out-of-the-box with Jekyll 3.x (*because most of the
plugins haven't been maintained in over a year now*). But thanks to the
community-effect of GitHub, several other folks have fixed the Jekyll
incompatibility problems and submitted pull requests. You can install the
patched version of the various Octopress 3 gems by specifying an explicit
`git:` remote URL (and the specific `branch:`) for that particular gem in your
`Gemfile`.

Here is the final `Gemfile` I ended-up with, with various patched Octopress
gems:
{% codeblock lang:ruby title:Gemfile mark:10,12,14-16 %}
source "https://rubygems.org"

gem 'jekyll'

group :jekyll_plugins do
  gem 'jekyll-paginate'
  gem 'jekyll-redirect-from'
  gem 'jekyll-sitemap'
  gem 'octopress'
  gem 'octopress-code-highlighter', git: 'https://github.com/randycoulman/code-highlighter.git', branch: 'handle-multiline-spans'  # Fix for multi-line <span>'s (gh:octopress/code-highlighter #8)
  gem 'octopress-codeblock'
  gem 'octopress-codefence', git: 'https://github.com/mkleucker/codefence.git', branch: 'fix-warning-deprecated'  # Fix Jeykll 3 compatibility (gh:octopress/codefence #17)
  gem 'octopress-image-tag'
  gem 'octopress-ink', git: 'https://github.com/iphoting/ink.git', branch: 'jekyll-3'  # Fix Jekyll 3 compatibility (gh:octopress/ink #65)
  gem 'octopress-linkblog',  git: 'https://github.com/andrewdavidbell/linkblog.git', branch: 'jekyll3'  # Fix Jekyll 3 compatibility (gh:octopress/linkblog #7)
  gem 'octopress-quote-tag', git: 'https://github.com/NickTomlin/quote-tag.git', branch: 'master'  # Fix Jeykll 3 compatibility
  gem 'octopress-solarized'
end
{% endcodeblock %}


## Migrating Content

You'll need to copy over whatever parts you need from your old Octopress 2 site
to your new Octopress 3 site:

- Copy all your posts: `source/_posts` -> `_posts`
- Copy all your other pages
- Copy all your images: `source/images` -> `images`
- Copy any theme files: `source/_includes` -> `_includes`, etc, etc.


## Installing a Theme

The original Octopress 2 theme was baked into the Octopress 2 git branch.

You could probably migrate over the old Octopress 2 theme from your old
Octopress 2 site, but now that we're using plain-vanilla Jekyll 3 that means we
can use *any* of the plethora of Jekyll-based themes.  So I went hunting for a
new theme.

I ended-up choosing the [Pixyll](https://github.com/johnotander/pixyll) theme
because it was clean and modern.

I "installed" the Pixyll theme by:

1. Cloning the Pixyll theme from its GitHub repo to a separate directory.
2. Manually copying over the files I wanted from the Pixyll directory into my
   Octopress 3 site.
3. Tracking the pristine Pixyll theme files in a [baseline
   commit](https://github.com/tonyduckles/blog_source/commit/b1af1060).
4. Personalizing the theme files as I wanted.

I opted to create a "baseline" commit of the Pixyll theme (along with making
note of what Git revision # from the Pixyll repo I was forking at) to (in
theory) make it easier to take and review upstream changes to the Pixyll git
branch: create a local Git branch off that baseline commit, copy in any
upstream changes to the Pixyll theme, and then `git merge` forward onto my
local `master` branch and work through any merge conflicts.

Here are some of the customizations & personalizations I made along the way:

- Updated `_config.yml` to set various `site` flags which the Pixyll theme
  respects.
- Updated `_includes/footer.html` to include my name and copyright.
- Updated `_includes/head.html` to add the `{% raw %}{% css_asset_tag %}{%
  endraw %}` Liquid tag, which was needed to get the `octopress-solarized`
  plugin to take effect (via the `octopress-asset-pipeline` plugin).
- Various tweaks to CSS styling.


## Resources

Here are some helpful posts which laid out the vast majority of the migration
process:

- [http://samwize.com/2015/09/30/migrating-octopress-2-to-octopress-3/](http://samwize.com/2015/09/30/migrating-octopress-2-to-octopress-3/)
- [https://dgmstuart.github.io/blog/2016/01/22/migrating-from-octopress-2-to-3/](https://dgmstuart.github.io/blog/2016/01/22/migrating-from-octopress-2-to-3/)
- [http://www.dracotorre.com/blog/site-updated-octopress-3/](http://www.dracotorre.com/blog/site-updated-octopress-3/)

Happy upgrading!
