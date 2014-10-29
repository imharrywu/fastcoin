#!/bin/bash

CCACHE_SIZE=100M

CCACHE_TEMPDIR=/tmp/.ccache-temp

CCACHE_COMPRESS=1

CCACHE_READONLY=1

HOST=i686-w64-mingw32 

./depends/$HOST/native/bin/ccache --max-size=$CCACHE_SIZE

sh ./autogen.sh

REPO_ABS_DIR=$(pwd)

BASE_OUTDIR=$REPO_ABS_DIR/out

BITCOIN_CONFIG_ALL="--disable-dependency-tracking --prefix=$REPO_ABS_DIR/depends/$HOST --bindir=$BASE_OUTDIR/bin --libdir=$BASE_OUTDIR/lib"

./configure --cache-file=config.cache $BITCOIN_CONFIG_ALL $BITCOIN_CONFIG 

make distdir PACKAGE=bitcoin VERSION=$HOST

cd bitcoin-$HOST

./configure --cache-file=../config.cache $BITCOIN_CONFIG_ALL $BITCOIN_CONFIG 

MAKEJOBS=

GOAL="deploy"

make $MAKEJOBS $GOAL 

RUN_TESTS=true 

if [ "$RUN_TESTS" = "true" ]; then make check; fi

