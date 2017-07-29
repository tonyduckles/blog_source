---
layout: post
title: Backup your Google Apps (or Gmail) e-mail over IMAP using imapsync
date: '2010-08-08 00:35:18'
comments: true
description: "Backup your Google Apps or Gmail e-mail over IMAP using imapsync"
keywords: "backup email, backup mail, backup google email, backup google mail, backup google apps email, backup google apps mail, backup email imap, backup mail imap, backup email imapsync, backup mail imapsync"
categories:
- Storage
- E-mail
- UNIX
---

I have confidence in Google's ability to keep their e-mail service up-and-
running and keep proper backups of data, but my e-mail history is _my_ data
and I like to have my own copy of it. Since Google provides access to your
Google Apps (and Gmail) e-mail over IMAP, you can do all kinds of things using
standard tools, e.g. synchronize your Gmail e-mail to a local mailbox using
IMAP.

I run an Ubuntu box at home and it was easy to install the `dovecot-imapd`
package to get an IMAP server installed. Since my box is behind my
router/firewall, I'm wasn't that concerned with tweaking Dovecot's default
configuration, but I'm sure you could fiddle with the config to ensure that
Dovecot only binds to `127.0.0.1`.

From there, it's just a matter of using `imapsync`, just like I ended-up
using previously to
[initially transfer all my e-mail to my Google Apps account](/blog/2010/08/07/moving-e-mail-from-gmail-to-google-apps-over-imap-using-imapsync/).

<!-- more -->

Here's the script:

{% codeblock lang:sh %}
 # Sync e-mail from "username@yourdomain.com" to localhost, using IMAP
 imapsync --host1 imap.gmail.com --user1 username@yourdomain.com
          --passfile1 /path/to/gmail_mirror.passfile1 \
          --host2 localhost --user2 username
          --passfile2 /path/to/gmail_mirror.passfile2 \
          --ssl1 \
          --useheader 'Message-Id' --skipsize --allowsizemismatch \
          --syncinternaldates --noauthmd5 -nofoldersizes\
          --split1 100 --split2 100 \
          --regextrans2 's/\[Gmail\]/username\@somedomain/' \
          --include "All Mail|Sent Mail" --delete2 --expunge2
{% endcodeblock %}

The `--regextrans2` option rewrites IMAP folder-names on-the-fly, so that my
local IMAP folder structure can be different than the structure on Gmail's
server. For example, the top Gmail IMAP folder is `[Gmail]` which wasn't all
that useful for me, so instead I rewrote that top-level folder to be
`username@somedomain` so that the local folder name (e.g. in `~/mail/`) would
match the source e-mail address.

You can also use the `--include` option to decide which IMAP folders to copy.
I opted to just copy "All Mail" and "Sent Mail", which gives me a copy of all
my mail but doesn't preserve any information about the labels I might have had
assigned to those messages in Gmail.

The initial copy will definitely take a few hours (or more), depending on how
much e-mail you have in your Gmail account. But this works great for me and
stores the mail in "mbox" format locally so I can even access the mail locally
via mutt/alpine/etc.

