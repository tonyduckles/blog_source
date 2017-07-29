---
layout: post
title: "Project-Level .ackrc Files"
date: 2013-03-09T11:56:26-06:00
comments: true
description: "Create a wrapper script around Ack which searches for local/project-level .ackrc files."
keywords: "ackrc local, ackrc project, ackrc project-level, ackrc directory, ackrc directory-level, ackrc local exclusions, ackrc local ignores"
categories:
- Coding
---

[Ack](http://betterthangrep.com/) is a fantastic (*and portable!*) replacement
for `grep`. It's aimed at programmers and by default will only search a
white-list of known file-extensions so that it will only search the "code" in a
directory.

`ack` looks at your `~/.ackrc` file to get any customized "default" settings
you want. I use my (*user-level*) `~/.ackrc` to [enable some personalized default options](https://github.com/tonyduckles/dotfiles/blob/master/.ackrc),
e.g. color-ize output, always use a `$PAGER`, sort the output by filename, etc.

But sometimes I want to have **directory-level** (or project-level) additional
settings, namely to always exclude/ignore certain directories when searching at
the project-level.

<!-- more -->

For example, here are the exclusions I want for my [Octopress](/blog/2011/12/19/hello-octopress/)
build environment:
```
--ignore-dir=.gist-cache
--ignore-dir=.pygments-cache
--ignore-dir=.sass-cache
--ignore-dir=.themes
--ignore-dir=\_deploy
--ignore-dir=public
```

So, I wrote-up a little `ack` wrapper script: [ack-wrapper](https://github.com/tonyduckles/dotfiles/blob/master/bin/ack-wrapper).
It crawls the directory tree looking for an additional "local" `.ackrc` file,
starting from the current working directory crawling up through any parent
directories until we find a `.ackrc` file (*or until we reach either `$HOME` or
`/`*).

(**Update 2012-03-10:** *It looks like [Ack v2.0](https://github.com/petdance/ack2)
supports PWD .ackrc files natively, and has some other neat enhancements to boot!*)

{% codeblock ack-wrapper lang:sh https://github.com/tonyduckles/dotfiles/blob/master/bin/ack-wrapper %}
#!/bin/sh
# Wrapper around 'ack' to crawl all directories from `pwd` to / (or $HOME)
# looking for a "local" .ackrc file. Useful for setting project-level
# --ignore-dir settings.

# Search for "local" .ackrc file in CWD or any parents
HOME=~
ackrc=""
match=""
dir=$(pwd)
while [ "${dir}" != "/" -a "${match}" = "" ]; do
    if [ -e "${dir}/.ackrc" ]; then
        if [ "${dir}" != "${HOME}" ]; then
            match=1
            echo "(Include: ${dir}/.ackrc)"
            ackrc=$(egrep "^[^#]" "${dir}/.ackrc" | tr '\n' ' ')
        else
            match=0
        fi
    else
        dir=$(dirname "${dir}")
    fi
done

# Add quote-wrapping for any additional args to ensure proper passing to
# real 'ack'.
for arg in "$@"; do
    if [ -z "${ackrc}" ]; then
        ackrc="'${arg}'"
    else
        ackrc="${ackrc} '${arg}'"
    fi
done

# Build command to eval
cmd="command ack ${ackrc}"
if [ ! -t 0 ]; then
    # If stdin is a pipe, use cat to redirect stdin to stdout and pipe
    # that data into ack.
    cmd="cat | ${cmd}"
fi

# Eval the final command
eval "${cmd}"
{% endcodeblock %}

### Usage

- Grab the latest version of the [ack-wrapper](https://github.com/tonyduckles/dotfiles/blob/master/bin/ack-wrapper) script,
  drop it somewhere in your `$PATH` (*I like having a `~/bin/` directory*), and
  make sure it's executable (`chmod 755 path/to/ack-wrapper`).
- Update your `.bashrc` to `alias ack=ack-wrapper`, so that running `ack ...`
  will first call the wrapper script, search for any "local" `.ackrc` files,
  insert any additional options found into the original supplied command-line
  arguments, and finally call the (real) `ack` executable.
