# Ersoy Kardeşler Minimal Linux System

A minimal Linux-libre system build script based on [Minimal Linux Script](https://github.com/ivandavidov/minimal-linux-script).

Copyright (c) 2016-2021 John Davidson

Copyright (c) 2021-2024 Ercan Ersoy and Erdem Ersoy

The source bundles are downloaded and compiled automatically. The script requires host toolchain.

If you are using [Debian](https://www.debian.org) or [Pardus](https://www.pardus.org.tr), you should be able to resolve all build dependencies by executing the following command:

    sudo apt install wget make gawk gcc bc bison flex kbd xorriso libelf-dev libssl-dev libncurses-dev libmpg123-dev qemu-system-x86

The script doesn't require root privileges. In the end you should have a bootable ISO image named `ersoy-kardesler-minimal-linux-system.iso` in the same directory where you executed the script.

## License

Everything except Linux and BusyBox configs are licensed with GPLv3. The Linux and BusyBox configs are licensed in GPLv2.

## Note

Author of the test.mp3 file is cynicmusic. ThiS music asset are "Awake! (Megawall-10)". This published as public domain.

