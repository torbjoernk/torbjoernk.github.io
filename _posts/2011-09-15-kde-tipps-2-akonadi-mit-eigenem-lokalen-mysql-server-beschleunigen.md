--- 
layout: post
title: "KDE Tipps #2: Akonadi mit eigenem lokalen MySQL-Server beschleunigen"
date: 2011-09-15
categories: 
- Linux
published: true
comments: false
---
Vor einiger Zeit war ich dazu übergegangen, meinen eigenen, lokalen MySQL-Server sowohl für Akonadi als auch für Amarok zu nutzen. Auf die Vorteile gegenüber des standardmäßigen, internen SQlite-Servers möchte ich hier nicht eingehen. Vielmehr will ich hier ein paar Tipss zur Optimierung des MySQL-Servers geben und wie man damit insbesondere Akonadi extrem beschleunigen kann.
Die Auswirkungen sind gerade bei KMail2 zu spüren, das nun deutlich flüssiger geworden ist.

Kurz gesagt: Die Standardwerte der `my.cnf` sind für Akonadi suboptimal. Doch die folgenden Schritte sollten schnelle und einfache Abhilfe schaffen:

<!--more-->

Eine sehr große Hilfe war mir das [MySQL-Tuning-Script von rackerhacker](https://github.com/rackerhacker/MySQLTuner-perl), das einen laufenden MySQL-Server ein wenig auf den Zahn fühlt und dann einem Vorschläge für Verbesserungen unterbreitet.
Das Script ist in Perl geschrieben, d.h. man braucht den Perl-Interpreter, um es verwenden zu können.

{% codeblock %}
wget http://mysqltuner.pl
perl mysqltuner.pl
{% endcodeblock %}

Man wird aufgefordert den **MySQL**-`root`-Usernamen sowie dessen Passwort anzugeben. I.d.R. ist dies `root` und ein hoffentlich selbst gewähltes Passwort, das nicht zwangsläufig dem des Linux-root-Passworts entsprechen muss.

Das wichtigste steht ganz am Ende der Ausgabe unter **Recommendations** und bevor man sich der allgemeinen Vorschläge annimmt sollte man die vorgeschlagenen Variablen in der `/etc/my.cnf` wirklich ändern.

Ein gelegentliches Optimieren der Tabellen (`OPTIMIZE TABLE` auf alle Tabellen der Datenbank `akonadi` anwenden) kann sicherlich auch nicht schaden. Aber dabei bitte Vorsicht, denn ein laufender Akonadi-Server kann durch das Tabellenoptimieren während seiner Laufzeit durcheinander geraten. Also am besten beim Hochfahren des Rechners die Tabellen durch ein Script optimieren.

Hier nun ein paar wichtige Variablen und deren Werte meiner `my.cnf` auf einem Laptop mit 4GB RAM und einem Duo-Core-Prozessor:

{% codeblock %}
key_buffer_size = 128M
sort_buffer_size = 512K
thread_cache_size = 8
wait_timeout = 1296000
query_cache_size = 8M
query_cache_type = 1
join_buffer_size = 256K
{% endcodeblock %}

Der Wert des `thread_cache_size` ist vermutlich noch nicht 100%-ig stimmig. Bekomme da bei jedem Lauf des Tuningscripts einen anderen Wert vorgeschlagen.
`wait_timeout` hatte ich auf diesen Wert, der 8 Stunden entspricht, erhöht, um damit einen Bug des *Mail Dispatcher Agent* zu umgehen. Dieser schaltete sich nach einiger Zeit, in der ich keine E-Mails versendet hatte, ab und musste in der `akonadiconsole` wieder reaktiviert werden (oder durch ein Ab-/Anmelden).

In meinem Fall wirklich Bemerkenswert war das Aktivieren des *Query Caches*, der standardmäßig deaktiviert ist. Insbesondere das Öffnen und Anzeigen von E-Mails in einem großen lokalen E-Mail-Ordner ist seit dem sehr flüssig.

Abschließend noch eine kleiner Hinweis: Das Tuningscript ist kein Allheilmittel und dessen Vorschläge machen erst bei einer längeren kontinuierlichen Laufzeit und Nutzung des MySQL-Servers wirklich Sinn. Also am besten nach einem langen Arbeitstag ausführen, wenn man insbesondere KMail2 etc. über mehrere Stunden intensiv genutzt hat.
