---
layout: post
title: Multiple Ccache-enabled Compilers With Modules
date: 2015-05-13T14:13:29+02:00
comments: true
published: false
categories:
  - Programming
  - English
---

## Module Files

$> ll /opt/ccache/wrapper
total 28K
drwxr-xr-x 1 root root  52 May 13 15:59 .
drwxr-xr-x 1 root root  14 May 13 10:57 ..
lrwxrwxrwx 1 root root   3 May 13 12:03 c++ -> g++
lrwxrwxrwx 1 root root   3 May 13 12:03 cc -> gcc
-rwxr-xr-x 1 root root 133 May 13 15:30 clang
-rwxr-xr-x 1 root root 135 May 13 15:30 clang++
-rwxr-xr-x 1 root root  93 May 13 15:29 cpp
-rwxr-xr-x 1 root root  93 May 13 15:29 g++
-rwxr-xr-x 1 root root  93 May 13 15:29 gcc
16:05:31 # for f in *; do echo $f && cat $f; done
/opt/ccache/wrapper  
c++
#!/bin/sh

CCACHE_DIR="${CCACHE_BASE_DIR}/${CCACHE_SUFFIX}" ccache ${GCC_ROOT}/bin/g++ "$@"

cc
#!/bin/sh

CCACHE_DIR="${CCACHE_BASE_DIR}/${CCACHE_SUFFIX}" ccache ${GCC_ROOT}/bin/gcc "$@"

clang
#!/bin/sh

CCACHE_CPP2=YES CCACHE_DIR="${CCACHE_BASE_DIR}/clang" ccache /usr/bin/clang
`test -t 2 && echo -fcolor-diagnostics` "$@"

clang++
#!/bin/sh

CCACHE_CPP2=YES CCACHE_DIR="${CCACHE_BASE_DIR}/clang" ccache /usr/bin/clang++
`test -t 2 && echo -fcolor-diagnostics` "$@"

cpp
#!/bin/sh

CCACHE_DIR="${CCACHE_BASE_DIR}/${CCACHE_SUFFIX}" ccache ${GCC_ROOT}/bin/cpp "$@"

g++
#!/bin/sh

CCACHE_DIR="${CCACHE_BASE_DIR}/${CCACHE_SUFFIX}" ccache ${GCC_ROOT}/bin/g++ "$@"

gcc
#!/bin/sh

CCACHE_DIR="${CCACHE_BASE_DIR}/${CCACHE_SUFFIX}" ccache ${GCC_ROOT}/bin/gcc "$@"

