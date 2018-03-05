#!/bin/sh

base_overrides()
{
  cp -R src/common-base-setting/override/* /
}


patch_etc_files()
{
  cat src/common-base-setting/patches/boot/loader.conf.src >> /boot/loader.conf
  cat src/common-base-setting/patches/etc/profile.src >> /etc/profile
  cat src/common-base-setting/patches/etc/devfs.rules.src >> /etc/devfs.rules
  cat src/common-base-setting/patches/etc/make.conf.src >> /etc/make.conf
  cat src/common-base-setting/patches/etc/rc.conf.src >> /etc/rc.conf
  cat src/common-base-setting/patches/etc/devd.conf.src >> /etc/devd.conf
  cat src/common-base-setting/patches/etc/sysctl.conf.src >> /etc/sysctl.conf
  cat src/common-base-setting/patches/etc/fstab.src >> /etc/fstab
}

local_files()
{
  # cp src/common-base-setting/etc/grub.d/10_kghostbsd /usr/local/etc/grub.d/10_kghostbsd
  #sed -i "" -e 's/"\/usr\/local\/sbin\/beadm"/"\/usr\/local\/etc\/grub.d\/10_kghostbsd"/g' /usr/local/etc/grub.d/10_kfreebsd
  # Adding kern.vty=vt to 10_kfreebsd
  sed -i '' '/set kFreeBSD.vfs.root.mountfrom.options=rw/a\
\	set kFreeBSD.kern.vty=vt\
\	set kFreeBSD.hw.psm.synaptics_support="1"\
' /usr/local/etc/grub.d/10_kfreebsd
  # Replassing FreeBSD by GhostBSD
  sed -i '' 's/"FreeBSD"/"GhostBSD"/g' /usr/local/etc/grub.d/10_kfreebsd
}

packages_settings()
{
  #set htmlview alternative to firefox for cups
  if [ -e /usr/local/bin/firefox ] ; then
    update-alternatives --altdir /usr/local/etc/alternatives --install /usr/local/bin/htmlview htmlview /usr/local/bin/firefox 50
  fi
}

# copy files from override to FreeBSD base system
base_overrides
# patch files from etc
patch_etc_files
# apply packages settings
#packages_settings
local_files

