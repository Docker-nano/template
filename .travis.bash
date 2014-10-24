#!/bin/bash

BUILDROOT_RELEASE=2014.08

cd ~

# Install dependencies.
apt-get update && DEBIAN_FRONTEND=noninteractive\
	apt-get install -y build-essential libncurses5-dev rsync cpio python unzip bc wget

# Install Buildroot.
wget -nv http://buildroot.uclibc.org/downloads/buildroot-$BUILDROOT_RELEASE.tar.bz2 &&\
	tar xf buildroot-*.tar* &&\
	rm buildroot-*.tar* &&\
	ln -s buildroot-* buildroot

(
	cd buildroot

	# Create rootfs overlay.
	mkdir -vpm775 rootfs_overlay/srv

	# Download and configure post-build script.
	wget -nv https://raw.githubusercontent.com/Docker-nano/Buildroot/$BUILDROOT_RELEASE/in/post_build.sh &&\
		chmod -v +x post_build.sh
)

# Install toolchain.
wget -nv https://github.com/Docker-nano/crosstool-NG/releases/download/1.0.1/x86_64-nano-linux-uclibc.tar.xz &&\
	tar xf *.tar* &&\
	ln -s "$(tar tf *.tar* | head -1)" toolchain &&\
	rm *.tar*

cd -

cp	in/buildroot.conf		~/buildroot/.config
