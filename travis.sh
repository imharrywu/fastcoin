#!/bin/bash

# Note: remember to switch to sources other than CN, e.g. US(united states) source 
# and do `apt-get update' before building;

# Travis env.
export TRAVIS_BUILD_ID="TravisBuildId-0"
export TRAVIS_BUILD_DIR=$(pwd)
export TRAVIS_PULL_REQUEST="pr1"
export TRAVIS_REPO_SLUG="username/reponame"
export TRAVIS_JOB_NUMBER="job1"

# Matrix
matrix="Win32Gui"
#matrix="Linux"
#matrix="Cross-Mac"

# For `matrix="Cross-Mac"'
# sudo pip install ez_setup

# For `matrix="Win32"'
# ref: a lite addon for mingw-w64  https://github.com/meganz/mingw-std-threads
# ref: difference of posix and win32 threads: https://wiki.qt.io/MinGW-64-bit#GCC_Threading_model_.28posix_vs_win32.29
# prefer to use i686-mingw64-w64-g++-posix (soft link is i686-mingw64-w64-g++, default to -win32) for Win32 build
# by sudo update-alternatives --config ...
# ref: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=757259
# sudo update-alternatives --config i686-w64-mingw32-gcc
# sudo update-alternatives --config i686-w64-mingw32-g++
# Note: if --enable-gui, RUN_TESTs=false is recommended for Win32Gui, otherwise QtTest will fail.

export MAKEJOBS=-j1
export RUN_TESTS=false
export CHECK_DOC=0
export BOOST_TEST_RANDOM=$(date +%s)
export CCACHE_SIZE=100M
export CCACHE_TEMPDIR=/tmp/.ccache-temp
export CCACHE_COMPRESS=1
export BASE_OUTDIR=$PWD/built
export SDK_URL=https://bitcoincore.org/depends-sources/sdks
export PYTHON_DEBUG=1
export WINEDEBUG=fixme-all

# ARM
if [ "$matrix" = "ARM" ]; then
	export HOST=arm-linux-gnueabihf 
	export PACKAGES="g++-arm-linux-gnueabihf" 
	export DEP_OPTS="NO_QT=1" 
	export CHECK_DOC=1 
	export GOAL="install" 
	export BITCOIN_CONFIG="--disable-gui --disable-tests --disable-debug --disable-bench --without-libs --enable-glibc-back-compat --enable-reduce-exports"

# Win32
elif [ "$matrix" = "Win32" ]; then
	export HOST=i686-w64-mingw32 
	export DPKG_ADD_ARCH="i386" 
	export DEP_OPTS="NO_QT=1" 
	export PACKAGES="python3 nsis g++-mingw-w64-i686 bc" 
	export RUN_TESTS=true 
	export GOAL="install" 
	export BITCOIN_CONFIG="--disable-gui --without-libs --disable-debug --disable-bench --disable-tests --enable-reduce-exports"

# Win32Gui-debug
elif [ "$matrix" = "Win32Gui" ]; then
	export HOST=i686-w64-mingw32 
	export DPKG_ADD_ARCH="i386" 
	export PACKAGES="python3 nsis g++-mingw-w64-i686 bc" 
	export RUN_TESTS=false
	export GOAL="install"
	export BITCOIN_CONFIG="--with-gui --disable-tests --enable-debug --disable-bench --without-libs"

# Win32Gui
elif [ "$matrix" = "Win32Gui" ]; then
	export HOST=i686-w64-mingw32
	export DPKG_ADD_ARCH="i386"
	export PACKAGES="python3 nsis g++-mingw-w64-i686 bc"
	export RUN_TESTS=false
	export GOAL="deploy"
	export BITCOIN_CONFIG="--with-gui --disable-tests --disable-debug --disable-bench --without-libs"

# Win64Gui
elif [ "$matrix" = "Win64Gui" ]; then
	export HOST=x86_64-w64-mingw32
	export DPKG_ADD_ARCH="i386"
	export PACKAGES="python3 nsis g++-mingw-w64-x86-64 bc"
	export RUN_TESTS=false
	export GOAL="deploy"
	export BITCOIN_CONFIG="--with-gui --disable-tests --disable-bench --disable-debug --enable-reduce-exports"

# Cross-Mac
elif [ "$matrix" = "Cross-Mac" ]; then
	export HOST=x86_64-apple-darwin11
	export PACKAGES="cmake imagemagick libcap-dev librsvg2-bin libz-dev libbz2-dev libtiff-tools python-dev python-pip"
	export DEP_OPTS="NO_UPNP=1"
	export OSX_SDK=10.11
	export RUN_TESTS=false
	export GOAL="deploy"
	export BITCOIN_CONFIG="--enable-gui --disable-tests --disable-debug --disable-bench --enable-reduce-exports"

# Linux
elif [ "$matrix" = "Linux" ]; then
	export HOST=x86_64-unknown-linux-gnu 
	export PACKAGES="bc python3-zmq" 
        export DEP_OPTS="NO_QT=1"
	export RUN_TESTS=false
	export GOAL="install"
	export USE_SHELL="/bin/bash"
	export BITCOIN_CONFIG="--disable-debug --without-libs --without-gui --disable-gui --disable-tests --disable-bench --enable-zmq --enable-glibc-back-compat --enable-reduce-exports CPPFLAGS=-DDEBUG_LOCKORDER"

# debug 
elif [ "$matrix" = "debug" ]; then
	export HOST=x86_64-unknown-linux-gnu 
	export PACKAGES="bc python3-zmq" 
        export DEP_OPTS="NO_QT=1"
	export RUN_TESTS=false
	export GOAL="install"
	export USE_SHELL="/bin/bash"
	export BITCOIN_CONFIG="--enable-debug --without-libs --without-gui --disable-gui --disable-tests --disable-bench --enable-zmq --enable-glibc-back-compat --enable-reduce-exports CPPFLAGS=-DDEBUG_LOCKORDER"

# undefined
else 
	exit 1
fi 

# before_install:
export PATH=$(echo $PATH | tr ':' "\n" | sed '/\/opt\/python/d' | tr "\n" ":" | sed "s|::|:|g")

sudo apt-get install --no-install-recommends --no-upgrade -qq automake autoconf libltdl-dev libtool; 

# install:
if [ -n "$PPA" ]; then 
    sudo add-apt-repository "$PPA" -y;
fi

if [ -n "$DPKG_ADD_ARCH" ]; then 
    sudo dpkg --add-architecture "$DPKG_ADD_ARCH" ;
fi

if [ -n "$PACKAGES" ]; then 
    sudo apt-get update;
fi

if [ -n "$PACKAGES" ]; then 
	sudo apt-get install --no-install-recommends --no-upgrade -qq $PACKAGES; 
fi

# before_script:
unset CC; unset CXX

mkdir -p depends/SDKs depends/sources depends/sdk-sources

if [ -n "$OSX_SDK" -a ! -f depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz ]; then 
	curl --location --fail $SDK_URL/MacOSX${OSX_SDK}.sdk.tar.gz -o depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz; 
fi

if [ -n "$OSX_SDK" -a -f depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz ]; then 
	tar -C depends/SDKs -zxvf depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz;
fi

make $MAKEJOBS -C depends HOST=$HOST $DEP_OPTS

export TRAVIS_COMMIT_LOG="$(git log --format=fuller -1)"

if [ -n "$USE_SHELL" ]; then 
	export CONFIG_SHELL="$USE_SHELL"; 
fi

export OUTDIR=$BASE_OUTDIR/$TRAVIS_PULL_REQUEST/$TRAVIS_JOB_NUMBER-$HOST

export BITCOIN_CONFIG_ALL="--disable-dependency-tracking --prefix=$TRAVIS_BUILD_DIR/depends/$HOST --bindir=$OUTDIR/bin --libdir=$OUTDIR/lib"

depends/$HOST/native/bin/ccache --max-size=$CCACHE_SIZE

if [ -n "$USE_SHELL" ]; then
	eval '"$USE_SHELL" -c "./autogen.sh"' 
else
	./autogen.sh
fi

./configure $BITCOIN_CONFIG_ALL $BITCOIN_CONFIG || ( cat config.log && exit 1)

make $MAKEJOBS $GOAL || ( echo "Build failure. Verbose build follows." && make $GOAL V=1 ; exit 1 )

#after_script:
echo Commit-Range: $TRAVIS_COMMIT_RANGE 
echo Commit-Log: $TRAVIS_COMMIT_LOG

