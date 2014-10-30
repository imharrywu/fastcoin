#!/bin/bash

#For now, we assume that we are using ubuntu x86_64 distribution.
PACKAGES="nsis gcc-mingw-w64-i686 g++-mingw-w64-i686 binutils-mingw-w64-i686 mingw-w64-dev wine" 

ADDSOURCE="deb http://us.archive.ubuntu.com/ubuntu precise main universe"
SOURCES_LIST="/etc/apt/sources.list"
TESTADDED=$(grep $ADDSOURCE $SOURCES_LIST)
if [ -z "$TESTADDED" ] ; then 
	sudo bash -c "echo $ADDSOURCE >> $SOURCES_LIST"
fi

if [ -n "$PACKAGES" ]; then sudo apt-get update; fi

if [ -n "$PACKAGES" ]; then sudo apt-get install --no-upgrade -qq $PACKAGES; fi

sudo apt-get install ia32-libs build-essential autoconf libtool
