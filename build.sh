#!/bin/sh
#
# Ersoy Kardesler Minimal Linux System build script
# Copyright (C) 2016-2021 John Davidson
#               2021-2023 Erdem Ersoy and Ercan Ersoy
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Set script parameters
set -ex


# Linux-libre package
LINUX_LIBRE_VERSION_NOT_GNU=5.10.199
LINUX_LIBRE_VERSION=${LINUX_LIBRE_VERSION_NOT_GNU}-gnu1
LINUX_LIBRE_NAME_AND_VERSION=linux-libre-${LINUX_LIBRE_VERSION}
LINUX_LIBRE_NAME_AND_VERSION_NOT_LIBRE_AND_GNU=linux-${LINUX_LIBRE_VERSION_NOT_GNU}
LINUX_LIBRE_PACKAGE_NAME=${LINUX_LIBRE_NAME_AND_VERSION}.tar.xz
LINUX_LIBRE_PACKAGE_NAME_NOT_LIBRE_AND_GNU=${LINUX_LIBRE_NAME_AND_VERSION_NOT_LIBRE_AND_GNU}.tar.xz
LINUX_LIBRE_PACKAGE_LOCATION=http://linux-libre.fsfla.org/pub/linux-libre/releases/${LINUX_LIBRE_VERSION}/${LINUX_LIBRE_PACKAGE_NAME}


# Busybox package
BUSYBOX_VERSION=1.36.1
BUSYBOX_NAME_AND_VERSION=busybox-${BUSYBOX_VERSION}
BUSYBOX_PACKAGE_NAME=${BUSYBOX_NAME_AND_VERSION}.tar.bz2
BUSYBOX_PACKAGE_LOCATION=https://busybox.net/downloads/${BUSYBOX_PACKAGE_NAME}


# console-data (of Debian) package
CONSOLE_DATA_VERSION=1.12
CONSOLE_DATA_NAME_AND_VERSION=console-data_${CONSOLE_DATA_VERSION}
CONSOLE_DATA_NAME_AND_VERSION_2=console-data-${CONSOLE_DATA_VERSION}
CONSOLE_DATA_PACKAGE_NAME=${CONSOLE_DATA_NAME_AND_VERSION}.orig.tar.bz2
CONSOLE_DATA_PACKAGE_LOCATION=http://deb.debian.org/debian/pool/main/c/console-data/${CONSOLE_DATA_PACKAGE_NAME}


# console-setup-linux (of Debian) package
CONSOLE_SETUP_LINUX_VERSION=1.205
CONSOLE_SETUP_LINUX_NAME_AND_VERSION=console-setup_${CONSOLE_SETUP_LINUX_VERSION}
CONSOLE_SETUP_LINUX_NAME_AND_VERSION_2=console-setup-${CONSOLE_SETUP_LINUX_VERSION}
CONSOLE_SETUP_LINUX_PACKAGE_NAME=${CONSOLE_SETUP_LINUX_NAME_AND_VERSION}.tar.xz
CONSOLE_SETUP_LINUX_PACKAGE_LOCATION=http://deb.debian.org/debian/pool/main/c/console-setup/${CONSOLE_SETUP_LINUX_PACKAGE_NAME}


# NCURSES package
NCURSES_VERSION=6.4
NCURSES_NAME_AND_VERSION=ncurses-${NCURSES_VERSION}
NCURSES_PACKAGE_NAME=${NCURSES_NAME_AND_VERSION}.tar.gz
NCURSES_PACKAGE_LOCATION=https://invisible-mirror.net/archives/ncurses/${NCURSES_PACKAGE_NAME}


# GNU nano package
NANO_VERSION=7.2
NANO_NAME_AND_VERSION=nano-${NANO_VERSION}
NANO_PACKAGE_NAME=${NANO_NAME_AND_VERSION}.tar.xz
NANO_PACKAGE_LOCATION=https://www.nano-editor.org/dist/v7/${NANO_PACKAGE_NAME}


# mpg123 package
MPG123_VERSION=1.26.4
MPG123_NAME_AND_VERSION=mpg123-${MPG123_VERSION}
MPG123_PACKAGE_NAME=${MPG123_NAME_AND_VERSION}.tar.bz2
MPG123_PACKAGE_LOCATION=https://mpg123.org/download/${MPG123_PACKAGE_NAME}


# Syslinux package
SYSLINUX_VERSION=6.03
SYSLINUX_NAME_AND_VERSION=syslinux-${SYSLINUX_VERSION}
SYSLINUX_PACKAGE_NAME=${SYSLINUX_NAME_AND_VERSION}.tar.xz
SYSLINUX_PACKAGE_LOCATION=http://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/${SYSLINUX_PACKAGE_NAME}


# Make build directories
mkdir -p packages
mkdir -p packages_extracted
mkdir -p rootfs
mkdir -p isoimage


# Download packages
cd packages

wget -nc ${LINUX_LIBRE_PACKAGE_LOCATION}
wget -nc ${BUSYBOX_PACKAGE_LOCATION}
wget -nc ${CONSOLE_DATA_PACKAGE_LOCATION}
wget -nc ${CONSOLE_SETUP_LINUX_PACKAGE_LOCATION}
wget -nc ${NCURSES_PACKAGE_LOCATION}
wget -nc ${NANO_PACKAGE_LOCATION}
wget -nc ${MPG123_PACKAGE_LOCATION}
wget -nc ${SYSLINUX_PACKAGE_LOCATION}

cd ..


# Extract packages
cd packages_extracted

if [ ! -d ${LINUX_LIBRE_NAME_AND_VERSION_NOT_LIBRE_AND_GNU} ]; then tar -xvf ../packages/${LINUX_LIBRE_PACKAGE_NAME} -C .; fi
if [ ! -d ${BUSYBOX_NAME_AND_VERSION} ]; then tar -xvf ../packages/${BUSYBOX_PACKAGE_NAME} -C .; fi
if [ ! -d ${CONSOLE_DATA_NAME_AND_VERSION_2} ]; then tar -xvf ../packages/${CONSOLE_DATA_PACKAGE_NAME} -C .; fi
if [ ! -d ${CONSOLE_SETUP_LINUX_NAME_AND_VERSION_2} ]; then tar -xvf ../packages/${CONSOLE_SETUP_LINUX_PACKAGE_NAME} -C .; fi
if [ ! -d ${NCURSES_NAME_AND_VERSION} ]; then tar -xvf ../packages/${NCURSES_PACKAGE_NAME} -C .; fi
if [ ! -d ${NANO_NAME_AND_VERSION} ]; then tar -xvf ../packages/${NANO_PACKAGE_NAME} -C .; fi
if [ ! -d ${MPG123_NAME_AND_VERSION} ]; then tar -xvf ../packages/${MPG123_PACKAGE_NAME} -C .; fi
if [ ! -d ${SYSLINUX_NAME_AND_VERSION} ]; then tar -xvf ../packages/${SYSLINUX_PACKAGE_NAME} -C .; fi

cd ..


# Configure and install Linux-libre
cd packages_extracted/${LINUX_LIBRE_NAME_AND_VERSION_NOT_LIBRE_AND_GNU}

cp -T ../../configs/linux-config .config

make

cp arch/x86/boot/bzImage ../../isoimage/kernel.gz

cd ../..

# Configure and install BusyBox
cd packages_extracted/${BUSYBOX_NAME_AND_VERSION}

cp -T ../../configs/busybox-config .config

make
make busybox install

cp -r _install/* ../../rootfs

cd ../..


# Install console-data of Debian
cd packages_extracted/${CONSOLE_DATA_NAME_AND_VERSION_2}

mkdir -p ../../rootfs/usr/share/consolefonts
mkdir -p ../../rootfs/usr/share/consoletrans
mkdir -p ../../rootfs/usr/share/keymaps/i386
mkdir -p ../../rootfs/usr/share/keymaps/i386/fgGIod
mkdir -p ../../rootfs/usr/share/keymaps/i386/qwerty

cp -r consolefonts/*.psf ../../rootfs/usr/share/consolefonts
cp -r consolefonts/*.psf ../../rootfs/usr/share/consolefonts
cp -r consoletrans/* ../../rootfs/usr/share/consoletrans
loadkeys -b keymaps/i386/fgGIod/trf.kmap > ../../rootfs/usr/share/keymaps/i386/fgGIod/trf.bmap
loadkeys -b keymaps/i386/fgGIod/tr_f-latin5.kmap > ../../rootfs/usr/share/keymaps/i386/fgGIod/tr_f-latin5.bmap
loadkeys -b keymaps/i386/fgGIod/trfu.kmap > ../../rootfs/usr/share/keymaps/i386/fgGIod/trfu.bmap
loadkeys -b keymaps/i386/qwerty/tralt.kmap > ../../rootfs/usr/share/keymaps/i386/qwerty/tralt.bmap
loadkeys -b keymaps/i386/qwerty/trq.kmap > ../../rootfs/usr/share/keymaps/i386/qwerty/trq.bmap
loadkeys -b keymaps/i386/qwerty/tr_q-latin5.kmap > ../../rootfs/usr/share/keymaps/i386/qwerty/tr_q-latin5.bmap
loadkeys -b keymaps/i386/qwerty/trqu.kmap > ../../rootfs/usr/share/keymaps/i386/qwerty/trqu.bmap
loadkeys -b keymaps/i386/qwerty/us.kmap > ../../rootfs/usr/share/keymaps/i386/qwerty/us.bmap
loadkeys -b keymaps/i386/qwerty/us-intl.iso01.kmap > ../../rootfs/usr/share/keymaps/i386/qwerty/us-intl.iso01.bmap
loadkeys -b keymaps/i386/qwerty/us-intl.iso15.kmap > ../../rootfs/usr/share/keymaps/i386/qwerty/us-intl.iso15.bmap
loadkeys -b keymaps/i386/qwerty/us-latin1.kmap > ../../rootfs/usr/share/keymaps/i386/qwerty/us-latin1.bmap

cd ../..

# Install console-setup-linux of Debian
cd packages_extracted/${CONSOLE_SETUP_LINUX_NAME_AND_VERSION_2}

make gzipped_linux_fonts

mkdir -p ../../rootfs/usr/share/consolefonts

cp -r Fonts/*.psf.gz ../../rootfs/usr/share/consolefonts

cd ../..

# Configure and install NCURSES
cd packages_extracted/${NCURSES_NAME_AND_VERSION}

LDFLAGS=-static ./configure --prefix=$(pwd)/_install/usr
make
make install.data

cp -r _install/* ../../rootfs

cd ../..


# Configure and install GNU nano
cd packages_extracted/${NANO_NAME_AND_VERSION}

LDFLAGS=-static ./configure --prefix=$(pwd)/_install/
make
make install

cp -r _install/* ../../rootfs

cd ../..


# Configure and install MPG123
cd packages_extracted/${MPG123_NAME_AND_VERSION}

LDFLAGS=-static ./configure --enable-static --prefix=$(pwd)/_install/usr
make
make install

cp -r _install/* ../../rootfs

cd ../..


# Prepare root filesystem with some changes
cd rootfs

mkdir -p dev etc proc/sys/kernel sys tmp var/cache var/lock var/log var/spool var/tmp

cp -r ../rootfs_overlay/* .


## Add /etc/group
echo 'root:x:0:' > etc/group
echo 'daemon:x:1:' >> etc/group


## Add /etc/hostname
echo 'minimal' > etc/hostname


## Add /etc/inittab
echo '::sysinit:/bin/dmesg -n 5' > etc/inittab
echo '::sysinit:/bin/mount -t proc proc /proc' >> etc/inittab
echo '::sysinit:/bin/mount -t sysfs sysfs /sys' >> etc/inittab
echo '::sysinit:/bin/mount -t tmpfs -o size=64m tmp_files /tmp' >> etc/inittab
echo '::sysinit:/bin/ln -s /tmp /var/cache' >> etc/inittab
echo '::sysinit:/bin/ln -s /tmp /var/lock' >> etc/inittab
echo '::sysinit:/bin/ln -s /tmp /var/log' >> etc/inittab
echo '::sysinit:/bin/ln -s /tmp /var/run' >> etc/inittab
echo '::sysinit:/bin/ln -s /tmp /var/spool' >> etc/inittab
echo '::sysinit:/bin/ln -s /tmp /var/tmp' >> etc/inittab
echo '::sysinit:/bin/mount -t devtmpfs devtmpfs /dev' >> etc/inittab
echo '::sysinit:/bin/echo /sbin/mdev > /proc/sys/kernel/hotplug' >> etc/inittab
echo '::sysinit:/sbin/mdev -s' >> etc/inittab
echo '::sysinit:/bin/hostname -F /etc/hostname' >> etc/inittab
echo '::respawn:/sbin/syslogd -n' >> etc/inittab
echo '::respawn:/sbin/klogd -n' >> etc/inittab
echo '::respawn:/sbin/getty 115200 console' >> etc/inittab


## Add /etc/mdev.conf
echo 'console root:root 600' > etc/mdev.conf
echo 'null root:root 666' >> etc/mdev.conf
echo 'random root:root 444' >> etc/mdev.conf
echo 'urandom root:root 444' >> etc/mdev.conf


## Add /etc/motd
echo '***********************************' > etc/motd
echo '*                                 *' >> etc/motd
echo '* Welcome to Minimal Linux System *' >> etc/motd
echo '*                                 *' >> etc/motd
echo '***********************************' >> etc/motd


## Add /etc/passwd
echo 'root:x:0:0:root:/root:/bin/sh' > etc/passwd
echo 'daemon:x:1:1:daemon:/usr/sbin:/bin/false' >> etc/passwd


## Add /etc/profile
echo '#!/bin/sh' > etc/profile
echo 'export TERM=linux' >> etc/profile

chmod +x etc/profile


## Add /etc/shadow
echo 'root::10933:0:99999:7:::' > etc/shadow
echo 'daemon:*:10933:0:99999:7:::' >> etc/shadow

chmod 0600 etc/shadow


# Package root filesystem and copy root filesystem to ISO filesystem

find ./* | cpio -R root:root -H newc -o | gzip > ../isoimage/rootfs.gz

cd ..


# Copy ISOLINUX files to ISO filesystem and Make ISOcd 
cd packages_extracted/${SYSLINUX_NAME_AND_VERSION}

cp bios/core/isolinux.bin ../../isoimage
cp bios/com32/elflink/ldlinux/ldlinux.c32 ../../isoimage
cp bios/com32/libutil/libutil.c32 ../../isoimage
cp bios/com32/menu/menu.c32 ../../isoimage

cp ../../configs/isolinux.cfg ../../isoimage/isolinux.cfg

xorriso -as mkisofs -o ../../ersoy-kardesler-minimal-linux-system.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 20 -boot-info-table ../../isoimage

cd ../..


# Re-set script parameters
set +ex

