---
layout: post
title: A new computer - Part 1
date: 2015-06-12T07:00:00+02:00
comments: true
published: true
categories:
  - Diverses
  - English
---

I don't deny it, my old tower PC at home has seen better days.
It's a _Core2Duo_ system from 2007 and has served its duties.
Thus, I'm looking for a replacement for this system for at most 800€, which will be able to serve at
least for the next five years.

This is supposed to be a trilogy of articles.
In this first one I'll describe my current about-to-retire system, the requirements for the new
and reasons for choosing the specific new components I'm about to order.  
The second part will cover the building of the new system while the third and last part will give
a resume of the new system including a few benchmarks as far as I'll be able to conduct them.

<!-- more -->

## The Old System

To start off, these are the specs of my current system:

{: .table}
| Component   | Vendor          | Name                                                |
|-------------|-----------------|-----------------------------------------------------|
| Case        |                 |                                                     |
| PSU         |                 |                                                     |
| Motherboard | Gigabyte        | P35-DS3R                                            |
| CPU         | Intel           | Core 2 Duo E6600 @ 2.4GHz                           |
| Memory      | Kingston        | 2x DDR2 1024MB PC2-6400<br />2x DDR2 512MB PC2-6400 |
| GPU         | nVidia          | GeForce 7600 GS (@400MHz, 512MB)                    |
| HDD         | Western Digital |                                                     |
| TV Card     | Haupauge        |                                                     |

Back in 2007, when I bought the system for way too much money, the system was rather silent and I
managed to sleep in the same room.
Today, even though I regularly clean the fans and radiators from all the dust, I'd rather put the
system in a cool basement I never have to enter.  
The overall performance of the system isn't the best - no doubt - though it's sufficient for
occasional surfing, home backing and recording TV shows.  
Currently, it's only running _Windows 7_.


## Requirements for a New System

1. **Quiet**

   I love systems which you don't hear when there are running, though I will not pay a fortune for
   another half a decibel.

2. **Performant for several years**

   The usual tasks as for the old system remain, but two main points will be added:
   _gaming_ and _code development_.  
   I will not be playing the most recent 3D high-resolution games, but those released two years ago
   should be running at highest resolution with decent FPS.  
   The other main task I'll be using this system for is programming mostly Python and C++ codes.
   I might even be able to experiment with OpenCL, finally.
   Thus, compiling for example the _Boost_ libraries should not take half an hour.
3. **Cheap**

   There is an upper bound of 800€ for the whole system - hopefully including shipping.
4. **Power efficient**

   I really don't see any point in wasting power, though here it's the same as with the noise:
   I will not pay a fortune for another percent efficiency.
5. **Expandable**

   I'm planning on extending and upgrading the system over the years, thus there should be sufficient
   head room for all components.

It will be running both Linux and Windows and I want a SSD as the main system drive with an
additional HDD for the gross of data.

From my point of view, this is an optimization problem in finding the best relation between the five
points above with a little more weight on the performance part.
However, I'm not going to derive a mathematical model for this, build a database of the various
components [^1] and compute the best combination.


## Choosing the Components

At this point I have to mention, that I'm looking for general purpose components in a Midi-Tower.

### Case

Let's go from the outer to the inner and start with the casing.

I don't want to spend more than 100€ on the case, which should be a Midi-Tower (i.e, ATX) with
installed noise-insulation offering at least two USB 3.0 on the front panel and space for at least
four internal 3.25" drives.
In additional at least 280mm space for long graphics cards in default configuration [^2] is desirable.
Cable management and black colour would be nice.

A search on [_Geizhals_ revealed 39 different cases][geizhals_cases] from which two stood out after
sorting according to user and magazine reviews:
[_Fractal Design Define R4 Black Pearl_][cases_fractal] and
[_Cooltek Antiphone black_][cases_cooltek] ([comparison][cases_geizhals_compare]).

The _Cooltek Antiphone_ is way smaller and less heavy, uses 120mm fans and has a true aluminium front.
320mm for graphics cards is sufficient for my use cases and 160mm space for the CPU cooler as well.

However, my winner is the _Fractal Design Define R4_ despite its additional 4kg weight as it offers
two additional front USB interfaces (although only 2.0) and uses 140mm fans (which usually are a
little more quiet than 120mm).

[geizhals_cases]: http://geizhals.eu/?cat=gehatx&v=e&hloc=de&sort=artikel&xf=533_ohne+Netzteil%7E534_ATX%7E540_USB+3.0%7E822_schwarz%7E535_schallged%E4mmt%7E536_4%7E551_140mm%7E4211_2%7E550_Midi-Tower%7E552_140mm
[cases_fractal]: http://www.fractal-design.com/home/product/cases/define-series/define-r4-black-pearl
[cases_cooltek]: http://www.cooltek.de/en/midi-tower/antiphon/12/antiphon
[cases_geizhals_compare]: http://geizhals.eu/?cmp=888458&cmp=812617


### CPU

Now, choosing the CPU will affect the selection of mainboards.
Call me bigoted, but I'm not going to look at _AMD_ CPUs as I really want power efficient performance.

The tradeoff between performance and power consumption is probably best in the _Core i5_ family.
Thus, going for the 5th generation (i.e. socket 1150) _Intel Core i5-4000_ series seems a good choice.
But what model?

I'm sure I want a true quad core CPU with at most 65W TDP and boxed, although I'm not going to use
the stock cooler but the longer warranty is desirable.
This leaves us with [four models to choose][geizhals_corei5]:
_i5-4440S_, _i5-4570S_, _i5-4590S_ and _i5-4690S_.

At this point, it's a close call between the newer _i5-4590S_ and the older but minimal more
performant although 25€ more expensive _i5-4690S_ ([comparison][cpus_geizhals_compare]).

0.2 GHz for 25€? It's a tough decision and both ways is fine.
I'm going for the [_i5-4690S_][cpu_i54690s].

[geizhals_corei5]: http://geizhals.eu/?cat=cpu1150&asuch=&bpmax=&v=e&hloc=de&plz=&dist=&sort=artikel&xf=25_4~590_boxed~1133_Core+i5-4000~4_65
[cpus_geizhals_compare]: http://geizhals.eu/?cmp=1101777&cmp=1101798
[cpu_i54690s]: http://ark.intel.com/de/products/80812/


#### Cooling

As mentioned, I'll definitely not use the stock cooler from _Intel_.
There are more efficient and - more important - a lot more quiet solutions out there.

However, 65W TDP are not much and [_Geizhals_ lists 9 matching CPU coolers_][geizhals_cpucool] with
at most 16dB(A) noise.
With some additional reading of reviews, the [_EKL Alpenföhn Silvretta_][cpucool_silvretta] seems a
really low priced but nevertheless absolutely sufficient choice.

I've read a lot about thermal compounds and how to apply these to finally choose the [_Arctic MX-2_][arcticmx2]
due to its easy of application at room temperatures and good heat conductivity.

[geizhals_cpucool]: http://geizhals.eu/?cat=cpucooler&asuch=&bpmax=&v=e&hloc=at&hloc=de&hloc=pl&hloc=uk&hloc=eu&plz=&dist=&mail=&sort=p&xf=817_1150%2F1155%2F1156~733_16
[cpucool_silvretta]: http://www.alpenfoehn.de/index.php/en/cpu-cooler/silvretta
[arcticmx2]: http://www.arctic.ac/de_en/products/cooling/thermal-compound/mx-2.html


### Mainboard

As we know the socket type we need, we can look for a matching mainboard.

My budget limit here is 80€.

The ATX board should have USB 3.0 (otherwise the requirement for the case would be pointless) and
PCIe 3.0 x16 for the graphics card as well as at least one additional PCIe slot for the TV card.
Regarding memory, four slots for DDR3-1600 are the way to go as I'm not going to do any overclocking.
Thus, an _Intel H97_ chipset is sufficient (the other choice would be _Z97_ allowing for overclocking).

[With this selection _Geizhals_ lists 3 boards][geizhals_boards].
I don't see any big differences and will go for the [_MSI H97 PC-Mate_][board_msi].

[geizhals_boards]: http://geizhals.eu/?cat=mbp4_1150&asuch=&bpmax=-80&v=e&hloc=at&hloc=de&hloc=pl&hloc=uk&hloc=eu&plz=&dist=&mail=&sort=artikel&filter=sort&xf=4400_1~3070_2~319_DDR3-1600~317_H97~2961_4~1244_6
[board_msi]: http://www.msi.com/product/mb/H97_PC_Mate.html


### Graphics Card

Honestly, choosing the graphics card was the hardest part and took me the most time.

First, I thought I can set a budget limit of 150€, but after a day or two of searching and comparing
I decreased the limit to 100€.

I'm not favouring any vendor, neither _ATI_ nor _nVidia_.
The card should definitely be a PCIe 3.0 x16 card and capable of running games release about two
years ago with full details in HD with a decent FPS (i.e. at least 30 in average), thus I'm good
advised to require at least 128bit memory bandwidth and GDDR5 memory.  
As I want full flexibility with regards to connecting monitors, at least one of each (HDMI, DVI and
DisplayPort) should be offered.

[With this selection, _Geizhals_ leaves me with 12 cards][geizhals_gpus].
And what do my eyes see there? A passively cooled card? And with good reviews?
[_Sapphire Radeon R7 250E Ultimate_][gpu_sapphire], you're my boy! 55W TDP!
As I've chosen a voluminous casing with good ventilation, cooling should not become a problem.

[geizhals_gpus]: http://geizhals.eu/?cat=gra16_512&bpmax=-100&v=e&hloc=de&filter=aktualisieren&bl1_id=100&sort=artikel&xf=131_GDDR5~139_128~5424_1~5425_1~143_PCIe+3.0+x16~5426_1#xf_top
[gpu_sapphire]: http://www.sapphiretech.com/presentation/product/?cid=1&gid=3&sgid=1226&pid=2130&psn=&lid=1&leg=0


### Memory

Memory has really become cheap. Little more than 6€ per GB for kits with at least 8GB. Wow.

The only requirements I have are defined by the other components I've already chosen.
Thus, it should be DDR3-1600 DIMM modules in kits of two modules with at least 8GB in total.
I'm going for 2-module kits to leave space for additional two modules in the future.

With this, [_Geizhals_ knows of 149 kits][geizhals_ram] and sorting these by price lists a kit by
_Crucial_ with a CL of 9 about same as other modules with a CL of 11 from other vendors.
In addition with numerous overrall positive reviews, I'm going for these:
[_Crucial Ballistix Sports DIMM kit 8GB (2x 4GB)_][ram_crucial].

[geizhals_ram]: http://geizhals.eu/?cat=ramddr3&asuch=&bpmax=&v=e&hloc=de&plz=&dist=&bl1_id=100&sort=p&xf=256_2x~253_8192~5828_DDR3~5015_1600~5831_DIMM~1454_4096
[ram_crucial]: http://www.crucial.com/usa/en/memory-ballistix-sport


### Storage

As mentioned before, I'm going for a SSD system drive and an additional HDD as data drive.

#### SSD

The system drive will only contain the operating systems (Linux and Windows) and few to no
additional software, thus 120GB should be sufficient.
As it's a system drive, reading is the main task and that should be fast. A lower limit of 500MB/s
for the sequential read should do the job.

With the cheapest SSD found for 55€ and an upper bound of 70€ and additional constrains on the power
consumption (<=0.5W idle and <=2.5W load), I can choose between 10 cards
according to [_Geizhals_][geizhals_ssds].

The [_Samsung SSDC850 EVO 120GB_][ssd_samsung] is probably the best bet as well with regards to
random read and write.

[geizhals_ssds]: http://geizhals.eu/?cat=hdssd&bpmax=-70&v=e&hloc=de&bl1_id=100&sort=p&xf=252_120~221_500~2028_180~4830_1~2384_2.5~2385_0.5#xf_top
[ssd_samsung]: http://www.samsung.com/global/business/semiconductor/minisite/SSD/global/html/ssd850evo/overview.html

#### HDD

For the data drive 1TB should be sufficient for the time being.
I have to admit, that I'm a little fan boy of _Western Digital_ hard disc drives and never had any
failures over the last ten years and a dozen different drives.
Here, I'm looking for quiet and power efficiency drives with the usual desktop performance and thus
going for the [_WD Green 1TB_][hdd_wd].

[hdd_wd]: http://www.wdc.com/de/products/products.aspx?id=780


### Power Supply Unit (PSU)

Up to now, the system has no power but a bunch of nice components.
Adding up all the maximum power consumptions of the various components gives us a total of about 200W.
To have a little head for additional drives or an active and more powerful graphics card, a PSU with
400W to 450W should be a good choice.

The casing can hold PSUs with up to 170mm depth at the dedicated bottom position.
With the additional constrain on the efficiency to "_80 PLUS Gold_" and ATX at least 2.31,
[_Geizhals_ leaves us with 9 PSUs][geizhals_psus].

I'm going for the [_be quiet! Straight Power 10 400W_][psu_bequiet] due to their well received
support (5 years!) and reviews.

[geizhals_psus]: http://geizhals.eu/?cat=gehps&v=e&hloc=at&hloc=de&hloc=pl&hloc=uk&hloc=eu&sort=p&xf=360_400~3768_170~1248_450~4174_ATX~1119_4~4175_2.31#xf_top
[psu_bequiet]: http://geizhals.eu/?cat=gehps&v=e&hloc=at&hloc=de&hloc=pl&hloc=uk&hloc=eu&sort=p&xf=360_400~3768_170~1248_450~4174_ATX~1119_4~4175_2.31#xf_top


### TV Card

That was a short shot and I don't know how good this will turn out.
I basically looked for a card with good Linux driver support.
Due to past experiences with the _Haupauge_ card of the old system (with little to bad Linux support),
I'm now going for the [_TeVii S472_][tvcard_tevii].

[tvcard_tevii]: http://www.tevii.com/Products_S472_1.asp


## Summary

All in all, the components of this system currently sum up to about 750€ plus shipping.
I've saved some money which I might spend on a entry-level steering wheel or game controller.


---

[^1]: This would actually be a really interesting project. However, _Geizhals_ lists over 1200 PCIe
      GPUs, over 400 socket 1150 motherboards, over 1700 DDR3 RAM modules, little less than 100
      socket 1150 CPUs and over 1100 ATX PSUs. Already over 10<sup>13</sup> combinations alone for
      _Intel_ socket 1150.
      Well, forget about that idea ...

[^2]: Some cases offer the possibility to remove a secondary HDD frame to allow for longer graphics
      cards.
