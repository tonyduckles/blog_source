---
layout: post
title: Maintaining Online Identities
date: '2007-09-11 20:47:44'
comments: true
categories:
- Security
---

I stumbled across this neat site called [Clipperz](http://www.clipperz.com/) a
few weeks back. On the surface, it's "_a free and anonymous online password
manager_". This was immediately interesting to me because I'd really like to
find a (secure!) web-based password manager.

<!-- more -->

More and more lately, I've been
trying to find web apps that can replace the desktop applications I use on a
daily basis. It's just so incredibly convenient to have the portability to be
able to do everything you need from inside a web-browser, and more importantly
to have the persistent-state data stored on the server-side rather than on
each individual machine I use throughout the day. I'm already a huge fan of
webapps like [del.icio.us](http://del.icio.us/tduckles) (_for tracking all my
bookmarks_) and [Google Reader](http://www.google.com/reader/) (_for all my
RSS aggregation and reading needs_), and finding a web-based password manager
would be ideal. It really becomes a chore remembering what username or e-mail
address I registered with at various websites: Amazon, eBay, Newegg, Google,
Yahoo, credit cards, travel sites, online bill pay, banks, etc. (Oy!) It's
just a lot of identities to juggle. I've thought about using
[KeePass](http://keepass.info/) or something, but that's a desktop app and I'd
have to keep my database in-sync between work and home.

What really interested me about Clipperz is their claim at being a "zero-
knowledge" web-application: they only store encrypted data on their server-
side, and use Javascript to decrypt the data client-side based on the username
and password which you supply. Your password is never sent to the server at
all; it's merely used to decrypt the data locally. That's a pretty slick idea,
IMO. But, I'm also a little nervous about trusting some third-party website
will all my personal sensitive online account information. So, I'm tempted to
sit down and write my own webapp to recreate that wheel, except that it's all
code I can vouch for and know that it's not secretly sending my data off to
some third-party site. You can already find open-source Javascript-based
implementations of the various crypto algorithms that I'd need to use. And it
seems like a simple AJAX-based webapp to save/load data from the server.

Also really intriguing is Clipperz' one-click-sign-in feature. They have a
Javascript bookmark which pulls HTML FORM information off a given login page
and then allows you to link the various FORM INPUT fields with the appropriate
data-fields on the "card" for that website (e.g. username, password). The one-
click sign-in then just has to do a HTTP POST to the desired web-address with
the correct FORM data to act just like the real login page. It's simple
enough, but that seems like the real time-saver here. Not only could you have
a webapp which stores all your personal data, but it also provides a quick
launchpad to login any site you need. That just takes it a step further and
makes the webapp almost a blackbox: you don't really _need_ to know what your
username and password is anymore because the webapp database knows it and can
feed it to the target website's login form for you.

This just seems like a really awesome idea, and I'm really tempted to just use
Clipperz natively so that I don't have to re-invent the wheel, but I'm still
just nervous about using someone else's website as a database to store all my
personal sensitive data. It's basically just a trust issue, and I don't think
I have any good reason to trust that their Javascript code will never do
anything malicious. I'd much rather control the data myself on my private
webserver. If only Clipperz was a SourceForge project... ;)

