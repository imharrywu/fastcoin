# 1) Boost
./b2 install --prefix=/root/harrywu/build/3rd/boost toolset=gcc variant=release link=static threading=multi runtime-link=static --without-graph --without-graph_parallel --without-mpi --without-python --without-regex --without-wave


# 2) BerkeleyDB
cd build_unix && ../dist/configure --prefix=/root/harrywu/build/3rd/bdb48 --enable-static=yes --enable-shared=no --enable-cxx --disable-replication --disable-debug


# 3) miniupnpc
make DESTDIR=/root/harrywu/build/3rd/miniupnpc-1.9.0 INSTALLPREFIX= install


# 4) protobuf
./configure --prefix=/root/harrywu/build/3rd/protobuf-2.5.0 --enable-shared=no --enable-static=yes CPPFLAGS=-I/root/harrywu/build/3rd/zlib-1.2.8/include/ LDFLAGS=-L/root/harrywu/build/3rd/zlib-1.2.8/lib LIBS=-lz


# 5) qrencode
./configure --prefix=/root/harrywu/build/3rd/qrencode-3.4.3 --enable-shared=no --enable-static=yes png_CFLAGS=-I/root/harrywu/build/3rd/libpng-1.6.10/ png_LIBS=-L/root/harrywu/build/3rd/libpng-1.6.10/lib/ -lpng16


# 6) ssl
./config no-threads no-shared no-zlib no-asm --prefix=/root/harrywu/build/3rd/ssl


# 7) zlib
./configure --prefix=/root/harrywu/build/3rd/zlib-1.2.8 --static


# 8) libpng
./configure --prefix=/root/harrywu/build/3rd/libpng-1.6.10 --enable-shared=no --enable-static=yes CPPFLAGS=-I/root/harrywu/build/3rd/zlib-1.2.8/include/ LDFLAGS=-L/root/harrywu/build/3rd/zlib-1.2.8/lib LIBS=-lz


# 9) qt missing


# 10) Bitcoin
export DEPEND_HOME=/root/harrywu/build/3rd
export BDB_INC_HOME=${DEPEND_HOME}/BerkeleyDB-4.8.0/include
export BDB_LIB_HOME=${DEPEND_HOME}/BerkeleyDB-4.8.0/lib
export BOOST_TOP_HOME=${DEPEND_HOME}/boost-1.53
export BOOST_INC_HOME=${DEPEND_HOME}/boost-1.53/include/boost-1_55
export BOOST_LIB_HOME=${DEPEND_HOME}/boost-1.53/lib
export PNG_INC_HOME=${DEPEND_HOME}/libpng-1.6.10/include
export PNG_LIB_HOME=${DEPEND_HOME}/libpng-1.6.10/lib
export MINIUPNPC_INC_HOME=${DEPEND_HOME}/miniupnpc-1.9.0/include
export MINIUPNPC_LIB_HOME=${DEPEND_HOME}/miniupnpc-1.9.0/lib
export PROTOC_BIN_HOME=${DEPEND_HOME}/protobuf-2.5.0/bin
export PROTOC_INC_HOME=${DEPEND_HOME}/protobuf-2.5.0/include
export PROTOC_LIB_HOME=${DEPEND_HOME}/protobuf-2.5.0/lib
export QR_INC_HOME=${DEPEND_HOME}/qrencode-3.4.3/include
export QR_LIB_HOME=${DEPEND_HOME}/qrencode-3.4.3/lib
export SSL_INC_HOME=${DEPEND_HOME}/ssl/include
export SSL_LIB_HOME=${DEPEND_HOME}/ssl/lib
export CRYPTO_INC_HOME=${DEPEND_HOME}/ssl/include
export CRYPTO_LIB_HOME=${DEPEND_HOME}/ssl/lib
export ZLIB_INC_HOME=${DEPEND_HOME}/zlib-1.2.8/include
export ZLIB_LIB_HOME=${DEPEND_HOME}/zlib-1.2.8/lib
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
    --with-gui=no \
    CPPFLAGS="-I${QR_INC_HOME} -I${PNG_INC_HOME} -I${PROTOC_INC_HOME} -I${SSL_INC_HOME} -I${CRYPTO_INC_HOME} -I${BDB_INC_HOME} -I${MINIUPNPC_INC_HOME} -I${BOOST_INC_HOME} -I${ZLIB_INC_HOME}" \
    LDFLAGS="-L${QR_LIB_HOME} -L${PNG_LIB_HOME} -L${PROTOC_LIB_HOME} -L${SSL_LIB_HOME} -L${CRYPTO_LIB_HOME} -L${BDB_LIB_HOME} -L${MINIUPNPC_LIB_HOME} -L${ZLIB_LIB_HOME}" \
LIBS="-lrt -ldl"
