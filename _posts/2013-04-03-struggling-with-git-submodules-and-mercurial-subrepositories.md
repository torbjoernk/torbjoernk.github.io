---
layout: post
title: "Struggling with Git Submodules and Mercurial Subrepositories"
date: 2013-04-03 21:56
comments: true
published: true
categories:
  - Programming
---
The popular and state-of-the-art [distributed version control systems (DVCS)](https://en.wikipedia.org/wiki/Distributed_revision_control) 
tools **[Git](http://git-scm.com/)** and **[Mercurial](http://mercurial.selenic.com/)** 
are very likely the best way of reliably organising software development.
Both have numerous advantages over their predecessor **[Subversion (SVN)](http://subversion.tigris.org/)**.

All three have a feature for handling nested repositories, which can but must not 
depend on each other: _[Git Submodules](http://git-scm.com/docs/git-submodule)_, 
_[Mercurial Subrepositories](http://mercurial.selenic.com/wiki/Subrepository)_ 
and _[Subversion Externals](http://svnbook.red-bean.com/en/1.7/svn.advanced.externals.html)_.

In this article I will describe an attempt of converting an existing SVN repository 
into a hierarchy of nested Git, Mercurial or SVN repositories while satisfying 
special demands on the whole setup.

If you are just interested in the final solution, scroll down to the conclusion.
But be warned ...

<!-- more -->

## Starting Point and Current Setup

### The Application
The application called _[ug4](http://atlas.gcsc.uni-frankfurt.de/~ug/)_ is a 
scientific algorithm suite for mathematical modelling and simulation of various 
problems from basic diffusion to coupled systems in fluid dynamics.
It is written in C++ with heavy use of templated metaprogramming and an API 
enabling Lua-scripting and binding a Java-based GUI called _[VRL-Studio](http://vrl-studio.mihosoft.eu/)_.
It compiles fluently on Unix, OSX and Windows and runs on pretty much all 
computers from Netbooks to super computers with thousands of cores as 
[JuQueen](http://www.fz-juelich.de/ias/jsc/EN/Expertise/Supercomputers/JUQUEEN/JUQUEEN_node.html) 
or [HERMIT](http://www.hlrs.de/?id=1546) with a remarkable performance.


### The Repository
The current SVN repository consists of a **core** application with three main 
and deeply interoperating **libraries** and some _glue-code_.
Beside this there are a few _core_ and some _experimental_ **plugins**.
Finally there are numerous **apps** using the shared library build from the core, 
the three libraries and selected plugins.

Third-party libraries are included by the core and main libraries and might be 
added by certain plugins.
For better usability and portability required third-party libraries are included 
as SVN Externals.

``` sh Directory structure of current repository
/
  apps/
    app1/
    app2/
    secret-app/
    ...
  docu/
  core/
    utils/
    lib1/
    lib2/
    lib3/
    some_further_folders/
    some_files
  plugins/
    core/
      core_plugin1/
      core_plugin2/
      ...
    experimental/
      test_plugin/
      broken_plugin/
      secret_plugin/
      ...
    some_files
  unit_tests/
    ...
  CMakeLists.txt
  README
  LICENSE
  ...
```

Access rights are managed through a simple plaintext file setting branch and 
directory based read and write access on a per-user basis.
Though this is not as flexible as we wish, it is the safest way of ensuring none 
of the code based developed in collaboration with industrial partners leaks into 
other parts of the repository.

#### The Group

With just a very few exceptions all developers are mathematicians, physicists and 
computer scientists.
Only a few are trained and experienced in software development, while the rest 
is happy if a commit succeeds.
For most group members resolving conflicts is a nightmare and impossible task 
and will likely be circumvented or ignored due to laziness.
Adopting the basic SVN workflow of updating the working copy before making 
changes and committing those back is seen as an imposition by some group members.
One group member already asked for having an email notification through a 
post-commit hook on the server when his project partner committed changes, so he 
does not forget to pull in these changes.


## Desired End Point

### Demands

Each and every of those listed here are _show-stopping_ requirements.
That means, if any of these is not fulfilled, the whole transition away from the
current setup will not happen.

#### Fine-Grained Access Right Management

Number one requirement is to reliably preserve and ensure read and write access 
for each and every group member and external collaborators.
This means, that there are some _secret_ apps or plugins, which must only be 
readable by a few people.
External collaborators usually have only read access to the core part and maybe 
write access to one app or plugin (differs from person to person).
Temporary group members as students usually have write access to the core part 
and a few apps and plugins (differs from student to student) and read access to 
most other apps and plugins (also differs).

#### (Global) Changes Made Easy

Some of the core developers occasionally have to refactor and rename certain API 
functionality used by some apps and plugins.
They used to change and fix all apps using these functions in one go, i.e. in 
one commit for all apps.
Thus, recursive commits must be easily possible.

All commits and pushes of changes must be easily accomplished through 
_[Eclipse](http://www.eclipse.org/)_, as it is widely used in our group.

#### Selective Checkouts

In principle most of the time all developers, collaborators and students only 
work on one app, maybe one or two plugins and rarely on the core and main libraries.
For 90% of the collaborators, changes made in other apps and plugins are of zero 
interest as those apps and plugins will only be used by very few people.
Thus it would be desirable not to have all apps and plugins checked out in the 
local working copy.

#### Easy and Time-Saving Maintenance

It must be possible to manage and maintain the whole setup easily.
Thus, having a bunch of utility scripts just for handling the repository 
integrity is an absolute no-go.

#### SVN Mirror

As some high-performance computers have extremely modified operating systems with 
dated tools installed, having only a Mercurial or Git server might result in 
serious trouble when working on such machines.
Subversion is always installed, though one will be lucky if the version reads 
1.5 or higher.

As well, for the sake of usability and adoption inside our group, during the 
transition phase the current SVN repository must still be writeable and two-way 
synchronised with the new repository setup.
A few month after the transition, the SVN server might become read-only to get 
rid of the frequent synchronisation and to force all developers to use the new 
repository.

#### Easy Branching For Mini-Group Collaboration

Due to the fact that some parts of the whole code base was developed in collaboration
with industrial partners and is subject to restrictive licenses and access rights,
SVN branches are deactivated for all developers.
With branches enabled it would be possible to accidentally merge and commit those
restricted code base into the main part, which would violate the licenses.

With separated repositories this branching for collaboratively experimenting with 
new features would be possible.


### Wishes

These are _nice to have_ and are _non-show-stopping_.
They can not compensate any of the aforementioned demands.

#### Automatic Checkouts Based on Compile Parameters

As we are already using _[CMake](http://www.cmake.org/)_ for managing the build 
process, with separated repositories for the different apps and plugins it would 
be desirable and nice to automate cloning and updating of the various repositories 
based on selected CMake parameters.
That means, if an app or plugin requires some other additional app or plugin, CMake
can check whether these dependencies are checked out and up to date.

#### Separated Version Histories

Up to now the revision history is a random mix of core, app and plugin changes.
To read and visualize only the history of, say, core additional filter commands
are required.
With separated repositories, the history will also be separated.


## Git Submodules

### How they work

Git Submodules are pointers on references of other Git repositories.
These Submodules are either managed by editing, adding and commiting a 
`.gitmodules` file in the root directory of the parent repository or via the 
subcommand `git submodule` (which edits and adds `.gitmodules` anyway).

### The Good Part

With the help of _[Gitolite](https://github.com/sitaramc/gitolite)_ it is 
possible to easily manage and maintain all Git repositories and fine-grained user 
access rights.
As well, setting up SSH keys as the only authentication method is fast to accomplish
with Git and Gitolite.
This would be a lot more secure than the current setup using plaintext passwords.

Using feature branches to collaboratively experiment with new functionality is
one of the things Git is perfect at.

There are three experienced Git users in our group, which are happy to teach and 
train the rest of the group.

### Gotchas

At no point during committing and pushing the existence (from the point of view 
of the server) of referenced subrepositories is checked.
Thus, it is easily possible to commit a reference to a subrepository, which is only
a local repository.
When somebody else clones this repository from the server he will not be able to
check out the referenced subrepository and will end up in a detached head.
An absolute no-go!

Beside this, recursive adds, commits and pushes are off by default and have to be
enabled by a command line parameter on each execution (or by defining an alias).
As this requires client-side modifications and careful usage by all developers it 
is a no-go.

### When they work

If all contributors are trained and experienced developers _and_ advanced Git 
users.
If not, sooner than later all collaborators will end up with more detached heads 
and inconsistent states than they can think of.
And you have to fix them.


## Mercurial Subrepositories

### How they work

As with Git Submodules, Mercurial Subrepositories are pointers to certain states 
of other Mercurial repositories.
These pointers are, similar to Git, managed by a dotfile (in this case `.hgsub`), 
which has to be under version control.

### The Good Part

In contrast to Git, Mercurial always makes sure that all commits of subrepositories
referenced by the root repository are available on the server.
Thus, at no time it will be possible to push changes of the root repository without
also recursively pushing all changes of the subrepositories.

The most important Mercurial commands as `add`, `commit`, `update` and `status` 
have a simple flag (`-S`) to recursively trigger the same command in the 
subrepositories.
Thus, global changes in several apps and plugins can easily be committed by a single
command from the root repository.

With the extensions _[hgsubversion](http://mercurial.selenic.com/wiki/HgSubversion)_ 
and _[convert](http://mercurial.selenic.com/wiki/ConvertExtension)_ the conversion 
from SVN to Mercurial and splitting up the whole repository into the desired 
hierarchy of subrepositories worked smoothly.
Following the detailed instructions given in an [article by Jason Hinch at Atlassian](https://blogs.atlassian.com/2011/03/goodbye_subversion_hello_mercurial/)
We could easily achieve the whole thing with a single Bash script, which is
available in [this Gist](https://gist.github.com/torbjoernk/5325343).
Be warned: depending on the size of the project it might take a couple of hours 
to run.

Similar to Gitolite for Git there is _[mercurial-server](http://www.lshift.net/mercurial-server)_ 
for Mercurial offering almost the same functionality of managing repositories 
and user access rights.

### Gotchas

There is no way of having Subrepositories without adding _and_ committing the 
`.hgsub` file.
Thus, local-only subrepositories for the various apps and experimental plugins 
are impossible without any additional client-side scripts and hooks.
This is a no-go.

After conversion of the current SVN to a single Mercurial repository two-way 
synchronisation will work through post-commit hooks on both servers.
As soon as the Mercurial repository is split up into a hierarchy of subrepositories 
there will be no way of synchronising from SVN to Mercurial or vice-versa.
Thus, the transition will be a two-step process where the first is the transition 
to Mercurial leading to a complete shut-down of the SVN server and the second 
step will be the splitting into subrepositories.
While the latter is a one-time hard cut transition.
A no-go.

To hold it with two guys from Mercurial's IRC channel on freenode:
{% blockquote kiilerix, irc.freenode.net#mercurial on April 3rd 2013 %}
nobody said subrepos made sense ;-)
{% endblockquote %}
{% blockquote JordiGH, irc.freenode.net#mercurial on April 3rd 2013 %}
subrepos are a Feature of Last Resort. By their very nature, they have to break 
a number of things.
{% endblockquote %}
I'm adding, that this also holds true for Git Submodules.

### When they work

Mercurial subrepositories would be perfect for the core part with the main libraries 
and external dependencies as _Boost_.
The core part would always have a clean and consistent state and no undefined
references can occur.


## SVN Externals

### How they work

Similar to Git Submodules and Mercurial Subrepositories, SVN Externals are 
pointers to certain revisions of other SVN repositories.
They either can be a _floating_ reference onto the `HEAD` revision or a fixed 
reference onto a specific revision, say `r42`.

### The Good Part

Our current administrator does not need to learn any fancy new things.
Nor does the others of the group.

Access rights can still be managed not only by repository, branch and tag but also
by path, as Subversion allows partial commits and checkouts.

### Gotchas

Recursive commits out of the root repository into all subrepositories as provided 
by Mercurial, is partially implemented in the current development snapshot of 
version 1.8 (see [this comment on a Bug report](http://subversion.tigris.org/issues/show_bug.cgi?id=1167#desc30).
Without adding pre-commit hooks on the client side to automatically update the 
referenced revisions of the external subrepositories, it is hardly possible to 
achieve a clean state at all revisions of the root repository.
Again, client-side hooks and commit scripts are a no-go.

### When they work

They are a great way of including certain releases or snapshots of third-party 
libraries into a project.
As we are doing it with _[METIS](http://glaros.dtc.umn.edu/gkhome/views/metis)_ 
or _[Boost](http://www.boost.org/)_.
In case your developers are randomly changing code in the base repository and 
included ones, a lot of care has to be taken on each and every commit.
The must-have feature of easy usage is lost straight away.
Adding client side pre-commit hooks is far off being reliable nor easy maintainable.


## Conclusion

If you read that far and did not skip the previous three sections: Thank you for 
letting us share the pain with you, that obviously none of the popular version 
control systems are able to handle local-only subrepositories.
You might already guess our final decision.

Yes, we stick with the current setup and did not changed anything.

We only created a Gitolite server mirroring SVN `trunk` and SVN branches (both 
read-only) for those group members eager on using a full Git workflow.
An additional Git _"fetch repository"_ gets noticed of new SVN commits by a 
post-commit hook on the SVN server which triggers a `git svn rebase` on `trunk` 
and the SVN branches and force-pushes those SVN changes to the Git mirror.
The Git mirror also allows all group members to easily create and mess around 
with feature and personal branches for the occasional _on-the-road-hack_.
Changes, which should go into the main development branch (i.e. `trunk`) must be 
committed directly to the SVN server via `git svn dcommit`.

This way, we still comply with the tight access rights on the code base and 
must-have comfort functions while having partial support of the agile workflows 
provided by Git's features.
Everybody seems happy.
Except the guys, who stand this adventure.
They called in sick recovering from the pain endured that no usable version control system out 
there is capable of handling this use case in a maintainable manner.

Thanks to my colleagues and companions in this adventure, [Martin Scherer](https://github.com/marscher) 
and [Stephan Grein](https://github.com/stephanmg).
