---
layout: post
title: "Using Kerberos (GSSAPI) Auth with OpenSSH in Cygwin on Windows"
date: 2012-08-25 17:19
comments: true
description: "Using Heimdal (implements Kerberos 5) on Cygwin to get Kerberized SSH on Windows"
keywords: "cygwin kerberos, cygwin kerberos ssh, cygwin heimdal ssh"
categories:
- UNIX
---

On my Windows machines at both work and home, I like to run [Cygwin](http://www.cygwin.com/)
to get a UNIX-like environment on Windows: `screen`, `ssh`, `grep`, etc.
I use SSH's [public key authentication](https://hkn.eecs.berkeley.edu/~dhsu/ssh_public_key_howto.html)
pretty extensively to get password-less authentication to make it dead-easy
(and quick!) to SSH around to different machines.

On some of the non-UNIX machines at work, I couldn't get SSH public-key auth
working, but those machines *do* support Kerberos auth (binding to Active
Directory). Based on my Google searches, all I could find were articles talking
about compiling OpenSSH from source to get a working Kerberos-enabled version
of OpenSSH on Cygwin. So, that made it sound like it would be a pain to get
this working.  But, after doing some more playing around, I found this was
actually easy to setup once you understand the various pieces. Since I couldn't
find any helpful information online when I first tried to get this working, I
figured I'd write up what worked for me in case that helps other people.

<!-- more -->

## Installation

#### Step 1 - Install the "openssh" package

Install the `openssh` package. This gets you the OpenSSH client tools, e.g. `ssh`,
`ssh-agent`, etc.

#### Step 2 - Install the "heimdal" package

Install the `heimdal` package, which supplies an implementation of the Kerberos
tools. This gets you things like `kinit`, `klist`, etc.

#### Step 3 - (Optional) Configure your "krb5.conf" file
You may want to configure your `/etc/krb5.conf` file to list a default realm
so that you don't need to specify it when doing the `kinit` later on:

{% codeblock /etc/krb5.conf lang:sh %}
[libdefaults]
  default_realm = REALM_NAME
{% endcodeblock %}

Alternatively, rather than fiddling with `/etc/krb5.conf` on my Cygwin
install, I opted to use the `KRB5_CONFIG` environment variable (see the
`kinit` manpage) to point to a `~/.krb5.conf` file instead to keep my
Kerberos config confined to my `$HOME` directory (since I
[keep my $HOME directory under version control](/blog/2011/12/20/home-sweet-home)).

#### Step 4 - Modify your ".ssh/config" file

Modify your `~/.ssh/config` file to enable GSSAPI authentication:

{% codeblock ~/.ssh/config %}
GSSAPIAuthentication yes
{% endcodeblock %}

## Usage
*  Before you `ssh` to a remote machine where you want to use Kerberized credentials,
   simply run `kinit` to acquire a new Kerberos ticket. (Pro tip: you can run `klist` to
   list all your active Kerberos tickets and their expiration dates.)
*  With the `GSSAPIAuthentication` directive in your `.ssh/config` file, that should
   enable GSSAPI authentication for free. There's also a `-K` param to the `ssh` command
   which talks about enabling GSSAPI auth and forwarding, which I'm not entirely sure
   what that controls, but my guess is that it's for opting into GSSAPI auth mode if
   you **don't** have that directive in your `.ssh/config` file.

I hope this helps someone else who's trying to get Kerberized SSH working on Cygwin.
Happy SSH'ing!
