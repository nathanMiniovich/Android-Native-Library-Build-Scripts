#!/bin/bash

export NDK= (add ndk path here)

cd curl-7.43.0 && mkdir android-archs
cd ..

function buildLibs(){

         $NDK/build/tools/make-standalone-toolchain.sh \
         --platform=android-21 \
         --install-dir=./curl-chain_$1 \
         --toolchain=$2 \

         export PATH=`pwd`/curl-chain_$1/bin:.:$PATH
         export SYSROOT=`pwd`/curl-chain_$1/sysroot
         export CC="$3-gcc --sysroot $SYSROOT"

         # Configure
         cd curl-7.43.0 && mkdir android-archs/build_$1
         ./configure --prefix=$(pwd)/android-archs/build_$1 \
         --host=$3 \
         --disable-shared \
	 --without-zlib --without-ssl --without-dnutls --without-libmetalink \
	 --without-libssh2 \
	 --without-libtrmp --without-nghttp2 --without-libidn \
	 --disable-sspi --disable-crypto-auth --disable-ntlm-web --disable-tls-srp \
	 --disable-ftp --disable-file --disable-ldap --disable-ldaps --disable-imap \
	 --disable-smb --disable-telnet --disable-tftp --disable-pop3 --disable-imap \
	 --enable-proxy \
	 --disable-threaded-resolver \
         CFLAGS="$4"

         push include
         make
         popd

         # Build and install
         make clean
         make && make install

         cd ..
}

buildLibs androideabiv7a arm-linux-androideabi-4.9 arm-linux-androideabi -march=armv7-a
buildLibs androideabi arm-linux-androideabi-4.9 arm-linux-androideabi "-minline-thumb1-jumptable -march=armv5te"
buildLibs mips mipsel-linux-android-4.9 mipsel-linux-android -g
buildLibs x86 x86-4.9 i686-linux-android -g
buildLibs x86_64 x86_64-4.9 x86_64-linux-android -g
buildLibs aarch64 aarch64-linux-android-4.9 aarch64-linux-android -march=armv8-a

