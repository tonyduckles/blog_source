---
layout: post
title: "Home Sweet $HOME"
date: 2011-12-20 19:35
comments: true
description: "Exploring and understanding the dot-files in your $HOME directory, and tracking changes to the dot-files in your $HOME directory via Git."
keywords: "home directory, dotfiles, home directory dotfiles, home directory git, home directory dotfiles git, dotfiles git, home directory bashrc, bashrc, home directory inputrc, inputrc"
categories:
- UNIX
---

{% img right /images/2011/12/img_Terminal.png 180 180 "Terminal" %}
About a year and a half ago, I stumbled upon Ryan Tomayko's "[dotfiles](https://github.com/rtomayko/dotfiles)"
repository on Github. The moment I saw it, I thought it was a *great* idea:
the idea of managing all your `$HOME` directory "dot-files" in a Git repository.
That single idea led me on a personal crusade to better understand all the
different configuration files that live in your UNIX (_Linux, Mac OSX, etc._)
home directory, and the end-result was creating my own "[dotfiles](https://github.com/tonyduckles/dotfiles)"
Git repository for synchronizing/tracking/deploying my dot-files between the
various machines I work upon.

I learned a lot of neat stuff along the way, including some config options
which I never knew were there and some tricks which really optimized my
command-line shell experience.

<!-- more -->

## Using Git
I found it to be a very natural fit to use Git to track the edits to my dot-files.
It makes it dead-easy to see what changes I've made since the last commit and
easy to commit those changes and push them to a central Git repository.

Git also makes it dead-easy to "bootstrap" my dot-files environment into a
brand-new home directory:
{% codeblock Dotfiles bootstrap lang:sh %}
# Clone the repo into ~/dotfiles/
git clone git://github.com/tonyduckles/dotfiles.git dotfiles
# Move all the contents (including .git, but excluding the specal "." and ".." directories)
# into ~, overwriting any pre-existing files
mv dotfiles/.??* .
# Clean-up the now-orphaned ~/dotfiles/ directory
rm -rf dotfiles
{% endcodeblock %}

## ~/bin/
Ryan has a `~/bin/` directory in his dot-files repo with all kinds of nifty
little utilities.

There's a bunch of great Git-related utilities in there, e.g.:

* [git-up](https://github.com/rtomayko/dotfiles/blob/rtomayko/bin/git-up) - Like `git-pull` but show a short and sexy log of changes immediately after merging (git-up) or rebasing (git-reup).
* [git-incoming](https://github.com/rtomayko/dotfiles/blob/rtomayko/bin/git-incoming)/[git-outgoing](https://github.com/rtomayko/dotfiles/blob/rtomayko/bin/git-outgoing) - Shows difference between the current branch vs. the upstream branch.

And there's also some great general-purpose utilities in there, e.g.:

* [ack](http://betterthangrep.com/) - A tool like `grep`, designed for programmers with large trees of heterogeneous source code. Very handy for recursive file-searching.

## ~/.gitconfig
Ryan has lots of nifty tricks in his `.gitconfig` file, tying in short-cuts for
calling the helper utilities in `~/bin/`. Also, you can setup Git to use ANSI
colors for various sub-commands (diff, status), which is *very* handy.

## ~/.inputrc
There's a lot of neat options in the `.inputrc` file, for binding key-sequences
to various command-line options. For example:
{% codeblock .inputrc snippet lang:sh %}
C-n: history-search-forward
C-p: history-search-backward
{% endcodeblock %}
...are the **two single-most time-saving key-bindings** that I stumbled upon. This
lets you type a partial command and then use `Ctrl-n` and `Ctrl-p` to
completion-match the rest of the line based on your command history. Awesome!

I find this incredibly useful to completion-match hostnames for `ssh` commands or other
longer commands which I often type. Completion-matching for-the-win!

## Vim: .vimrc and .vim/
Before setting out on this project, I had used Vi some but hadn't really explored
(or understood) the full-power that was [Vim](http://www.vim.org/). Digging
into the `.vimrc` file, reading-up on all the various config options, and
digging into all the `~/.vim/` plugins which Ryan had was an eye-opening
experience. I came to realize just how much you could extend and customize
Vim to meet your needs. Simple things like getting syntax-highlighting
and color-schemes set by default made for an oh-so-much more pleasant
Vim experience.

This all led me to learning a lot more about Vim and becoming much more proficient
using Vim. It's now my text-based editor of choice. Once you get to know the
key-bindings and the various commands, the command-chaining that you can do
in Vim is incredibly powerful.

## Sharing is Fun!
If you're at all interesting in learning more about customizing your Unix
shell environment, looking at other people's dot-files is a great learning
experience. And publishing your dot-files on Github is a great way to
share your shell-environment with the world so that others can learn
and explore.
