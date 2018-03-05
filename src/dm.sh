#!/bin/sh

set -e -u

if [ -z "${LOGFILE:-}" ] ; then
  echo "This script can't run standalone."
  echo "Please use launch.sh to execute it."
  exit 1
fi

lightdm_setup()
{
  if [ -f /usr/local/etc/lightdm/lightdm.conf ] ; then
    sed -i "" '/#exit-on-failure=false/a\
autologin-user=liveuser\
autologin-user-timeout=0\
' /usr/local/etc/lightdm/lightdm.conf
  fi

  if [ -f /usr/local/etc/lightdm/lightdm-gtk-greeter.conf ] ; then
    echo "background=/usr/local/share/backgrounds/ghostbsd/White-Trees-Empire.jpg" >> /usr/local/etc/lightdm/lightdm-gtk-greeter.conf
    echo "user-background=true" >> /usr/local/etc/lightdm/lightdm-gtk-greeter.conf
    #echo "theme-name=Ambiance-Blackout-Flat-Aqua" >> /usr/local/etc/lightdm/lightdm-gtk-greeter.conf
    #echo "icon-theme-name=Vivacious-Colors-Full-Dark" >> /usr/local/etc/lightdm/lightdm-gtk-greeter.conf
  fi
  #echo '#lightdm_enable="NO"' >> /etc/rc.conf
}

gdm_setup()
{
  echo 'gdm_enable="YES"' >> /etc/rc.conf
}

lightdm_setup
