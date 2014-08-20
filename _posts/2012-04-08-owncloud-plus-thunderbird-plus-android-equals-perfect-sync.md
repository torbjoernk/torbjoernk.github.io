---
layout: post
title: "ownCloud + Thunderbird + Android = Perfect Sync"
date: 2012-04-08 19:01
comments: false
categories: 
- Diverses
- Linux
published: true
---
Ich habe es endlich hinbekommen!
Das mit der schmerzfreien Synchronisation meiner Kalender und Adressbücher 
zwischen meinem PC und meinem Android-Phone.
Und das **ohne** einer Datenkrake wie *Google* dazwischen.

Hier will ich nun beschreiben, wie ich das hinbekommen habe.

*Es gibt ein Update (19.04.2012)*

<!-- more -->

##Thunderbird
Dass ich von *KDE PIM* (a la *KMail* und *KOrganizer*) auf *Thunderbird* mit 
*Lightning* umgestiegen bin, will ich hier nur kurz erwähnen und nicht weiter 
kommentieren.
Das soll ein postivier Blogpost werden und kein Rant.

Ich setze hier *Thunderbird 11.0.1* unter einem 64bittigen *openSUSE 11.4* ein.

###Kontakte
Um die Kontakte-Synchronisation mit *ownCloud* hinzubekommen und nicht auf die 
scheinbar kaputten Adressbuch Im- und Exportfunktionen angewiesen zu sein, habe 
ich die folgenden AddOns installiert:

- [SOGo Connector](http://www.sogo.nu/files/downloads/extensions/sogo-connector-10.0.1.xpi)
- [MoreFunctionsForAddressbook](https://nic-nac-project.org/~kaosmos/morecols-en.html)

Den Tipp hierfür bekam ich im [*ownCloud* Forum](http://forum.owncloud.org/viewtopic.php?f=3&t=2040).

###Kalender
Das *Lightning*-Plugin bringt alle Funktionalität mit, die für eine
Synchronisation über *CalDAV* nötig sind.
Es sind keine zusätzlichen Plugins oder besonderen Einstellungen nötig.

##Android
Vorweg: Hier muss man etwas Geld investieren &mdash; doch es lohnt sich.
Im Android-Market sind die folgenden Apps zu beziehen:

- [CalDAV-Sync beta](https://play.google.com/store/apps/details?id=org.dmfs.caldav.lib),
  2,14€
- [CardDAV-Sync beta](https://play.google.com/store/apps/details?id=org.dmfs.carddav.Sync),
  1,53€

Sie sorgen für die Synchronisation mit (der noch aufzusetzenden) 
*ownCloud*-Instanz.
Einmal eingerichtet bleiben sie im Hintergrund und tauchen nur unter „*Konten &
Synchronisation*“ auf.
Dabei erstellen sie für jeden synchronisierten Kalender oder Adressbuch ein
entsprechendes Pondon auf dem Gerät, die sich dann in einer beliebigen 
Kalenderanwendung bzw. Kontaktverwaltung auswählen lassen.

*Kleines Manko*: Man benötigt nur ein *CalDAV*-Konto für alle Kalender, aber pro
Adressbuch ein *CardDAV*-Konto.
Mit viele Adressbüchern ist das etwas nervig einzurichten.

##ownCloud
Ich beziehe mich hier auf die derzeit aktuellste Version 3.0, die ich über Git
bezogen habe.

###Vorbereitung
Ich habe alles (außer dem `.git`-Ordner) in ein gezipptes-Tar-Archiv gepackt
und auf meinen Webspace bei *All-inkl.com* hochgeladen.
Dort ist ganz wichtig, dass man standardmäßig PHP 5.3.10 aktiviert hat.
Bei mir war das leider noch nicht der Fall, doch eine E-Mail an den Support, und
eine Nacht später war ich auf einen neueren Server umgezogen.
Kostenfrei versteht sich.

Dann nohc der Anleitung auf [ownCloud.org](http://owncloud.org/support/setup-and-installation/webspace/)
folgen, d.h. `data`-Ordner anlegen, 0750 geben und dem `config`-Ordner 0777
geben.
Schließlich noch über *WebFTP* den Inhaber des gesamten `ownCloud`-Ordners auf
`www-data` ändern (rekursiv!).

###Installation
Nachdem man nicht vergessen hat, eine *MySQL*-Datenbank für *ownCloud*
einzurichten (und am besten eine Subdomain), kann man nun sein eigenes
*ownCloud* besuchen.
Zunächst einmal einen *Admin*-Konto anlegen und die Zugangsdaten zur
*MySQL*-Datenbank angeben.
Bitte nicht *SQlite* ausgewählt lassen!

Bitte nicht von der PHP-Fehlermeldung erschrecken lassen.
Für irgendetwas will *ownCloud* auf `/dev/urandom` bei der initialen Einrichtung
zugreifen.
Das ist in einem Webspace leider nicht möglich.
Funktioniert auch so alles prima.

Einfach noch einmal die Seite aufrufen (nicht `F5`) und man „ist drin“.
Ich habe erst einmal alle Anwendungen deaktiviert, die ich nicht benötige:
Also alles, was nicht „*Calendar*“ oder „*Contacts*“ heißt.

Dann noch einen Benutzer für den eigentlichen Gebrauch anlegen, den man bitte
nicht der *Admin*-Gruppe zuordnet.

##Synchronisation
Im Prinzip ganz einfach.
Aber erst die entsprechenden Kalender und Adressbücher in der
*ownCloud*-Oberfläche anlegen.

###Kalender
In *Lightning* einen neuen Kalender anlegen, der „*im Netzwerk*“ und vom Typ
„*CalDAV*“ ist.
Als *Adresse* gibt man hier die an, die einem *ownCloud* anzeigt, wenn man dort
auf das *Welt*-Icon klickt.
Das sieht in etwa so aus:

    http://beispiel.de/apps/calendar/caldav.php/calendars/[BENUTZER]/[KALENDER]

In *Lightning* importiert man dann eine Kalenderadatei von der Festplatte (z.B.
*ICal*) in den neu erstellten Kalender.  
Fertig.

Gleiches gibt man auch auf dem Android in *CalDAV-Sync beta* ein.
Mit dem einzigen Unterschied, dass man nur die URL bis zum Kalendernamen
eintragen muss.
Die einzelnen Kalender findet er selber.

###Kontakte
Hier habe ich mich stark an das eingangs genannte Mini-HowTo im *ownCloud*-Forum
gehalten.
Das *MoreFunctions...*-AddOn ermöglicht es einem im Adressbuch unter
*Datei*/*Neu* ein *Remote-Adressbuch* anzulegen.
Die einzugebende Adresse verrät einem *ownCloud*:

    http://beispiel.de/apps/contacts/carddav.php/addressbooks/[BENUTZER]/[ADRESSBUCH]/

Wie eingangs erwähnt, ist es etwas nervig mehrere Adressbücher auf dem Android
mit *CardDAV-Sync beta* einzurichten.
Aber es ist ja eine einmalige Sache.

Leider brachte mir die initiale Synchronisation meiner Kontaktdaten von
*Thunderbird* nach *ownCloud* die Namensfelder etwas durcheinander.
Insbesondere die Titel, Vor- und Nachnamen passten bei all den Einträge nicht,
die einen oder mehrere Titel (wie „*Dr.*“ oder „*Prof.*“) oder der Vor- oder
Nachname aus jeweils mehr als einem Wort bestand.
Hier musste ich in der Weboberfläche von *ownCloud* nachbessern.

**Update 19.04.2012**  
Vor ein paar Tagen habe ich gemerkt, dass ich meine Kontakte auf dem Android
nicht mehr wirklich bearbeiten kann.
Das liegt insbesondere an Android bzw. Google selbst, die die entsprechende API
nicht richtig freigegeben haben.
So können Sync-Tools wie das hier erwähnte *CardDAV-Sync* nicht richtig auf das
interne Format der Kontakte zugreifen.

Vom gleichen Autor, wie *CardDAV-Sync* und *CalDAV-Sync* gibt es den
[Contact Editor Pro](https://play.google.com/store/apps/details?id=org.dmfs.android.contacteditorpp)
(€2,14) und dessen etwas reduzierte kostenlose Gegenstück.
Wählt man beim Kontakteeditieren diesen an statt Androids eigenen aus,
funktioniert alles wieder reibungslos.  
Nettes Randfeature: Dieser Kontakteditor kann deutlich mehr CardDAV-Felder
beschreiben als Androids eigener.  
**Update Ende**

##Fazit
Endlich funktioniert die Synchronisation meiner Kalender und Adressbücher sauber
und schmerzfrei und ohne, dass irgend eine Datenkrake da mithören kann.
Zudem bin ich absolut unabhängig von irgendwelchen Online-Diensten, denn sollte
mein Hoster dicht machen oder ich einen anderen wählen, so brauche ich lediglich
meinen Webspace umziehen lassen (Daten- und Datenbank-Backup) und die Domain
samt Subdomain auf den neuen Ort umleiten.
Weder in Thunderbird noch im Android muss ich dafür irgendetwas umstellen.
