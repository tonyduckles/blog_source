---
layout: post
title: "svn2svn: Replaying SVN History"
date: 2012-02-01 21:00
comments: true
description: "Using a custom script to replay the full logical history of /trunk in a source Subversion repository to /trunk in a brand-new target Subversion repository."
keywords: "svn2svn, subversion replay, svn replay, subversion replay filter, svn replay filter, subversion replicate, svn replicate, subversion replicate filter, svn replicate filter"
categories:
- Coding
---

I've found myself in a (potentially unique) situation where we have a
_gi-normous_ [Subversion](http://subversion.apache.org/) repository at work and
we've been exploring ways on how to trim off some of the fat but still keep all
the logical history so that we could still use things like `svn blame` to
drill-down into code-history. Our central SVN repository is some 4-5 years old
and a whopping 300GB+ on-disk. (Yowza!) What we'd really like to do is dump
just the `/trunk` history out to a new repo and roll forward with that, ditching
any historical baggage from old topic branches (`/branches`). The trouble is,
I haven't been able to find any tools to do this.

So, I ended-up writing my own tool to do this. But, first, some back-story...

<!-- more -->

## Existing Tools ##
In doing some searches for variations around "_svn repo filter_", I found a lot
of people pointing to the "[svndumpfilter](http://svnbook.red-bean.com/en/1.7/svn.ref.svndumpfilter.html)"
utility as the tool-of-choice. Sadly, it doesn't seem to be quite "smart" enough
to do what I'd like it to do. It seems to be aimed at (namely) filtering an
`svnadmin dump` stream, taking only certain paths in the SVN "filesystem". That
works fine if you're trying to take an isolated folder/project from the repository,
but if that folder/project has ever been merged into from any paths _outside_ of
the target filter path, then things fall apart. The "trouble" are the copy-from's...

For example, say that you have a repo with a typical trunk/tags/branches setup.
Say you create a new topic branch (e.g. `svn copy /trunk /branches/my-fix && svn co /branches/my-fix`)
and happily work on your sandboxed branch. Say that you decide to rename some of
the pre-existing files/folders, so you run the appropriate `svn move` commands and
happily commit those changes to your branch. Once everything is working happily,
you go to merge these changes into `/trunk` and that all works great. After the
commit, if you run a `svn log -v -l1 /trunk` to look at the details of the most
recent commit to trunk, you'll see something like this:
    A /trunk/Project/RenamedFolder (from /branches/my-fix/Project/RenamedFolder@12345)
...which only describes the (top-level) folder rename, not any add/modifications/renames/etc
that might have happened _inside_ that folder on the branch. At the full repo-level,
SVN can get away with just doing a "`svn copy`" from the branch to trunk, so that
when you do an "`svn log`" on the new "RenamedFolder" path it will walk from trunk
back into that originating topic branch and follow the rename (copy or move) that
happened within.

The `svnadmin dump` will show the same "copy-from" action as `svn log -v` did,
since the dump stream will need to be able to recreate that same ancestry. When
`svndumpfilter` sees this, it throws up its hands and returns an error because
it doesn't know how to _recreate_ the logical history that happened between
when that branch originally forked from trunk versus the final state of that branch.
That is, assuming the copy-from path even has any ancestry back to trunk...

## If You Want Something Done Right... ##
In my searches, I had found a few folks that had hacked together there own
solutions. None of those quite fit my problem at hand, so naturally I decided
to start working on my own solution.

The closest fit I found was a project named "[svn2svn](http://code.google.com/p/svn2svn/)"
hosted on Google Code. It had copied parts of the "[hgsvn](https://bitbucket.org/andialbrecht/hgsvn/overview)"
project (_sychronizing between Mercurial and Subversion repositories_) and
slapped them together in a way that worked for the original author's needs.
It used "`svn log`" to walk the entire history of a given path in a source
repository and then manually replayed those changes to a working-copy of
some path in a target repository. Revision by revision, it would replay
the delta, recreating the history of just the source path in the target repo.
This was _oh-so-close_ to what I wanted, except that it also didn't correctly
handle the copy-from case. And the repository I really wanted to replay was
_littered_ with copy-from's, since I'm trying to replay just the history from
`/trunk` and we create topic-branches for _everything_.

## Enter svn2svn ##
So, I started with the [svn2svn](http://code.google.com/p/svn2svn/) project,
got familiar with the code, and started hacking to extend the code to solve my
problem at hand.

The net-result is my own (nearly completely rewritten) take on the problem,
a project which I'm also calling **[svn2svn](/code/svn2svn/)**.

I've made several enhancements to the original script:

* **Full ancestry (copy-from) support.** This was the tricky part. It took
  several different iterations/rewrites to get something which worked for all
  the different edge-cases. The general idea here is that we can use `svn log`
  to walk backwards through the ancestry on a copy-from case: if we can trace
  back our ancestry to same source path we're replaying, then we can do an `svn
  copy` from that original parent and then do `svn export` to update the
  contents of all the files to match the final copy-from version. There's also
  some extra recursion that needs to happen here, to handle cases where child
  files got renamed inside of a parent-renamed folder. There are other
  edge-cases like files getting replaced inside a parent-renamed folder.

* **Use revprops for source-tracking and resume support.** Subversion has
  revision properties, key+value pairs that are associated with a particular
  revision/commit. I'm setting some `svn2svn:*` rev-props to track the source
  URL, source repository UUID (i.e. in case source URL now points at a
  physically different repo), and source revision #. This is all needed for
  proper resume support, since for the ancestry support we have to maintain a
  mapping-table of source\_rev -> target\_rev, so that when we find a copy-from
  from some revision # in the source repo, we can map this to the equivalent
  revision # in the target repo so we can do an equivalent `svn copy` command.

* **Better verbosity output, and optional debug output.** As I was playing with
  the rewrite, I quickly found I needed better debug output, to see which shell
  commands were being run and to display just general debug/status messages as
  we do all this new complicate ancestry-walking logic. Bonus: the debugging
  messages have colored output, using [ANSI escape
  codes](http://en.wikipedia.org/wiki/ANSI_escape_code#CSI_codes) which all
  self-respecting terminal emulators should respect.

* **All commits (including initial import) go through the same central
  code-path, which means we could run a (client-side) pre-commit script to
  scrub the contents of the target working-copy before each commit.** This is
  where the power of doing the manual replay of changes really starts to shine.
  We have full control over the pending changes, which means that if your
  original trunk history had some files which you didn't want to transition
  into the new replayed repo then you could easily `svn rm` those files from
  the working-copy before the commit happens. That could be as simple as
  excluding certain fixed paths, but it could be a lot more flexible like
  searching the entire working-copy tree and removing any files which match
  a certain file-name. Heck, you could even modify the working-copy
  file-contents at this point...or add brand-new files if you want. We're
  _replaying_ the SVN history here will full control of the target content,
  so this opens a lot of interesting options.

Check-out the [svn2svn project page](/code/svn2svn/) for more details.

Also, I have the project mirrored on [Github](https://github.com/tonyduckles/svn2svn)
so please feel free to fork the project, send me issues/enhancements, or
send me pull-requests for any tweaks you've made.
