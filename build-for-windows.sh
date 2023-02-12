#!/bin/sh

PWD=$(pwd)
SRC_DIR=$PWD/src
BUILD_DIR=$PWD/build
DOWNLOAD_DIR=$PWD/dl
BINDIR_X86=$BUILD_DIR/x86
BINDIR_X64=$BUILD_DIR/x64
LIBS_DIR=$BUILD_DIR/libs
LIBSDIR_X86=$LIBS_DIR/x86
LIBSDIR_X64=$LIBS_DIR/x64

LIBPCAP_VER="1.8.1"
LIBPCAP_URL="https://www.tcpdump.org/release/libpcap-${LIBPCAP_VER}.tar.gz"
LIBPCAP_DIR=""

check_mingw(){
	if [ ! -x "$(command -v i686-w64-mingw32-gcc)" ] || [ ! -x "$(command -v x86_64-w64-mingw32-gcc)" ]; then
		echo 'Error: mingw-w64 is not installed.' >&2
		exit 1
	fi
}

prepare_dirs(){
	if [ ! -d $BUILD_DIR ]; then
		mkdir -p $BUILD_DIR || exit 1
	fi
	if [ ! -d $DOWNLOAD_DIR ]; then
		mkdir -p $DOWNLOAD_DIR || exit 1
	fi
	if [ ! -d $BINDIR_X86 ]; then
		mkdir -p $BINDIR_X86 || exit 1
	fi
	if [ ! -d $BINDIR_X64 ]; then
		mkdir -p $BINDIR_X64 || exit 1
	fi
	if [ ! -d $LIBS_DIR ]; then
		mkdir -p $LIBS_DIR || exit 1
	fi
	if [ ! -d $LIBSDIR_X86 ]; then
		mkdir -p $LIBSDIR_X86 || exit 1
	fi
	if [ ! -d $LIBSDIR_X64 ]; then
		mkdir -p $LIBSDIR_X64 || exit 1
	fi
	return 0
}

download_files(){
	if [ -d $DOWNLOAD_DIR ] && [ ! -d $DOWNLOAD_DIR/libpcap-$LIBPCAP_VER ]; then
		cd $DOWNLOAD_DIR; \
		wget $LIBPCAP_URL; \
		tar xf libpcap-$LIBPCAP_VER.tar.gz
	fi
	LIBPCAP_DIR=$(cd $DOWNLOAD_DIR/libpcap-$LIBPCAP_VER && pwd)
	return 0
}

build_depends_x86(){
	if [ -d $LIBPCAP_DIR ]; then
		cd $LIBPCAP_DIR; \
		./configure --host=i686-w64-mingw32 --prefix=$LIBSDIR_X86; \
		make clean; \
		make; \
		make install
	fi
	return 0
}

build_depends_x64(){
	if [ -d $LIBPCAP_DIR ]; then
		cd $LIBPCAP_DIR; \
		./configure --host=x86_64-w64-mingw32 --prefix=$LIBSDIR_X64; \
		make clean; \
		make; \
		make install
	fi
	return 0
}

build_target_x86(){
	make -C $SRC_DIR CC=i686-w64-mingw32-gcc STRIP=i686-w64-mingw32-strip WINDRES=i686-w64-mingw32-windres CONFIG_STATIC=yes TARGET_OS=MinGW LIBS_BASE=$LIBSDIR_X86 strip && mv $SRC_DIR/*.exe $BINDIR_X86
	make -C $SRC_DIR TARGET_OS=MinGW clean
	return 0
}

build_target_x64(){
	make -C $SRC_DIR CC=x86_64-w64-mingw32-gcc STRIP=x86_64-w64-mingw32-strip WINDRES=x86_64-w64-mingw32-windres CONFIG_STATIC=yes TARGET_OS=MinGW LIBS_BASE=$LIBSDIR_X64 strip && mv $SRC_DIR/*.exe $BINDIR_X64
	make -C $SRC_DIR TARGET_OS=MinGW clean
	return 0
}

#clean_all(){
#	if [ -d $BUILD_DIR ]; then
#		rm -rf $BUILD_DIR || exit 1
#	elif [ -d $DOWNLOAD_DIR ]; then
#		rm -rf $DOWNLOAD_DIR || exit 1
#	fi
#	return 0
#}

check_mingw
prepare_dirs
download_files
build_depends_x86
build_depends_x64
build_target_x86
build_target_x64
#clean_all
