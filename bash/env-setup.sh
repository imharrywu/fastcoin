#!/bin/bash

#For now, we assume that we are using ubuntu x86_64 distribution.

HOST=i686-w64-mingw32 
PACKAGES="nsis gcc-mingw-w64-i686 g++-mingw-w64-i686 binutils-mingw-w64-i686 mingw-w64-dev wine" 
RUN_TESTS=true 
GOAL="deploy"

#echo deb http://us.archive.ubuntu.com/ubuntu precise main universe >> /etc/apt/sources.list

if [ -n "$PACKAGES" ]; then sudo apt-get update; fi

if [ -n "$PACKAGES" ]; then sudo apt-get install --no-upgrade $PACKAGES; fi


