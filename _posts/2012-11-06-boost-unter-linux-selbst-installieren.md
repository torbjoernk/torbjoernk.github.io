---
layout: post
title: "Boost unter Linux selbst installieren"
date: 2012-11-06 10:00
comments: true
categories: 
  - Linux
published: true
---
Dies soll eine kleine Anleitung sein, wie man die aktuellste (und stabile) Boost
Version unabhängig von den Distributionspaketen installiert.
Zum Zeitpunkt dieses Artikels war das Boost 1.52.0.
Installiert auf einem 64bit openSUSE 12.2 (funktioniert ebenso mit 12.1).

<!-- more -->
## Voraussetzungen und Abhängigkeiten
### Compiler
Natürlich ist ein aktueller **C/C++-Compiler** notwendig.
Für diese Anleitung habe ich sowohl den _GNU GCC in Version 4.7.2_ als auch den
LLVM Clang in Version 3.1 genutzt, die ich über die offiziellen openSUSE 
Repositories (genaue gesagt: `gcc47` und `llvm-clang`) installiert habe.

### Unicode-Unterstützung
Um **vollständige Unicode-Unterstützung** zu haben, sind zudem die _International
Components for Unicode_ (kurz: _ICU_) notwendig.
Hier nutze ich _libicu_ in Version 49.1.
Im Falle von openSUSE heißt das Entwicklungs-Paket `libicu-devel` (die 
eigentliche Bibliothek, `libicu49`, wird automatisch ebenfalls installiert).
Nicht notwendig aber durchaus nicht schädlich sind noch die Pakete `icu` sowie
`icu-data`.

### OpenMPI
Einige Boost-Bibliotheken haben die Möglichkeit **OpenMPI** zu nutzen, um eine
bessere Parallelisierung zu ermöglichen.
Dafür sind jedoch die Header-Dateien für _OpenMPI_ nötig, die sich
`openmpi_devel` nennen.
Ich nutze hier Version 1.5.4.

## Boost-Sourcen vorbereiten
### Downloaden
Jetzt fehlen nur noch die Boost-Sourcen.
Diese sind auf _Sourceforge_:
[http://sourceforge.net/projects/boost/files/boost/1.52.0/](http://sourceforge.net/projects/boost/files/boost/1.52.0/).
Ich bevorzuge die Bzip2 komprimierte Variante -- aber das sei jedem selbst
überlassen.

### Entpacken
Ich persönlich habe diese nach `$HOME/src/boost_1_52_0` entpackt, da ich die
Quellen von selbstkompilierten Programmen und Bibliotheken in `$HOME/src`
sammel, um sie dann nach `$HOME` zu installieren.
Wer mag kann es aber auch systemweit nach `/opt` (dann aber wohl als root
installieren) oder sonstwohin entpacken.

## Boost kompilieren
Bevor Boost kompiliert werden kann, muss zunächst das Boost.Build-System 
vorbereitet werden.
Boost kommt mit einem eigenen Build-Programm (früher `bjam`, heute `b2` genannt), 
so dass man kein `./configure && make && make install` machen kann.
_CMake_ ist zwar möglich aber nur experimentell unterstützt.
Ich bevorzuge hier _[Boost.Build](http://www.boost.org/boost-build2/)_.

Von nun gehe ich davon aus, dass alle Befehle in `$HOME/src/boost_1_52_0` (bzw.
entsprechend) ausgeführt werden.

### Konfigurieren ('Bootstrappen')
Der erste Schritt ist die Vorbereitung von _Boost.Build_, das mit den
Boost-Sourcen mitgeliefert wird.
Ein `./boostrap --help` liefert ein paar Hinweise, wie man es installieren kann.
Ich will alle Boost-Bibliotheken, mit vollständiger Unicode-Unterstützung, in
mein Benutzerverzeichnis (also nach `$HOME/lib` und `$HOME/include`) 
installieren:

    ./bootstrap --with-icu --prefix=$HOME

Der Output sollte folgende Zeilen enthalten:

    Building Boost.Build engine with toolset gcc... tools/build/v2/engine/bin/linux86_64/b2
    Unicode/ICU support for Boost.Regex?... /usr
    Generating Boost.Build configuration in project-config.jam...

Vermutlich wird noch ein Hinweis auf ein (nicht) vorhandenes Python auftauchen.
Diesen ignoriere ich jetzt hier.
Wer Boost auch für Python verfügbar haben möchte, sollte sicher stellen, dass
sowohl die von einem selbst bevorzugte Python Version sowie dessen
Installationspfad richtig erkannt wird.

Da _OpenMPI_ genutzt werden soll, das aber scheinbar nicht automatisch erkannt
wird, muss es manuell der Konfiguration hinzugefügt werden.
Dazu muss in der Datei `tools/build/v2/user-config.jam` die Zeile

    using mpi ;

hinzugefügt werden (wo ist egal, am einfachsten ans Ende: `echo "using mpi ;" >>
tools/build/v2/user-config.jam`).  
**WICHTIG**: Unbedingt auf das Leerzeichen vor dem Semikolon achten!

### Kompilieren -- The long run...
Ein `./b2 --help` gibt eine ganze Menge an Optionen aus, wie die Art der
Boost-Installation kontrolliert werden kann.
Die vollständige Liste an Optionen findet sich in der
[Dokumentation von Boost.Build2](http://www.boost.org/boost-build2/doc/html/bbv2/overview/builtins/features.html).

Also setze ich mal die einzelnen Parameter zusammen, denn ich möchte,

  - dass der GCC genutzt wird: `toolset=gcc`
  - dass die Namen der Bibliotheken den verwendeten Compiler, Version und Typ 
    enthalten: `--layout=versioned`
  - dass nur die dynamisch linkbaren Bibliotheken verfügbar werden: `link=shared`
  - dass alle Compiler-Optimierungen genutzt werden sollen: `variant=release`
  - dass ich dennoch Debug-Symbole nutzen kann: `debug-symbols=on`
  - dass sowohl multi- als auch single-Threading möglich ist:
    `threading=multi,single`
  - dass immer gegen dynamische C/C++-Systembibliotheken gelinkt wird:
    `runtime-link=shared`
  - dass evtl. frühere Builds verworfen werden: `-a`
  - dass drei Compiler-Instanzen parallel laufen sollen (ich habe nicht so viel
    Zeit aber leider nur zwei CPU-Cores): `-j3`
  - dass beim ersten Fehler abgebrochen wird, damit ich sicher gehen kann, dass
    alles in Ordnung ist: `-q`
  - dass erst einmal alles kompiliert wird (installieren später): `stage`

Das macht dann also:

    ./b2 link=shared runtime-link=shared threading=multi,single variant=release debug-symbols=on toolset=gcc -a -q -j3 --layout=versioned stage
 
Die Installation nach `$HOME` wird dann mit dem gleichen Befehl angestoßen,
allerdings statt `stage` wählt man `install` als Kommando.
Und man sollte `-a` entfernen.

Um das gleiche mit dem _Clang_ Compiler zu machen, ersetzt man `toolset=gcc` durch
`toolset=clang`.

## Endnotiz
Möchte man nun das frische Boost in einem _CMake_-basierten Projekt verwenden,
sollte man beim Aufruf von _CMake_ noch den Parameter `-DBOOST_ROOT=$HOME`
hinzufügen.
Kompiliert man das _CMake_-Projekt mit _Clang_, so ist auf Grund eines Bugs
(oder fehlendem Feature, wie man's nimmt) im _CMake_-Module `FindBoost` unter
Linux, zusätzlich noch der Paramter `-DBoost_COMPILER="-clang31"` notwendig.

_Happy Boosting!_
