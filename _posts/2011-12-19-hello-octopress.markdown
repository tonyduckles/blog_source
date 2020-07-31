---
layout: post
title: "Hello Octopress!"
date: 2011-12-19 21:53
comments: true
description: "Introduction to Octopress and my migration path from Wordpress to Octopress"
keywords: "octopress, octopress overview, octopress introduction, octopress wordpress, blog, wordpress, sass, jekkyl, ruby"
categories:
- Blog
---

A few days ago I stumbled upon a neat project named **[Octopress](http://octopress.org/)**:
> Octopress is an obsessively designed framework for Jekyll blogging. It’s easy to configure and easy to deploy. Sweet huh?
> -- <cite>[Octopress](https://github.com/imathis/octopress)</cite>

Sweet indeed! The more I read about it, the more intrigued I became. After a
few hours spent exploring the code, importing the posts/pages from my Wordpress
install into Octopress, and tweaking the default theme to my taste, I've taken
the jump and moved my site over to using the Octopress platform.

<!-- more -->

Octopress is a simple blogging platform aimed at hackers. It's built around the
[Jekyll](http://github.com/mojombo/jekyll) engine, which is the blog-aware static
site generator that powers [Github Pages](http://pages.github.com/).  The "database"
for the site is simply a collection of flat text files using
[Markdown](http://daringfireball.net/projects/markdown/) (or Textile) mark-up. You
can setup either "posts" or "pages", all as you'd expect. When you're ready to
deploy, you use `Rakefile` automation to "generate" the static site files.

It also has a great default theme (IMHO) -- very clean and simple -- which was
actually my original attraction. It was only after reading more about the project
that I realized it had huge appeal to my geek-side too.

## Why Octopress?
It was Matt Gemmell's "[Blogging With Octopress](http://mattgemmell.com/2011/09/12/blogging-with-octopress/)"
post which resonated the most with me:
> WordPress is excellent, but it’s over-featured for what I need, and its PHP/MySQL guts are opaque. I don’t really like the idea of all my writing being inside a big database either; it’s a single point of failure, and that makes me uneasy.
> -- <cite>[Matt Gemmell](http://mattgemmell.com/2011/09/12/blogging-with-octopress/)</cite>

For what I do with my website, Wordpress was overkill. It ended-up being
_Yet-Another-Thing-I-Needed-To-Maintain-Security-Patches-On&trade;_.

I was immediately attracted to the simplicity which Octopress provides: editing
pages and posts as plain-text text-files, all static files so no security-patches
or vulnerabilities to worry about, and easily portable and backup-able. It combines
a lot of things which I have grown to love: I can keep all my content in a Git
repository so that I can publish from multiple locations (_if need be_), I can
work on the site entirely in text (`vim` + `screen`), and it's dead easy to
deploy and backup.

## Migrating from Wordpress
It really didn't take that long to migrate everything over to Octopress.

It took a few hours to get a cleaned-up import of my old Wordpress content.
Based on the recommendation of others, I used [exitwp](https://github.com/thomasf/exitwp)
to create Jekyll-style posts based on my Wordpress content. This went fine for
the most part, but there were some parts in the Wordpress export file that I
needed to fiddle to keep the `exitwp` script from crashing. The end result
was that I had a directory full of simple `*.markdown` files which represented
all the content from my Wordpress site. I spent a few hours going through those
files and cleaning up the Markdown syntax until it matched what I wanted. Some
of my original Wordpress posts were a mixture of Wordpress mark-up and raw HTML,
and that threw the `exitwp` parser for a loop in some places. It did a great
job overall though.

From there, I spent some time looking through the guts of the Octopress source
code getting acquainted with things and seeing how I might be able to fiddle
with some of its inner fiddly-bits. It's written with native support for
customization, trying to keep a clear separation between the core "code" of
the site (_which can be overwritten during a future upgrade_) versus any
"customization" files which the user might make changes too. It's a fantastic
paradigm and one that you don't often see too much of in projects.

Last but not least, I spent some time tweaking the theme to my tasting (_...a
bit of pepper here, a bit of salt there..._). As I mentioned above, it natively
carves out files which are earmarked for user-customizations, where you can
tweak the CSS (SASS), colors, page/sidebar dimensions, etc. It's all just
extremely well-thought-out and a joy to use and extend.

## Ending Thoughts
This has been a fun pet project for me.  It's the first time I've used a Ruby environment.
It's also the first time I've played with [SASS](http://sass-lang.com/) (`*.scss`),
and boy is it going to be hard to go back to writing plain-old CSS.
SASS's [color functions](http://sass-lang.com/docs/yardoc/Sass/Script/Functions.html)
are ridiculously slick: being able to do things like `desaturate(lighten($nav-bg, 8), 15)`
in a `*.scss` file is *awesome* and makes tweaking a site's color-scheme
oh-so-much easier.

I'm a bit sad to have lost the lifestream ([wp-lifestream](https://github.com/dcramer/wp-lifestream/))
functionality from my old Wordpress site. But then again I'm already doing
full exports of most of my lifestream'd websites (Google Reader, Delicious),
so it might not be too hard to generate static lifestream pages using a
`cronjob` or something. That's a project for another day...

## Useful Links
* [Blogging With Octopress](http://mattgemmell.com/2011/09/12/blogging-with-octopress/) -
A fantastic and well-thought-out introduction and overview of Octopress.
* [Switching to Octopress](http://zanshin.net/2011/08/11/switching-to-octopress/) -
A great end-to-end summary of the Wordpress-to-Octopress transition process.
* [Octopress Hidden Features](http://www.meatleasing.com/octopress-hidden-features/index.html) -
Pointing out some of subtle features of Octopress.
* [exitwp](https://github.com/thomasf/exitwp) -
Tool for converting Wordpress export XML to the Jekyll blog engine.
* [vim-octopress](http://www.vim.org/scripts/script.php?script_id=3835) -
Vim syntax highlighting mode for Octopress-flavored `*.markdown` files.

