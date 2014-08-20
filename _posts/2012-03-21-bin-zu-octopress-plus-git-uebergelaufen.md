---
layout: post
title: "Bin zu Octopress + Git übergelaufen"
date: 2012-03-21 19:29
categories: 
- Diverses
published: true
comments: false
---
Auch wenn noch nicht einmal ein Jahr vergangen ist, seit ich von 
[Joomla auf Wordpress umgestiegen bin]({{ root_url}}/article/2011/04/18/erstrahlen-im-neuen-glanze/), 
habe ich die Software --- oder besser Framework --- meines Blogs erneut gewechselt.

<!-- more -->

Das neue System nennt sich [Octopress](http://octopress.org) und ist absolut unabhängig von PHP und 
MySQL.
Es basiert auf [Jekyll](http://github.com/mojombo/jekyll), einem Generator statischer HTML-Seiten, 
der in Ruby geschrieben ist.
Das ganze ist zudem 100%ig HTML5 mit ein bisschen JavaScript.

Da der gesamte Prozess des Installierens und Einrichtens darin besteht, ein GitHub-Repository zu 
clonen ...
{% codeblock %}
git clone git://github.com/imathis/octopress.git octopress
{% endcodeblock %}
ein paar Ruby Gems zu installieren ...
{% codeblock %}
gem install bundler
bundle install
{% endcodeblock %}
das grundlegene Layout zu generieren ...
{% codeblock %}
rake install
{% endcodeblock %}
ein paar Variablen zu konfigurieren ...
{% codeblock Ausschnitt meiner Konfigurationsdatei - _config.yml lang:yaml %}
url: http://torbjoern-klatt.de
title: Torbjörn Klatt
subtitle: It's just me.
author: Torbjörn Klatt
simple_search: http://google.com/search
description: A blog about my life and things encountered.
{% endcodeblock %}
und schließlich das ganze in ein eigenes Git-Repository zu committen ...
{% codeblock %}
git add .
git commit -m "mein Blog ist eingerichtet"
git push
{% endcodeblock %}
hat man die Backup-Lösung frei Haus.

Auf Octopress gestoßen bin ich durch den [Binärgewitter Podcast](), die ebenfalls seit diesem Jahr
Octopress einsetzen.
Im Gegensetz zu anderen, die Octopress verwenden, nutze ich nicht 
[GitHub Pages](http://pages.github.com/) für die Generierung und Bereitstellung der fertigen 
Webseite, sondern hoste das nach wie vor auf meinem eigenen Webspace.

Dazu binde ich mittels [`curlftpfs`](http://curlftpfs.sourceforge.net/) meinen Webspace in mein 
lokales Dateisystem ein und nutze einen eigenen Rake-Task `copyto`, den ich als Standard für den
`deploy`-Task definiert habe ...
{% codeblock %}
rake deploy # generiert die Seite und schiebt sie auf den Webspace
{% endcodeblock %}
Da `curlftpfs` und `rsync` sich irgendwie nicht so richtig mögen, habe ich auf das gute alte `cp`
zurückgegriffen und mir den Rake-Task `copyto` definiert ...
{% codeblock Meine Änderungen am Rakefile lang:ruby %}
document_root  = "../ftp/blog"
deploy_default = "copyto"
# snipp ...
desc "Deploy website via straight copy (optional argument 'clean' for prior complete removal)"
task :copyto do |args|
  puts "## Mounting remote FTP storage"
  ok_failed system("../mount_tobbe_ftp.sh")
  if args.to_s.casecmp("clean") == 0
    puts "## Remove all files"
    ok_failed system("rm -rf #{document_root}*")
  else
    puts "## Leaving remote files untouched. Just updating."
  end
  puts "## Deploying website via plain copy"
  puts "##!! This will ignore all files marked as 'exclude'"
  ok_failed system("cp -ruv #{public_dir}/* #{document_root}")
  puts "## Unmounting remote FTP storage"
  ok_failed system("../unmount_ftp.sh")
end
{% endcodeblock %}
Die beiden Bashskripte enthalten ...
{% codeblock mount_tobbe_ftp.sh %}
#!/bin/bash
MY_PATH="`dirname \"$0\"`"
MY_PATH="`(cd \"$MY_PATH\" && pwd)`"
curlftpfs ftp://USERNAME:PASSWORD@torbjoern-klatt.de/ $MY_PATH/ftp/
{% endcodeblock %}
und
{% codeblock unmount_ftp.sh %}
#!/bin/bash
MY_PATH="`dirname \"$0\"`"
MY_PATH="`(cd \"$MY_PATH\" && pwd)`"
fusermount -u $MY_PATH/ftp/
{% endcodeblock %}

Das ist alles.

Die Aktualisierung von Octopress ist ebenfalls deutlich schmerzfreier als bei WordPress o.ä.
Da alles über Git läuft, übernimmt Git und Rake einem die meiste Arbeit.
Wie das genau geht, steht in der leider noch etwas ausbaufähigen Octopress-Dokumentation:
[http://octopress.org/docs/updating/](http://octopress.org/docs/updating/)