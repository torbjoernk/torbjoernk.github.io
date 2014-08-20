--- 
layout: post
title: "KDE Tipps #1: Deutsches KMail aber fremdsprachige E-Mails"
date: 2011-07-05
categories: 
- Linux
published: true
comments: false
---
{% img left http://kde.org/images/icons/kmail_48.png 48 48 "Das KDE-KMail Logo" %}
Wer kennt es nicht: Man arbeitet unter der deutschsprachigen Benutzeroberfläche, unterhält aber des öfteren englischsprachige Korrespondenzen (zum Beispiel in Mailinglisten). Antwortet man nun auf eine E-Mail, so fügt das E-Mail-Programm automatisch die alte E-Mail zitiert ein und stellt ihr so etwas wie „*Am Donnerstag, 21. April 2011, 21:42:12 schrieben Sie:*“ voran. Das sieht nicht gut aus und geht deutlich besser!

<!-- more -->

So lange man nur im deutschsprachigen Umfeld arbeitet ist dies kein Problem, kommen aber hier und da englischsprachige E-Mails hinzu, ist ein solcher deutschsprachiger Text eher unpassend.

Hier beschreibe ich eine mögliche Vorgehensweise, wie man dieses Problem in [KMail](http://userbase.kde.org/KMail), dem E-Mail-Programm von [KDE](http://kde.org/), einfach lösen kann ohne die Sprache der Benutzeroberfläche ändern zu müssen.
Ich habe es hier am Beispiel der deutschen Benutzeroberfläche von KMail2 (Version 2.0.95 unter KDE 4.6.90 (4.7 RC1)) gemacht, es lässt sich aber auf alle anderen beliebigen Oberflächen ebenfalls anwenden.

###Der Standard
Die Standard-Vorlagen sind Bestandteil der Lokalisierung von KMail, weshalb sie bei einer deutschsprachigen Benutzeroberfläche ebenfalls übersetzt sind. Die hier beschriebene Lösung besteht aus einer Rückübersetzung dieser Standard-Vorlagen.

Unter „*Einstellungen*“ -&gt; „*KMail einrichten ...*“ wählt man den „*E-Mail-Editor*“ aus und begibt sich in den Reiter „*Standard-Vorlagen*“. Hier werden die Texte festgelegt, die standardmäßig beim Antworten oder Weiterleiten einer E-Mail automatisch verwendet werden.

Bei deutscher Lokalisierung steht hier für „*Antwort an Absender*":

{% codeblock %}
%CURSOR

%REM="Standardvorlage für Antworten"%-
Am %ODATE, %OTIMELONG schrieben Sie:
%QUOTE
{% endcodeblock %}

Wichtig ist nun, nicht nur den Satz ins Englische zu übersetzen ("*On %ODATE %OTIMELONG you wrote:*"), sondern ebenfalls die Platzhalter <code>%ODATE</code> und <code>%OTIMELONG</code> durch ihre nicht-lokalisierten Gegenstücke zu ersetzen. Andernfalls würde das obige Beispiel als „*On Donnerstag, 21. April 2011 21:42 you wrote:*“ erscheinen.

Die nicht-lokalisierten Platzhalter lassen sich einerseits durch das unten stehende Menü „*Platzhalter einfügen*“ -&gt; „*Ursprüngliche Nachricht*“ wählen (es sind die mit dem Zusatz „*in C-Lokalisierung*“)  oder durch Anhängen von "<code>EN</code>" an die bisherigen.

Schließlich sieht die englischsprachige Standard-Vorlage ohne lokalisierte Platzhalter wie folgt aus:

{% codeblock %}
%CURSOR

%REM="Standardvorlage für Antworten"%-
On %ODATEEN %OTIMELONGEN you wrote:
%QUOTE
{% endcodeblock %}

Mit den anderen Standard-Vorlagen für „*Allen antworten / der Liste antworten*“ und „*Nachricht weiterleiten*“ verfährt man ebenso.

###Die Erweiterung
Um individuell nur bei Antworten auf (oder beim Weiterleiten) bestimmte E-Mails die englischsprachige Vorlage zu verwenden, empfiehlt es sich, „*Eigene Vorlagen*“ einzurichten. Hier lassen sich detaillierte und allgemeine E-Mail-Vorlagen erstellen, die man über den gewählten Name im „*Antworten*“-Menü (lange auf das Werkzeugleisten-Symbol „*Antworten*“ klicken) aufrufen kann.

Ich habe hier eine neue Vorlage „*deutsche Antwort*“ erstellt und in das große Textfeld

{% codeblock %}
%CURSOR

%REM="Vorlage für deutsche Antworten"%-
Am %ODATE um %OTIMELONG schrieben Sie:
%QUOTE
{% endcodeblock %}

eingegeben und unten rechts noch „*Antwort*“ als Vorlagentyp gewählt.

Außerdem habe ich noch eine Vorlage „*deutsche Antwort (allen)*“ mit

{% codeblock %}
%REM="Deutsche Vorlage für Antworten an alle"%-
Am %ODATE um %OTIMELONG schrieb %OFROMNAME:
%QUOTE

%CURSOR
{% endcodeblock %}

und dem Vorlagentyp „Allen Antworten“ erstellt.

Und schließlich noch, um die Standard-Aktionen vollständig zu machen, eine Vorlage für die Weiterleitung (Vorlagentyp „*Weiterleiten*“) an deutsche Empfänger:

{% codeblock %}
%REM="Deutsche Vorlage für Weiterleitungen"%-

----------------  Weitergeleitete Nachricht  ----------------

Betreff: %OFULLSUBJECT
Datum: %ODATE, %OTIMELONG
Von: %OFROMADDR
%OADDRESSEESADDR

%TEXT
------------------------------------------------------------
{% endcodeblock %}

Alle Möglichkeiten dieser Funktion hier zu beschreiben, führt etwas zu weit und gehört in das Handbuch von KMail. Derzeit scheint es noch nicht dort erläutert zu werden.

###Fazit
Das Rückübersetzen der Standard-Vorlagen ist sicherlich die einfachste und benutzerfreundlichste Lösung. Wem es nichts aus macht, dass auch die deutschsprachigen Korrespondenzen englischen Text lesen müssen, sollte bei dieser Lösung bleiben.

Wer jedoch eine exakte und konsistente Lösung bevorzugt, dem sei die Erweiterung empfohlen. Sie erfordert allerdings ein wenig Handarbeit bei jeder Antwort oder Weiterleitung. Auf Dauer kann das durchaus nervend werden.
