#!/bin/bash

${TRAVIS_BUILD_DIR:="$PWD"}

# Detect Buildroot release tag.
buildroot-release() {
	grep -Pxm1 'FROM\s+[^:]+:\d{4}\.\d\d' "$TRAVIS_BUILD_DIR"/Dockerfile | cut -d: -f2
}

cd ~

# Install dependencies.
apt-get update && DEBIAN_FRONTEND=noninteractive\
	apt-get install -y build-essential libncurses5-dev rsync cpio python unzip bc wget

# Install Buildroot.
wget -nv http://buildroot.uclibc.org/downloads/buildroot-$(buildroot-release).tar.bz2 &&\
	tar xf buildroot-*.tar* &&\
	rm buildroot-*.tar* &&\
	ln -s buildroot-* buildroot

# Install toolchain.
wget -nv https://github.com/Docker-nano/crosstool-NG/releases/download/1.0.1/x86_64-nano-linux-uclibc.tar.xz &&\
	tar xf *.tar* &&\
	ln -s "$(tar tf *.tar* | head -1)" toolchain &&\
	rm *.tar*

cd -

# Copy Buildroot resources.
cp	-vl in/buildroot.conf	~/buildroot/.config
cp	-vla in/rootfs_overlay	~/buildroot
cp	-vlr in/patches			~/buildroot

# Configure Buildroot.
cd ~/buildroot

# Create rootfs overlay.
mkdir -vpm775 rootfs_overlay/srv

# Download and configure post-build script.
wget -nv https://raw.githubusercontent.com/Docker-nano/Buildroot/$(buildroot-release)/in/post_build.sh &&\
	chmod -v +x post_build.sh

# Apply patches.
(shopt -s nullglob && for patch in patches/*; do patch -p0 -i "$patch"; done)
