#!/bin/sh
#
# Copyright (c) 2011 GhostBSD
#
# See COPYING for license terms.
#
# finalize.sh,v 1.0 Wed 17 Jun 19:42:49 ADT 2015cd  Ovidiu Angelescu
#

set -e -u

if [ -z "${LOGFILE:-}" ] ; then
  echo "This script can't run standalone."
  echo "Please use launch.sh to execute it."
  exit 1
fi

clean_desktop_files()
{
# Remove Gnome and Mate from ShowOnly in *.desktop
# needed for update-station
  DesktopBSD=`ls /usr/local/share/applications/ | grep -v libreoffice | grep -v kde4 | grep -v screensavers`
  for desktop in $DesktopBSD; do
    sed -i "" -e 's/OnlyShowIn=Gnome;//g' /usr/local/share/applications/$desktop
    sed -i "" -e 's/OnlyShowIn=MATE;//g' /usr/local/share/applications/$desktop
    sed -i "" -e 's/GNOME;//g' /usr/local/share/applications/$desktop
    sed -i "" -e 's/MATE;//g' /usr/local/share/applications/$desktop
    sed -i "" -e 's/OnlyShowIn=//g' /usr/local/share/applications/$desktop
  done
}

default_ghostbsd_rc_conf()
{
  cp  /etc/rc.conf /etc/rc.conf.ghostbsd
}

set_sudoers()
{
  sed -i "" -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /usr/local/etc/sudoers
  sed -i "" -e 's/# %sudo/%sudo/g' /usr/local/etc/sudoers
}

dot_xinitrc()
{

if [ "${PACK_PROFILE}" == "mate" ] ; then
  echo "exec ck-launch-session mate-session" > /usr/home/ghostbsd/.xinitrc
  echo "exec ck-launch-session mate-session" > /root/.xinitrc
elif [ "${PACK_PROFILE}" == "xfce" ] ; then
  echo "exec ck-launch-session startxfce4" > /usr/home/ghostbsd/.xinitrc
  echo "exec ck-launch-session startxfce4" > /root/.xinitrc
fi
}

set_doas()
{
  printf "permit nopass keepenv root
permit :wheel
permit nopass keepenv :wheel cmd netcardmgr
permit nopass keepenv :wheel cmd ifconfig
permit nopass keepenv :wheel cmd service
permit nopass keepenv :wheel cmd wpa_supplicant
permit nopass keepenv :wheel cmd fbsdupdatecheck
permit nopass keepenv :wheel cmd fbsdpkgupdate
permit nopass keepenv :wheel cmd pkg args upgrade -y
permit nopass keepenv :wheel cmd pkg args upgrade -Fy
permit nopass keepenv :wheel cmd pkg args lock
permit nopass keepenv :wheel cmd pkg args unlock
permit nopass keepenv :wheel cmd mkdir args -p /var/db/update-station/
permit nopass keepenv :wheel cmd chmod args -R 665 /var/db/update-station/
permit nopass keepenv :wheel cmd sh args /usr/local/lib/update-station/cleandesktop.sh
permit nopass keepenv :wheel cmd shutdown args -r now
" > /usr/local/etc/doas.conf
}

vmware_supports()
{
  printf 'Section "ServerFlags"
Option "AutoAddDevices" "false"
EndSection
Section "InputDevice"
Identifier "Mouse0"
Driver "vmmouse"
Option "Device" "/dev/sysmouse"
EndSection' > /usr/local/etc/X11/xorg.conf.d/vmware.conf

  printf 'vmware_guest_vmblock_enable="YES"
vmware_guest_vmhgfs_enable="YES"
vmware_guest_vmmemctl_enable="YES"
vmware_guest_vmxnet_enable="YES"
vmware_guestd_enable="YES"' > /etc/rc.conf.d/vmware.conf
}

clean_desktop_files
default_ghostbsd_rc_conf
set_sudoers
dot_xinitrc
set_doas
vmware_supports