---
layout: post
title: Simple Off-Site Backups...?
date: '2007-09-11 20:23:38'
comments: true
categories:
- Storage
---

Lately I've been consumed with the idea of getting more serious about backing-
up all the data I have. I tend to be a digital pack-rat: my music collection,
digital photos I've taken, all the songs I've ever recorded, various tarballs
filled with code-stuffs for college projects I did, etc. There's a wealth of
nostalgia there, and I realized that I really wouldn't want to lose a lot of
that stuff.

<!-- more -->

I already use a quasi-RAID system: I have two identical hdd's in my file-
server box and I rsync the "master" drive to the "slave" drive every so often.
Not only does this provide me some amount of rollback-ness (i.e. because I
only rsync so often), but the decision to not RAID-mirror the drives was
intentional: if the filesystem or partition table on the RAID somehow became
corrupted, all my data could be lost.

But...what if my house burns down? (\*gasp\* Oh noes!!) Yes, that would be sad
indeed! So, rather than just providing a single layer of redundancy locally,
if I really want to invest in the survival of my important data, I really need
to spread that data around; I need to diversify.

I've looked around at various web-based back-up solutions like
[Amazon's S3 service](http://aws.amazon.com/s3), but those don't seem very optimal for me
because of the amount of data I want to backup (~150GB) and because it seems
like it would be a PITA to do a full restore over my home cable internet pipe.
Not to mention the monthly fees, paying someone else to store my data safe and
sound. But, dare I trust my important (and partially sensitive) data to a
stranger?

Currently, I'm tempted by a seemingly simple solution: just get an external
USB hdd, mirror my data once locally, and then throw it at a friend's house
and use rsync to keep it up-to-date. The main cost involved is the cost of the
new hdd; there's no monthly fee because I already need to pay for my internet-
access. And I can even return the favor by hosting drives on my end too. And
this could even be expanded to a multiple people, if you wanted to back-up
your data in multiple off-sites. This seems almost too easy to me, but it
seems perfectly effective. Anything, it's making use of the hidden geek-
factor: you're a geek and you have geek friends, so why not make the most of
it and use them for geeky endeavors like helping each other backup each
other's data? ;)

The main problem I have with this plan is that my data wouldn't be encrypted
at all. I'm not sure how paranoid I really need to be about my friends
snooping around my data. Though, I think this is basically the general idea
as: what would happen if someone stole your computer? So, that's really more
an argument that I should be locally encrypting my data so that even if prying
eyes were to get at my local/master copy, they still wouldn't be able to do
much with it.

Has anyone else given thought to getting more serious about backing up their
data?

