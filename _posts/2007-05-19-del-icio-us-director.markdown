---
layout: post
title: del.icio.us director
date: '2007-05-19 23:23:24'
comments: true
categories:
- Web
---

Yes, somewhere along the line...I became a geek. I started using multiple
computers, not just between home/work/school/etc., but even multiple computers
at home. (_Though, I mainly use my MacBook for all my casual web-surfing needs
these days at home..._) I was always annoyed by having different bookmarks on
the different computers I used, which meant frustration when I had to remember
which computer I bookmarked that useful such-and-such on. I wanted a way to
have a centralized webpage for my bookmarks and hence could access from
wherever I was. So, inspired by
[an entry on 24ways.org](http://24ways.org/2005/edit-in-place-with-ajax), I created one. It
was my little pet project, and it was good...

Then I found out that someone else had already done the same thing and they
had done it better. Enter [del.icio.us](http://del.icio.us/tduckles). (_Ooh,
the pretty pretty tag-clouds! Yes, my tag-cloud is quite delicious indeed..._)
Tags are such a simple concept, but oh-so effective. It just makes so much
sense to have a webapp where you save bookmarks and can assign arbitrary tags
to each entry. del.icio.us then makes it very easy to navigate around your
list of links by tags, even providing nifty "easy" URLs like
[http://del.icio.us/tduckles/madison](http://del.icio.us/tduckles/madison),
which shows me everything I've tagged with "madison".

Even better, people out there have written even slicker tools to access and
navigate around your del.icio.us bookmarks.
<!-- more -->
John Vey wrote this amazingly cool
tool called [del.icio.us direc.tor](http://johnvey.com/features/deliciousdirector/).
In it's native form, it's meant to be a bookmarklet which you use at api.del.icio.us after
you've done all your HTTP-Auth stuff, so that the JavaScript code doesn't need
to worry about auth when trying to access your bookmarks.

Not only is this a uber-slick UI for navigating around your tag-tree and for
quickly finding a link based on (real-time!) searching, but the page itself
also goes into the design and architecture of direc.tor. This was a really
fascinating read for me, from a web-dev perspective. What really blew my mind
about this is the whole concept of using AJAX methods to grab the del.icio.us
XML DOM, and then use XSLT and XPath features which are built-in to most
modern browsers to do all the searching in real-time on the client-side. So,
really, the whole bottom pane of direc.tor is the output of an XSTL on the
del.icio.us XML DOM of your bookmarks. I had never realized that you could do
XSLT and XPath operations via Javascript before. This was a watershed moment
for me, because a whole new perspective on web-development opened up for me:
you could use XMLHttpRequest to grab an XML document, and then use Javascript
to do an XSLT to transform that XML data into HTML or whatever presentation-
layer you wanted. In the past, I had always only thought of AJAX calls
returning some chunk of HTML which you could then insert somewhere into the
document DOM.

