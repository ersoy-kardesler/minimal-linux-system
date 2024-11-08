#!/bin/sh
#
# Ersoy Kardesler Minimal Linux System test script
# Copyright (C) 2017-2021 John Davidson
#               2021-2023 Ercan Ersoy and Erdem Ersoy
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

qemu-system-x86_64 -nodefaults -machine q35 -m 128M -cdrom ersoy-kardesler-minimal-linux-system.iso -boot d -device VGA,bus=pcie.0 -device intel-hda,bus=pcie.0 -device hda-output
