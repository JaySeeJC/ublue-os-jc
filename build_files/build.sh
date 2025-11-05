#!/bin/bash

set -ouex pipefail

### Packages needed for this script
dnf5 install jq


### Install packages
PACKAGES=(
    # Replcement kernel
    "https://github.com/JaySeeJC/ublue-os-jc/releases/download/KernelSources/kernel-6.16.10_bsb-4.x86_64.rpm"
    "https://github.com/JaySeeJC/ublue-os-jc/releases/download/KernelSources/kernel-devel-6.16.10_bsb-4.x86_64.rpm"
    "https://github.com/JaySeeJC/ublue-os-jc/releases/download/KernelSources/kernel-headers-6.16.10_bsb-4.x86_64.rpm"

    # General utilities
    "btop"
    "borgmatic"
    "du-dust"
    "exo"
    "firejail"
    "gamemode"
    "gparted"
    "gamescope"
    "yt-dlp"
    "https://cdn.devolutions.net/download/Linux/RDM/2025.3.0.8/RemoteDesktopManager_2025.3.0.8_x86_64.rpm"
    "mesa-vulkan-drivers.x86_64"

    # LACT overclocking utility
    $(curl -s https://api.github.com/repos/ilya-zlobintsev/LACT/releases/latest | jq -r ".assets[] | select(.name | endswith(\"fedora-42.rpm\")) | select(.name | contains(\"headless\") | not) | .browser_download_url")

    # For vrchat unity development
    "blender"
    "unityhub"
    "git-lfs"
    # ALCOM
    $(curl -s https://api.github.com/repos/vrc-get/vrc-get/releases | jq -r '[.[] | select(.prerelease == false)][0].assets[] | select(.name | endswith(".rpm")) | .browser_download_url')

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

# Add the unityhub repo per instructions from https://docs.unity3d.com/hub/manual/InstallHub.html
sh -c 'echo -e "[unityhub]\nname=Unity Hub\nbaseurl=https://hub.unity3d.com/linux/repos/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://hub.unity3d.com/linux/repos/rpm/stable/repodata/repomd.xml.key\nrepo_gpgcheck=0" > /etc/yum.repos.d/unityhub.repo'
rpm --import https://hub.unity3d.com/linux/repos/rpm/stable/repodata/repomd.xml.key

# Install packages
mkdir /var/opt
rm -f /usr/share/licenses/mesa-vulkan-drivers/LICENSE.dependencies
dnf5 install -y steam
dnf5 install -y "${PACKAGES[@]}"
dnf5 clean all

# Move unityhub out of /var
mkdir -p /usr/opt/
mv /var/opt/unityhub /usr/opt/
ln -s /usr/opt/unityhub /opt/unityhub

# Enable LACT daemon
systemctl enable lactd

# Regenerate the initramfs
export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly --kver "6.16.10-bsb" --reproducible -v --add ostree -f "/lib/modules/6.16.10-bsb/initramfs.img"
chmod 0600 "/lib/modules/6.16.10-bsb/initramfs.img"

