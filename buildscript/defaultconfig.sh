export DEPEND_HOME=/d/workspace/github/altcoin/bitcoin-3rd

export MAKENSIS_HOME=${DEPEND_HOME}/nsis-2.46
#Notice, use the cygwin hexdump tool to test.
#http://gnuwin32.sourceforge.net/packages/util-linux-ng.htm
export HEXTOOLS_BIN_HOME=${DEPEND_HOME}/hexdump/bin
export GIT_BIN_HOME="/c/Git/bin"

export BDB_INC_HOME=${DEPEND_HOME}/BerkeleyDB-4.8/include
export BDB_LIB_HOME=${DEPEND_HOME}/BerkeleyDB-4.8/lib

export BOOST_TOP_HOME=${DEPEND_HOME}/boost-1.55
export BOOST_INC_HOME=${DEPEND_HOME}/boost-1.55/include/boost-1_55
export BOOST_LIB_HOME=${DEPEND_HOME}/boost-1.55/lib

export PNG_INC_HOME=${DEPEND_HOME}/libpng-1.6.9/include
export PNG_LIB_HOME=${DEPEND_HOME}/libpng-1.6.9/lib

export MINIUPNPC_INC_HOME=${DEPEND_HOME}/miniupnpc-1.9.0/include
export MINIUPNPC_LIB_HOME=${DEPEND_HOME}/miniupnpc-1.9.0/lib

export PROTOC_BIN_HOME=${DEPEND_HOME}/protobuf-2.5.0/bin
export PROTOC_INC_HOME=${DEPEND_HOME}/protobuf-2.5.0/include
export PROTOC_LIB_HOME=${DEPEND_HOME}/protobuf-2.5.0/lib

export QR_INC_HOME=${DEPEND_HOME}/qrencode-3.4.3/include
export QR_LIB_HOME=${DEPEND_HOME}/qrencode-3.4.3/lib

export QT_BIN_HOME=${DEPEND_HOME}/qt-4.8.5-mingw32-4.8.1/bin
export QT_INC_HOME=${DEPEND_HOME}/qt-4.8.5-mingw32-4.8.1/include
export QT_LIB_HOME=${DEPEND_HOME}/qt-4.8.5-mingw32-4.8.1/lib
export QT_PLUGIN_HOME=${DEPEND_HOME}/qt-4.8.5-mingw32-4.8.1/plugins
export QT_CODECS_HOME=${DEPEND_HOME}/qt-4.8.5-mingw32-4.8.1/plugins/codecs
export QT_ACCESSIBLE_HOME=${DEPEND_HOME}/qt-4.8.5-mingw32-4.8.1/plugins/accessible

export SSL_INC_HOME=${DEPEND_HOME}/ssl/include
export SSL_LIB_HOME=${DEPEND_HOME}/ssl/lib

export CRYPTO_INC_HOME=${DEPEND_HOME}/ssl/include
export CRYPTO_LIB_HOME=${DEPEND_HOME}/ssl/lib

export ZLIB_INC_HOME=${DEPEND_HOME}/zlib-1.2.8/include
export ZLIB_LIB_HOME=${DEPEND_HOME}/zlib-1.2.8/lib

export GMP_INC_HOME=${DEPEND_HOME}/gmp-6.0.0a/include
export GMP_LIB_HOME=${DEPEND_HOME}/gmp-6.0.0a/lib

export PATH=${PATH}:${MAKENSIS_HOME}:${GIT_BIN_HOME}:${HEXTOOLS_BIN_HOME}

./configure \
	--enable-wallet \
	--disable-tests \
	--disable-ccache \
	--enable-debug \
	--disable-tests \
	--enable-upnp-default \
	--with-boost="${BOOST_TOP_HOME}" \
	--with-qrencode=yes \
	--with-miniupnpc=yes \
	--with-protoc-bindir=${PROTOC_BIN_HOME} \
	--with-daemon=yes \
	--with-gui=qt4 \
	--with-qt-incdir=${QT_INC_HOME} \
	--with-qt-libdir=${QT_LIB_HOME} \
	--with-qt-bindir=${QT_BIN_HOME} \
	--with-qt-plugindir=${QT_PLUGIN_HOME} \
	CPPFLAGS="-I$GMP_INC_HOME -I${QR_INC_HOME} -I${PNG_INC_HOME} -I${PROTOC_INC_HOME} -I${SSL_INC_HOME} -I${CRYPTO_INC_HOME} -I${BDB_INC_HOME} -I${MINIUPNPC_INC_HOME} -I${BOOST_INC_HOME} -I${ZLIB_INC_HOME}" \
	CFLAGS="-w -g -O0 " \
	LDFLAGS="-L$GMP_LIB_HOME -L${QR_LIB_HOME} -L${QT_CODECS_HOME} -L${QT_ACCESSIBLE_HOME} -L${PNG_LIB_HOME} -L${PROTOC_LIB_HOME} -L${SSL_LIB_HOME} -L${CRYPTO_LIB_HOME} -L${BDB_LIB_HOME} -L${MINIUPNPC_LIB_HOME} -L${ZLIB_LIB_HOME}" 

#sh ./unix_path_to_win_path.sh /d/workspace
	
#make # will use the above path env.

#echo @@@@@Remeber to export path for Git@@@@@@@@@@@@@@@

