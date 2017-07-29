---
layout: post
title: 'ZFS: The Last Word in Filesystems'
date: '2011-03-05 18:56:01'
comments: true
description: "Introduction and overview of ZFS and why it's darn cool"
keywords: "zfs, filesystems, raid, hardware, hard drives, checksums, snapshots"
categories:
- Storage
- UNIX
---

I've been spending a lot of time lately reading-up on different options since
my current home file-server setup is slowly running out of disk-space. Sure, I
could just throw some new HDD's in there, but the inner-geek in me really
wants to setup a new system that has both redundancy and scalability --
something more robust and future-proof.

In reading through different online forums, the topic of ZFS-based systems
kept coming-up again and again. I had heard the term "ZFS" thrown around
before but I had never really spent the time to read-up on it. It's just
another filesystem, right? How fancy can it be?

Well, **ZFS is just damn cool**. ZFS is _lot_ more than "_just another
filesystem_"...

<!-- more -->

* It's a
[filesystem, logical volume manager, and software RAID subsystem](http://blogs.sun.com/bonwick/entry/rampant_layering_violation)
all wrapped-up into one end-to-end system.
* It does [end-to-end checksums](http://blogs.sun.com/bonwick/entry/zfs_end_to_end_data),
making sure the raw data read off the physical disk matches the same data
that was previously written to disk.
* It is a transactional file system, which guarantees a consistent on-disk
data-state even with catastrophic failures like a power loss.
* You can do data scrubbing online, as opposed to the normal Linux solution
of ext2/ext3/ext4 where you can only "fsck" a filesystem offline.
* It uses a copy-on-write strategy which makes doing filesystem snapshot'ing
a breeze. For example, you could setup a cronjob to take nightly snapshots
of your filesystem to facilitate incremental backups, i.e. allowing you to
go back in time and recover old-states of files.
* It has [RAID-Z support](http://blogs.sun.com/bonwick/entry/raid_z), which
is similar to RAID-5/RAID-6 except without the potentially-fatal
"_RAID-5 write hole_" problem, in part thanks to the copy-on-write strategy.
* You can [replicate ZFS filesystems](http://dlc.sun.com/osol/docs/content/ZFSADMIN/gbchx.html)
(`zfs send` and `zfs receive`), snapshots and all, making it dead-easy to
backup ZFS filesystems to remote machines.

Very, very cool stuff! The more I read about it, the more I wanted it for my
next-generation file-server solution. In particular, I really love the idea of
end-to-end checksums. I want to make darn sure that the OS can realize when
the disks are serving up garbage-data or if somehow bits have mysteriously
been corrupted on-disk (as unlikely as that might be).

In reading about all these various historical problems that ZFS sets out to
address, I'm really surprised that more OSes haven't tried to adopt superior
filesystem technology. The classic problem for so many Windows-users seems to
be that their installs get "corrupt", likely usually due to folks forcibly
powering-off their computers before the hard-drives have a chance to flush
their write-buffer to disk. And then folks get to cope with BSOD's or broken
Windows installs. Sad times for everyone. Filesystems seem like such a
foundational part of the OS that you'd expect companies would spend the time
to make them as robust as possible. I read some rumors that Apple was planning
to incorporate ZFS into OSX a few years back, but apparently that fell apart
for some reason. Sad...

Kudos to the Sun folks for designing such a fantastic filesystem and then
open-sourcing it!

