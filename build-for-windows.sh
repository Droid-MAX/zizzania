#!/bin/sh

PWD=$(pwd)
SRC_DIR=$PWD/src
BUILD_DIR=$PWD/build
DOWNLOAD_DIR=$PWD/dl

WINPCAP_URL="https://www.winpcap.org/install/bin/WpdPack_4_1_2.zip"
WINPCAP_DIR=""

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
	return 0
}

download_files(){
	if [ -d $DOWNLOAD_DIR ] && [ ! -d $DOWNLOAD_DIR/WpdPack ]; then
		cd $DOWNLOAD_DIR; \
		wget $WINPCAP_URL; \
		unzip WpdPack_4_1_2.zip
	fi
	WINPCAP_DIR=$(cd $DOWNLOAD_DIR/WpdPack && pwd)
	return 0
}

build_target(){
	make -C $SRC_DIR CC=i686-w64-mingw32-gcc STRIP=i686-w64-mingw32-strip WINDRES=i686-w64-mingw32-windres CONFIG_STATIC=yes TARGET_OS=MinGW LIBS_BASE=$WINPCAP_DIR strip && mv $SRC_DIR/*.exe $BUILD_DIR
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
build_target
#clean_all
