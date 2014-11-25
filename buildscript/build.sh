#!/bin/bash
export MAKENSIS_HOME=${DEPEND_HOME}/nsis-2.46
#Notice, use the cygwin hexdump tool to test.
#http://gnuwin32.sourceforge.net/packages/util-linux-ng.htm
export HEXTOOLS_BIN_HOME=${DEPEND_HOME}/hexdump/bin
export GIT_BIN_HOME="/c/Git/bin"

export PATH=${PATH}:${MAKENSIS_HOME}:${GIT_BIN_HOME}:${HEXTOOLS_BIN_HOME}

make deploy