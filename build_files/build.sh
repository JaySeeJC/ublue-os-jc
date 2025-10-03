#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 versionlock delete kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs kernel-uki-virt kernel-devel kernel-headers

dnf5 install -y https://github.com/jonchampagne/ublue-os-jc/releases/download/KernelSources/kernel-6.16.3_bsb_dirty-5.x86_64.rpm \
  https://github.com/jonchampagne/ublue-os-jc/releases/download/KernelSources/kernel-devel-6.16.3_bsb_dirty-5.x86_64.rpm \
  https://github.com/jonchampagne/ublue-os-jc/releases/download/KernelSources/kernel-headers-6.16.3_bsb_dirty-5.x86_64.rpm
dnf5 remove -y --no-autoremove kernel-modules kernel-modules-core kernel-modules-extra
ls /usr/lib/modules

# Ensure Initramfs is generated
export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly --kver "6.16.3-bsb-dirty" --reproducible -v --add ostree -f "/lib/modules/6.16.3-bsb-dirty/initramfs.img"
chmod 0600 "/lib/modules/6.16.3-bsb-dirty/initramfs.img"

# this installs a package from fedora repos
dnf5 install -y tmux htop btop zsh steam borgmatic

# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
