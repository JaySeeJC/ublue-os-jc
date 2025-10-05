#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 versionlock delete kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs kernel-uki-virt kernel-devel kernel-headers

dnf5 install -y https://github.com/JaySeeJC/ublue-os-jc/releases/download/KernelSources/kernel-6.16.10_bsb-4.x86_64.rpm \
  https://github.com/JaySeeJC/ublue-os-jc/releases/download/KernelSources/kernel-devel-6.16.10_bsb-4.x86_64.rpm \
  https://github.com/JaySeeJC/ublue-os-jc/releases/download/KernelSources/kernel-headers-6.16.10_bsb-4.x86_64.rpm
dnf5 remove -y --no-autoremove kernel-modules kernel-modules-core kernel-modules-extra
# Ensure Initramfs is generated
export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly --kver "6.16.10-bsb" --reproducible -v --add ostree -f "/lib/modules/6.16.10-bsb/initramfs.img"
chmod 0600 "/lib/modules/6.16.10-bsb/initramfs.img"

# Install various packages
dnf5 install -y \
  tmux htop btop zsh steam borgmatic \ # General utilities
  cargo cmake eigen3-devel gcc-c++ glslang-devel \ # Required for envision build dependencies
  glslc libbsd-devel clang19-devel libdrm-devel \
  mesa-libGL-devel systemd-devel libusb1 libusb1-devel \
  libX11-devel libxcb-devel libxcb-devel libXrandr-devel \
  mesa-libGL-devel ninja-build openxr-devel SDL2-devel \
  vulkan-devel vulkan-loader-devel wayland-devel \
  wayland-devel wayland-protocols-devel

