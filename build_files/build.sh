#!/bin/bash

set -ouex pipefail

### Install packages
PACKAGES=(
    # Replcement kernel
    "https://fs.cameo.ninja/kernel-6.16.10_bsb-4.x86_64.rpm"
    "https://fs.cameo.ninja/kernel-devel-6.16.10_bsb-4.x86_64.rpm"
    "https://fs.cameo.ninja/kernel-headers-6.16.10_bsb-4.x86_64.rpm"

    # General utilities
    "btop"
    "borgmatic"

    # Required for envision build dependencies
    "cargo"
    "cmake"
    "eigen3-devel"
    "gcc-c++"
    "glslang-devel"
    "glslc"
    "libbsd-devel"
    "clang19-devel"
    "libdrm-devel"
    "mesa-libGL-devel"
    "systemd-devel"
    "libusb1"
    "libusb1-devel"
    "libX11-devel"
    "libxcb-devel"
    "libXrandr-devel"
    "ninja-build"
    "openxr-devel"
    "SDL2-devel"
    "vulkan-devel"
    "vulkan-loader-devel"
    "wayland-devel"
    "wayland-protocols-devel"
)

# Remove the vanilla kernel
dnf5 versionlock delete kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs kernel-uki-virt kernel-devel kernel-headers
dnf5 remove -y --no-autoremove kernel-modules kernel-modules-core kernel-modules-extra

# Install packages
dnf5 install -y "${PACKAGES[@]}"
dnf5 clean all

# Regenerate the initramfs
export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly --kver "6.16.10-bsb" --reproducible -v --add ostree -f "/lib/modules/6.16.10-bsb/initramfs.img"
chmod 0600 "/lib/modules/6.16.10-bsb/initramfs.img"

