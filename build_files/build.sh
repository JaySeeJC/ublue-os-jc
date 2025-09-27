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

# Set up system flatpaks
mkdir -p /usr/etc/ublue-os
echo '
org.kde.kcalc
org.kde.gwenview
org.kde.kontact
org.kde.okular
org.kde.kweather
org.kde.kclock
org.fkoehler.KTailctl
org.kde.haruna
com.github.tchx84.Flatseal
com.ranfdev.DistroShelf
io.github.flattool.Warehouse
io.missioncenter.MissionCenter
io.github.input_leap.input-leap
org.gtk.Gtk3theme.Breeze
io.github.pwr_solaar.solaar
org.gustavoperedo.FontDownloader
org.kde.skanpage
app.zen_browser.zen
com.devolutions.remotedesktopmanager
dev.vencord.Vesktop
com.spotify.Client
md.obsidian.Obsidian
org.telegram.desktop
' > /usr/etc/ublue-os/system-flatpaks.list

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
