---
layout: post
title: "All-In-One Home File Server: VMware ESXi, OpenIndiana, and ZFS"
date: 2012-06-04 21:25
comments: true
description: "Using VMware ESXi for a home file-server along with ZFS-powered mass storage."
keywords: "esxi openindiana, esxi openindiana zfs, all in one openindiana zfs, home all in one esxi"
categories:
- Storage
- Hardware
---

Just over a year ago, I built a new home file-server since I was quickly
outgrowing my existing storage capacity. Rather than just dropping more HDD's
into the existing hardware I had running, I succumbed to geek techno-lust and
opted to explore new technologies: **ZFS** and **VMWare ESXi**.

<!-- more -->

## Going Virtualized
Virtualization is huge in the enterprise-space these days. After talking with
some friends from work about what kind of virtualization strategies we're using
for our in-house datacenter, I became enticed by the idea of running a "bare metal"
[hypervisor](http://en.wikipedia.org/wiki/Hypervisor): install virtualization
software as the primary OS on the physical hardware and spinning up VM's for
different logical needs.

Over the years, I've accumulated a fair amount of old computers. Back in the day,
those extra computers gave me an opportunity to try-out new OSes/software: playing
with different Ubuntu configurations, tinkering with different \*BSD flavors, etc.
But once my spare-time dried up, all that old computer hardware just became *clutter*
taking-up space and it seemed like such a pain to fire up an old computer just to
tinker with some new configuration.

So, going virtualized held a lot of (obvious) appeal to me: minimize my physical
hardware (less power consumed, less physical space, etc.) while letting me easily
tinker with new configurations.

## ZFS-Powered
Based on [previous research](/blog/2011/03/05/zfs-the-last-word-in-filesystems/),
I knew that I really wanted to move to some kind of **ZFS-backed** storage solution,
to protect/maintain the integrity of my ever-increasing digital collection.

After following the "zfs-discuss" mailing list for a few months, given my simple
home-needs a simple mirrored configuration (along with proper backups) seemed like
the [best solution](http://constantin.glez.de/blog/2010/01/home-server-raid-greed-and-why-mirroring-still-best).
If I need more space, I can expand horizontally: add another pair of drives (of
whatever size is appropriate) to expand my pool. It was this easy expansion
which pushed me towards a mirrored configuration rather than a RAID-Z style
configuration. The trouble with RAID-Z is that you can't add new devices to a
vdev after you've initially created it; the only way to "grow" a RAID-Z vdev is
by replacing **all** of the individual drives (*one at a time, waiting for each
to resilver*) and setting the "autoexpand" property on the pool so that ZFS
will auto-expand the pool based on the new common maximum size of each of the
individual drives. But, that's a whole lot of moving parts (*pun intended*) and
replacing all the drives in the pool isn't quite my idea of easy expansion.
Mirroring just seems easier, given that I don't need lots of individual drives
for raw performance reasons.

## All-in-One Solution
Somewhere along the line in my research, I stumbled upon [**napp-it**](http://www.napp-it.org/napp-it/all-in-one/index_en.html),
which introduced me to this idea of an "all-in-one" fileserver: using VMWare
ESXi as a bare-metal hypervisor, having a Solaris-based VM running on the ESXi
datastore which will control the mass-storage ZFS pool, and then exporting an
NFS share back out to ESXi so that you can store the bulk of the VMs on
ZFS-backed storage. It's a bit complicated at first glance, but it performs
great (thanks to hardware-passthrough) and lets me easily manage the bulk of my
VMs on ZFS-backed storage.

To make use of ESXi's hardware-passthrough support, you need to run server-grade
hardware. For me, that meant going with an Xeon-based CPU with appropriate motherboard
chipset. But that also gave other server-grade wins like using ECC memory and IPMI
(easy remote-control of the console, which is *awesome*).

## Shopping List
Here is the hardware I ended-up going with:

* [Intel Xeon X3440 Lynfield 2.53GHz](http://www.newegg.com/Product/Product.aspx?Item=N82E16819117225)
* [Supermicro X8SIL-F-O](http://www.newegg.com/Product/Product.aspx?Item=N82E16813182211)
* 2x [Kingston 4GB DDR3 ECC Unbuffered](http://www.newegg.com/Product/Product.aspx?Item=N82E16820139077)
* [Intel SASUC8I (LSI 1068E) SATA/SAS card](http://www.newegg.com/Product/Product.aspx?Item=N82E16816117157)
* [SeaSonic X650 Gold PSU](http://www.newegg.com/Product/Product.aspx?Item=N82E16817151088)
* [Fractal Design Define R3 Mid-Tower Case](http://www.newegg.com/Product/Product.aspx?Item=N82E16811352004)
* 2x [2TB Hitachi Deskstar 5K3000](http://www.newegg.com/Product/Product.aspx?Item=N82E16822145475) (primary pool)
* 2x [2TB Hitachi Deskstar 5K3000](http://www.newegg.com/Product/Product.aspx?Item=N82E16822145475) (backup pool)
* 2x [2TB Hitachi Deskstar 5K3000](http://www.newegg.com/Product/Product.aspx?Item=N82E16822145475) (off-site backup pool)

The Xeon chipset was needed for some of the hardware passthrough features in
ESXi, e.g. passing through the HBA card directly to the Solaris-based VM so
that ZFS can have direct access to the physical drives.

The 650W power-supply ended-up being way more than I needed. The server uses
less than 100W when idle, though that PSU is still quite efficient even with
such low power draw.

## Looking Back
The setup has been awesome so far. Even just getting to play around with
server-grade hardware has been an eye-opening experience. Being able to
remote-control the server, e.g. mounting an ISO remotely over the Java-based
client and installing the OS on the computer all without needing to hook-up a
keyboard or monitor, has been a revelation.  (*Goodbye old CRT monitor that I
used to keep around for my server closet!*)

I love the flexibility of ESXi. I have an Ubuntu VM for development/testing, a
FreeBSD VM for running Mediatomb (PS3 media-server), etc. It even let me play
around with different Solaris flavors while trying to figure out what OS I
wanted to use for the ZFS back-end. It's just so easy to spin-up new VMs to
test an idea or just to play around.

I started out using Solaris 11 Edition (free), which ran fine for the better
part of a year. I tried upgrading to Solaris 11/11 earlier this year only to
find that Solaris 11 apparently doesn't play nicely with ESXi. From there, I
jumped over to using [OpenIndiana](http://openindiana.org/), the open-source
spin-off from the now-defunct OpenSolaris lineage.

ZFS has been a huge win too. Taking nightly snapshots makes it dead-easy to
look back in time to see how day was several months ago. The snapshots also
make it easy to send the incremental differences to a backup pool. The built-in
CIFS server makes it dead-easy to mount the shares on Windows, and the
filesystem snapshots are easily accessible via the "Previous Versions" tab in
Windows Explorer. I also really love the idea of the "pool". I can create
different filesystems to group/organize my data (e.g. photos vs. music vs.
backups), enable compression on a per-filesystem basis, set quotas per
filesystem, etc.

I really love the "all-in-one" idea: ZFS reliability combined with the
flexibility of VMWare ESXi.
