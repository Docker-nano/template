FROM dockernano/buildroot:2014.08
MAINTAINER Your Name <em@il>

# Copy Buildroot resources.
#COPY	in/buildroot.conf	/root/buildroot/.config

# Apply Buildroot patches.
#COPY	in/patches		/root/buildroot/patches
#RUN	cd buildroot && for patch in patches/*; do patch -p0 -i "$patch"; done
