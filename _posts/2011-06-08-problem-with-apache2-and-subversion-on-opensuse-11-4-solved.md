--- 
layout: post
title: "Problem with Apache2 and Subversion on openSUSE 11.4 solved"
date: 2011-06-08
categories: 
- Linux
published: true
comments: false
---
###Preface
This should not be a complete tutorial on how to set up a *Subversion* repository and *Apache2* on *openSUSE*, but should tackle a specific problem I had during configuration.

Here I describe my setup and configuration I'm running for having `httpd` and `svnserve` working in such a way, that I can browse the *Subversion* repositories via `http://` in a random webbrowser (either directly or in a more user-friendly way with *WebSVN*). For security and privacy reasons only a small list of defined users can access (read and/or write) the webserver and repositories.

<!-- more -->

###Background
After migrating my local workstation from *Ubuntu 10.04* to *openSUSE 11.4* I had to set up *Apache2* with *Subversion* (`svnserve`) again for my private repository. Numerous tutorials are available on-line. Some are specific for *openSUSE* as [this one](http://queens.db.toronto.edu/~nilesh/linux/subversion-howto/). Some time ago I used [this one](http://alephzarro.com/blog/2007/01/07/installation-of-subversion-on-ubuntu-with-apache-ssl-and-basicauth) for setting up everything under *Ubuntu*, which worked like charm.

However, following the above tutorial for *openSUSE* did not quite worked out for me and it took me quite a while to figure out the exact problem.

###Sidemark
I doubt the way I did it is the way everyone should do it. For example, using the same user for `httpd` and `svnserve` is probably not the best solution. However, I was not able to separate this yet and I am happy for any criticism, hints and suggestions. In addition, it might be desirable using `https://` instead of `http://`.

###Short
Having the SVN repository root in `/srv/svn`, the vhost root in `/srv/www/` and declaring an alias `/svn` pointing to `/srv/svn` (`Alias /svn "/srv/svn"`) in `/etc/apache2/conf.d/subversion.conf` is throwing up Apache's DAV SVN module (as described [here](http://www.rkrishardy.com/2009/12/subversion-fix-svn-copy-causes-repository-moved-permanentl/comment-page-1/#comment-8497)).

Browsing the repository in a random webbrowser is possible and does not throw any warnings or errors. But when using `svn {import|checkout|commit}` the following error message is displayed

{% codeblock %}
svn: Repository moved permanently to 'http://svn.test.com/myproject/'; please relocate
{% endcodeblock %}

The solution is moving the SVN repository root physically to `/srv/www/svn` and removing the Alias definition in `/etc/apache2/conf.d/subversion.conf`.

###Detailed Configuration
####Subversion (svnserve)
Define `/srv/www/svn` as the Subversion root directory by editing `SVNSERVE_OPTIONS` in `/etc/sysconf/svnserve`. In addition, `SVNSERVE_USERID` is changed to `wwwrun` and `SVNSERVE_GROUPID` to `www`.

Create the Subversion root directory `svn` in `/srv/www` and change the owner to `wwwrun:www`. With the usual `svnadmin create myproject` you create the repositories.

Finally make sure the user `wwwrun` has read, write and execute rights for the complete `/srv/www/svn` path. If it has not for `/srv` but for `/srv/www` it will very likely not work.

####Apache2 (httpd)
After installation through *YAST*, there is a template config file in `/etc/apache2/conf.d` called `subversion.conf`. Make sure the complete `mod_alias.c` block is commented out. In my case I also left the `/srv/svn/html` block commented out.

For each project a separate `Location` block needs to be defined. In my case I only want the users `user1` and `user2` having access to the repository --- no one else. These users are defined in `/etc/apache2/users.cred` with the standard `htpasswd2` method. Thus, the `Location` block looks like this:

{% codeblock %}
&lt;Location /svn/myproject&gt;
  DAV svn
  SVNPath /srv/www/svn/myproject
  Order allow,deny
  Allow from all
  AuthType Basic
  AuthName "Project 1"
  AuthUserFile /etc/apache2/users.cred
  Require user user1 user2
&lt;/Location&gt;
{% endcodeblock %}

As usual you also can define user groups in `/etc/apache2/groups.cred` and use `AuthGroupFile /etc/apache2/groups.cred` and `Require group` --- or any other authorisation method.

Make sure, `mod_dav` and `mod_dav_svn` are loaded. One way is to append `dav` and `dav_svn` to the line `APACHE_MODULES` in `/etc/sysconf/apache2`.

####WebSVN
After installation through YAST use `/etc/websvn/config.php` for configuration. This file should be self-explaining.

Finally restart `svnserve` and `Apache2` and everything should be fine.

*Remark: This text has been [cross-posted to the openSUSE Forums](http://forums.opensuse.org/english/get-technical-help-here/how-faq-forums/unreviewed-how-faq/461165-howto-apache2-subversion-svn-access-control-opensuse-11-4-a.html) on June 8th, 2011*
