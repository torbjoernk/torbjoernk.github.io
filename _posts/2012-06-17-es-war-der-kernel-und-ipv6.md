---
layout: post
title: "Es war der Kernel und IPv6"
date: 2012-06-17 10:41
comments: false
categories: 
  - Linux
published: true
---
Vor einigen Wochen fing es an, dass ich in unregelmäßigen Abständen aber immer 
häufiger beängstigende und größtenteils unverständliche Warnmeldungen des
Kernels bekam.
Ursache schien von den verschiedensten Programmen herzurühren und ich vermutet
bis zuletzt Hardwareprobleme.
Heute weiß ich, dass es an einem IPv6-Bug in dem von mir verwendeten Kernel
lag.

<!-- more -->
##Die Symptome
Wann genau es anfing kann ich nicht mehr sagen, doch kann ich folgende Symptome 
und Regelmäßigkeiten feststellen:

- Sobald die erste Warnung auftrat folgten weitere in regelmäßigen Abständen von
  maximal drei Minuten.
- Habe ich nicht nach den ersten Warnungen einen kompletten Neustart des Systems
  gemacht, war es recht bald nicht mehr benutzbar und ein Herunterfahren u.U.
  nicht mehr möglich.
- I.d.R. waren die Programme _swapper_, _kworker_, _thunderbird-bin_ und _kwin_
  als Ursache des Problems in der Warnmeldung genannte.
- Daheim traten die Probleme deutlich seltener auf als z.B. in der Universität.

##Die Warnmeldung
Hier einmal eine solche Warnmeldung, wie sie in `/var/log/messages` auftaucht:

{% gist 2944022 %}

##Ursachenforschung
Da diese Warnmeldungen anfangs nur sporadisch und ohne jegliche Regelmäßigkeit
auftraten, vermutete ich einen Defekt des RAMs.
Es würde erkären, dass unterschiedliche Programme betroffen sind, je nachdem
welcher Bereich des RAMs defekt ist.

###Der RAM war es nicht
Nachdem ich jeden der beiden RAM-Riegel einzeln und dann auch beide zusammen mit
wechselnden Slots mittels `memcheck` getestet habe, konnte ich ein Problem des
RAMs ausschließen.
Es ließen sich keine Fehler finden.

###Die Festplatte war es nicht
Eher weit hergeholt war meine Vermutung, dass Lesefehler der Festplatte Ursache
sein könnten.
Ein kurzes Auslesen der S.M.A.R.T.-Werte schockierte mich zunächst, da ich auf
Grund falscher Interpretation der Werte ein sehr baldiges Komplettversagen der
Festplatte diagnostizierte.

{% gist 2944042 %}

Wenn `VALUE` _unter_ die Werte von `THRESH` fällt, wird es sehr kritisch.
Obacht ist geboten, wenn `WORST` _unter_ `THRESH` fällt.

###Der Hinweis
Da sich die Warnmeldungen auch daheim immer mehr häuften, schrieb ich
[eine E-Mail an die Mailingliste meiner Linux-Distribution: openSUSE](http://lists.opensuse.org/opensuse/2012-06/msg00557.html).
Dort schilderte ich mein Problem und die Schritte, die ich bislang angestellt
habe, um das Problem zu beheben.
Die Antwort war sowohl kurz als auch der direkte Hinweis auf die Lösung des
Problems:
Ein Bug im für IPv6 zuständigen Modul der Linux Kernels vor 3.3.1 und 3.2.14.
Eine länglicher Bugreport und zugehörige Diskussion von Archlinux schildert die
Bemühungen zur Lösung des Problems: [Link](https://bugs.archlinux.org/task/26847).
Der Bugreport vom Kernel selbst fällt etwas kürzer aus:
[Link](https://bugzilla.kernel.org/show_bug.cgi?id=42780).

##Die Lösung
Da derzeit für openSUSE 12.1 lediglich der Kernel 3.1.10 angeboten wird, kann
ich noch nicht so einfach von dem Bugfix profitieren.
Derweil habe ich einfach das IPv6-Modul komplett deaktiviert, in dem ich in den
Netzwerkeinstellungen von openSUSE (in _YaST_) IPv6 deaktiviert habe.

