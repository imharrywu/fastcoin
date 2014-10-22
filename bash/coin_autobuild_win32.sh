# 1) zlib
make install -f win32/Makefile.gcc \
DESTDIR=/usr/local/zlib-1.2.8/ \
INCLUDE_PATH=include \
LIBRARY_PATH=lib \
BINARY_PATH=bin


# 2) libpng
./configure --prefix=/usr/local/libpng-1.6.9 \
--enable-shared=no \
--enable-static=yes


# 3) qrencode 
./configure --prefix=/usr/local/qrencode-3.4.3 \
--enable-shared=no \
--enable-static=yes \
png_CFLAGS="-I/usr/local/libpng-1.6.9/include" \
png_LIBS="-L/usr/local/libpng-1.6.9/lib -lpng16"


# 4) protobuf
./configure --prefix=/usr/local/protobuf-2.5.0 \
--enable-static=yes \
--enable-shared=no


# 5) BerkeleyDB
cd build_unix && sh ../dist/configure \
--enable-mingw \
--enable-cxx \
--disable-replication


# 6) miniupnpc
make -f Makefile.mingw && mkdir miniupnpc && cp *.h miniupnpc 


# 7) OpenSSL
./config \
no-shared \
no-threads \
no-asm \
no-zlib \
--prefix=/usr/local/ssl \
&& make && make install


# 8) Boost
b2 install --prefix=/usr/local/boost-1.53 \
toolset=gcc \
link=shared \
variant=release \
runtime-link=shared \
threading=multi \
--without-mpi \
--without-python \
--without-wave \
--without-graph \
--without-graph_parallel 

# 9) qt4
configure.exe \
    -I "/usr/local/ssl/include" \
    -L "/usr/local/ssl/lib" \
    -l ssl \
    -l crypto \
    -release \
    -opensource \
    -confirm-license \
    -static \
    -no-ltcg \
    -no-fast \
    -exceptions \
    -accessibility \
    -stl \
    -no-sql-sqlite \
    -no-qt3support \
    -no-opengl \
    -no-openvg \
    -platform win32-g++ \
    -no-system-proxies \
    -qt-zlib \
    -no-gif \
    -qt-libpng \
    -no-libmng \
    -no-libtiff \
    -qt-libjpeg \
    -no-dsp \
    -no-vcproj \
    -no-incredibuild-xge \
    -plugin-manifests \
    -qmake \
    -process -nomake demos -nomake examples -nomake tools \
    -no-rtti \
    -no-mmx \
    -no-3dnow \
    -no-sse \
    -no-sse2 \
    -openssl \
    -no-dbus \
    -no-phonon -no-phonon-backend \
    -no-multimedia -no-audio-backend \
    -no-webkit \
    -no-script -no-scripttools -no-declarative \
    -arch windows \
    -no-style-plastique \
    -no-style-windowsxp -no-style-windowsvista \
    -no-style-cleanlooks -no-style-cde \
    -no-style-motif \
    -no-native-gestures \
    -saveconfig csdnbuild    




# 10)
export DEPEND_HOME=/usr/local
export MAKENSIS_HOME=${DEPEND_HOME}/nsis-2.46
export BDB_INC_HOME=${DEPEND_HOME}/BerkeleyDB.4.8/include
export BDB_LIB_HOME=${DEPEND_HOME}/BerkeleyDB.4.8/lib
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
export SSL_INC_HOME=${DEPEND_HOME}/ssl/include
export SSL_LIB_HOME=${DEPEND_HOME}/ssl/lib
export CRYPTO_INC_HOME=${DEPEND_HOME}/ssl/include
export CRYPTO_LIB_HOME=${DEPEND_HOME}/ssl/lib
export ZLIB_INC_HOME=${DEPEND_HOME}/zlib-1.2.8/include
export ZLIB_LIB_HOME=${DEPEND_HOME}/zlib-1.2.8/lib
export PATH=${PATH}:${MAKENSIS_HOME}
./configure \
    --enable-wallet \
    --disable-tests \
    --disable-ipv6 \
    --disable-ccache \
    --with-boost="${BOOST_TOP_HOME}" \
    --with-qrencode=yes \
    --with-miniupnpc=yes \
    --with-protoc-bindir=${PROTOC_BIN_HOME} \
    --with-cli=yes \
    --with-daemon=yes \
    --with-gui=qt4 \
    --with-qt-incdir=${QT_INC_HOME} \
    --with-qt-libdir=${QT_LIB_HOME} \
    --with-qt-bindir=${QT_BIN_HOME} \
    --with-qt-plugindir=${QT_PLUGIN_HOME} \
    CPPFLAGS="-w -g -O0 -I${QR_INC_HOME} -I${PNG_INC_HOME} -I${PROTOC_INC_HOME} -I${SSL_INC_HOME} -I${CRYPTO_INC_HOME} -I${BDB_INC_HOME} -I${MINIUPNPC_INC_HOME} -I${BOOST_INC_HOME} -I${ZLIB_INC_HOME}" \
    LDFLAGS="-L${QR_LIB_HOME} -L${QT_CODECS_HOME} -L${PNG_LIB_HOME} -L${PROTOC_LIB_HOME} -L${SSL_LIB_HOME} -L${CRYPTO_LIB_HOME} -L${BDB_LIB_HOME} -L${MINIUPNPC_LIB_HOME} -L${ZLIB_LIB_HOME}" 
