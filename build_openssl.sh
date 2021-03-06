#!/bin/bash

#It is recommended to install this patch: http://www.linuxfromscratch.org/blfs/view/svn/postlfs/openssl.html

export NDK= (add ndk path here)

mkdir openssl-android-archs

function buildLibs(){

         $NDK/build/tools/make-standalone-toolchain.sh \
         --platform=android-21 \
         --install-dir=./openssl-chain_$1 \
         --toolchain=$2 \

         export PATH=`pwd`/openssl-chain_$1/bin:.:$PATH
         export SYSROOT=`pwd`/openssl-chain_$1/sysroot
         export CC="$3-gcc --sysroot $SYSROOT"

         # Configure
         mkdir -p openssl-android-archs/build_$1 && cd openssl-1.0.2c
         ./Configure $5 no-shared no-thread -fPIC -DOPENSSL_PIC --prefix=$(pwd)/../openssl-android-archs/build_$1 
#        CFLAGS="$4" "REMOVED" C-flags cause a conflict with with android architecture packages when running configure

         # Build and install
         make clean
         make && make install

         cd ..
}

buildLibs androideabiv7a arm-linux-androideabi-4.9 arm-linux-androideabi -march=armv7-a android-armv7
buildLibs androideabi arm-linux-androideabi-4.9 arm-linux-androideabi "-minline-thumb1-jumptable -march=armv5te" android
buildLibs mips mipsel-linux-android-4.9 mipsel-linux-android -g android-mips
buildLibs x86 x86-4.9 i686-linux-android -g android-x86

#64 bit builds not working yet
#buildLibs x86_64 x86_64-4.9 x86_64-linux-android -g android-x86_64
#buildLibs aarch64 aarch64-linux-android-4.9 aarch64-linux-android -march=armv8-a android-armv8

