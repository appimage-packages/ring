#!/bin/bash
set -e
set -x
export LD_LIBRARY_PATH=/opt/usr/lib:/opt/usr/lib/x86_64-linux-gnu:/usr/lib:/usr/lib64
export PKG_CONFIG="pkg-config --static"
cd contrib

rm -rfv build
mkdir build
cd build
if ../bootstrap --prefix=/opt/usr --enable-nettle --enable-gnutls --enable-x264 --enable-ffmpeg; then
make .nettle .gnutls .x264 .ffmpeg

make
# That's all !
else
	error_exit "$LINENO: An error has occurred.. Aborting."
fi

cd ../../
if ./autogen.sh; then
./configure --prefix=/opt/usr
make
make install

else
	error_exit "$LINENO: An error has occurred.. Aborting."
fi
cd ../../
LIBRINGLIENT=`pwd`/ring-lrc
RING=`pwd`/ring-daemon
git clone https://gerrit-ring.savoirfairelinux.com/ring-daemon
git clone https://gerrit-ring.savoirfairelinux.com/ring-lrc
cd $LIBRINGLIENT
mkdir build
cd build
if cmake .. -DRING_BUILD_DIR=$RING/src -DCMAKE_INSTALL_PREFIX=/opt/usr; then
make -j8
make install
else
	error_exit "$LINENO: An error has occurred.. Aborting."
fi
function error_exit
{
	echo "$1" 1>&2
	exit 1
}
