#!/bin/bash -x

export NDK= (add ndk path here)

cd c-ares-1.10.0 && mkdir android-archs
cd ..

function buildLibs(){

	$NDK/build/tools/make-standalone-toolchain.sh \
	--platform=android-21 \
	--install-dir=./ares-chain_$1 \
	--toolchain=$2 \

	export PATH=`pwd`/ares-chain_$1/bin:.:$PATH
	export SYSROOT=`pwd`/ares-chain_$1/sysroot
	export CC="$3-gcc --sysroot $SYSROOT"

	# Configure
	cd c-ares-1.10.0 && mkdir android-archs/build_$1
	./configure --prefix=$(pwd)/android-archs/build_$1 \
	--host=$3 \
	--disable-shared \
	CFLAGS="$4"

	# Build and install
	make clean
	make && make install

	cd ..
}

buildLibs aarch64 aarch64-linux-android-4.9 aarch64-linux-android -march=armv8-a+crc
buildLibs androideabiv7a arm-linux-androideabi-4.9 arm-linux-androideabi -march=armv7-a
buildLibs androideabi arm-linux-androideabi-4.9 arm-linux-androideabi "-minline-thumb1-jumptable -march=armv5te"
buildlibs mips mipsel-linux-android-4.9 mipsel-linux-android -g
buildlibs x86_64 x86_64-4.9 x86_64-linux-android -g
buildlibs x86 x86-4.9 i686-linux-android -g
