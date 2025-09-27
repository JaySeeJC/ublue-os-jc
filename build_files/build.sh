#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

#rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-extra kernel-modules-core 'kmod-*'
#rpm-ostree install https://github.com/jonchampagne/ublue-os-jc/releases/download/KernelSources/kernel-6.16.3_bsb_dirty-5.x86_64.rpm https://github.com/jonchampagne/ublue-os-jc/releases/download/KernelSources/kernel-devel-6.16.3_bsb_dirty-5.x86_64.rpm https://github.com/jonchampagne/ublue-os-jc/releases/download/KernelSources/kernel-headers-6.16.3_bsb_dirty-5.x86_64.rpm

# this installs a package from fedora repos
dnf5 install -y tmux htop btop zsh steam borgmatic

# Install various flatpaks
mkdir /var/roothome
flatpak install --noninteractive --system app.zen_browser.zen
flatpak install --noninteractive --system com.devolutions.remotedesktopmanager
flatpak install --noninteractive --system dev.vencord.Vesktop
# flatpak install --assumeyes --system com.spotify.Client
flatpak install --noninteractive --system md.obsidian.Obsidian
flatpak install --noninteractive --system org.telegram.desktop

# Remove unwanted flatpaks
#flatpak uninstall --assumeyes --system org.mozilla.firefox
#flatpak uninstall --assumeyes --system org.mozilla.Thunderbird

# Install orcaslicer since it's not on flathub
wget -O orcaslicer.flatpak https://github.com/SoftFever/OrcaSlicer/releases/download/v2.3.1-beta/OrcaSlicer-Linux-flatpak_V2.3.1-beta_x86_64.flatpak
flatpak install --assumeyes --system orcaslicer.flatpak
rm orcaslicer.flatpak

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
