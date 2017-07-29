---
layout: post
title: reBlog - Web-Based, Server-Side RSS Aggregator
date: '2006-03-21 22:08:58'
comments: true
categories:
- Web
- Software
---

Like many people these days, I use RSS feeds to keep up on news from various
feeds. But, with some of the higher traffic sites, since the RSS XML file only
keeps the last 40 headlines or so, if I don't update the feed every ~12 hours,
then I'll miss some posts. Since my iBook has been on the fritz lately, I've
just been leaving it on 24-7, so I was able to have it auto-refresh every few
hours.

This weekend, I was suddenly struck with the idea that it would be cool to
have an RSS reader with a web-interface, and the RSS fetcher could run as a
crontab job. This has the benefits of being able to be accessed anywhere, and
to fetch new posts automagically, without needing some desktop computer
somewhere to handle that.

<!-- more -->

At first, I thought it might be a cool home project to write up. Using some
AJAX techniques, I could come up with a pretty slick interface. But, surely
someone else must have had this same idea too, so I did some searching for
existing open-source projects like this. And, sure enough, enter
[reBlog](http://www.reblog.org/).
[This article](http://www.lifehacker.com/software/feature/how-to-set-up-reblog-killer-server-side-feed-reader-160825.php)
gives a good overview of the
feature-set, and also has a Google Video giving a short workflow run-through.

It uses a lot of AJAX tricks, and it even has full keyboard navigation
shortcuts. It uses "," and "." as the default row up/down, but I was able to
fiddle with the source code to map "j" and "k" to these same functions, so I
could use it vi-style. ;) So, it's really easy to scroll through posts, mark
them as read or flag them for follow-up. All the posts you flag (or "Publish"
in reBlog terminology) go to a different bucket, which can be rendered to a
RSS feed itself, I guess so you can point some other RSS reader to the list.

I'm just very impressed with the project. It's really just what I was looking
for. The 2.0 version is still in beta, and I'm hoping by the final version
they offer more flexibility/customizing. So, if you've ever wanted a web-based
RSS reading solution, check out reBlog.

