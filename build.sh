#!/bin/sh

PWD=$(pwd)
SRC_DIR=$PWD/src
BUILD_DIR=$PWD/build
DOWNLOAD_DIR=$PWD/dl
LIBS_DIR=$BUILD_DIR/libs

LIBPCAP_VER="1.8.1"
LIBPCAP_URL="https://www.tcpdump.org/release/libpcap-${LIBPCAP_VER}.tar.gz"
LIBPCAP_DIR=""

prepare_dirs(){
	if [ ! -d $BUILD_DIR ]; then
		mkdir -p $BUILD_DIR || exit 1
	fi
	if [ ! -d $DOWNLOAD_DIR ]; then
		mkdir -p $DOWNLOAD_DIR || exit 1
	fi
	if [ ! -d $LIBS_DIR ]; then
		mkdir -p $LIBS_DIR || exit 1
	fi
	return 0
}

download_files(){
	if [ -d $DOWNLOAD_DIR ] && [ ! -d $DOWNLOAD_DIR/libpcap-${LIBPCAP_VER} ]; then
		cd $DOWNLOAD_DIR; \
		wget $LIBPCAP_URL; \
		tar xf libpcap-${LIBPCAP_VER}.tar.gz
	fi
	LIBPCAP_DIR=$(cd $DOWNLOAD_DIR/libpcap-${LIBPCAP_VER} && pwd)
	return 0
}

build_depends(){
	if [ -d $LIBPCAP_DIR ]; then
		cd $LIBPCAP_DIR; \
		./configure --with-pcap=linux --disable-dbus --disable-remote --prefix=$LIBS_DIR; \
		make clean; \
		make; \
		make install
	fi
	return 0
}

build_target(){
	make -C $SRC_DIR CONFIG_STATIC=yes LIBS_BASE=$LIBS_DIR strip && mv $SRC_DIR/zizzania $BUILD_DIR
	make -C $SRC_DIR clean
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

prepare_dirs
download_files
build_depends
build_target
#clean_all
