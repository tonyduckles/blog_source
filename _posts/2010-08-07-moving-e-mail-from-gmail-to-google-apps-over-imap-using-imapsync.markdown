---
layout: post
title: Moving E-Mail from Gmail to Google Apps over IMAP using imapsync
date: '2010-08-07 23:31:49'
comments: true
description: "Moving e-mail from Gmail to Google Apps for your domain over IMAP using imapsync"
keywords: "google, google apps, imap, imapsync, email"
categories:
- Storage
- E-mail
- UNIX
---

Two years ago, I transitioned from using regular Gmail (i.e. "...@gmail.com")
to setting up Google Apps for "nynim.org" (i.e. "...@nynim.org"). I had found
the following article back then which gave me helpful hints on how to use
`imapsync` to push data to my new Google Apps e-mail address:

[http://gemal.dk/blog/2008/04/08/completed_the_gmail_migration/](http://gemal.dk/blog/2008/04/08/completed_the_gmail_migration/)

I adapted that script for my own needs, and I was able to successfully copy
all the mail from my regular Gmail account to my new Google Apps account.

<!-- more -->

Here is the final script I ended-up with:

{% codeblock lang:sh %}
#!/bin/sh
# Copy all e-mail from source@gmail.com to target@yourdomain.com (Google Apps)
imapsync \
  --host1 imap.gmail.com --port1 993 --user1 source@gmail.com \
  --passfile1 /path/to/gmail_mirror.passfile1 --ssl1 \
  --host2 imap.gmail.com --port2 993 --user2 target@yourdomain.com \
  --passfile2 /path/to/gmail_mirror.passfile2 --ssl2 \
  --useheader 'Message-Id' --skipsize \
  --syncinternaldates --noauthmd5 -nofoldersizes \
  --split1 100 --split2 100 \
  --maxage 50 \
  --regexmess 's/Delivered-To: source\@gmail.com/Delivered-To: target\@yourdomain.com/g'
{% endcodeblock %}

The `--syncinternaldates`, `--useheader 'Message-Id'`,
and `--skipsize` options are all recommended by the imapsync FAQ
(search for "Gmail"):

[http://www.linux-france.org/prj/imapsync/FAQ](http://www.linux-france.org/prj/imapsync/FAQ)

I opted to use the `--passfile1/passfile2` options rather than passing in a
plain-text password in via a command-line param for two reasons: first because
anyone with access to your system can use `ps` to view active processes and
hence would see your password plain-as-day; second because it just better
abstracts the script-logic from the password-text, and we can control the
file-permissions of those password files.

All your Gmail labels should sync-over _automagically_. Since this is going
Google-to-Google, because Google presents labels as separate IMAP folders in
their Gmail IMAP implementation, the process above should sync and preserve
all your Gmail labels for free.

It's been a two years since I've used this script, but I seem to remember it
working pretty painlessly. I wanted to share it here for anyone else who might
be looking to do this same thing.

