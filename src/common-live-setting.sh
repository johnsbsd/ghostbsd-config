#!/bin/sh

set -e -u

if [ -z "${LOGFILE:-}" ] ; then
  echo "This script can't run standalone."
  echo "Please use launch.sh to execute it."
  exit 1
fi

mkdir -p /usr/local/share/ghostbsd
cp -R src/common-live-settings /usr/local/share/ghostbsd


backup_freebsd()
{
  # backup files from etc
  for tocopy in $(ls /usr/local/share/ghostbsd/common-live-settings/base/override/etc/rc.d) ; do
    if [ -f /etc/rc.d/$tocopy ]; then
      cp -Rf /etc/rc.d/$tocopy /usr/local/share/ghostbsd/common-live-settings/base/backup/etc/rc.d/
    fi
  done
}

freebsd_overrides()
{
  cp -Rf /usr/local/share/ghostbsd/common-live-settings/base/override/root/* /root
  cp -Rf /usr/local/share/ghostbsd/common-live-settings/base/override/etc/* /etc
  # rebuild login database because one override was login.conf
  chroot  cap_mkdb /etc/login.conf
}

copy_files_in()
{
  cp -Rf /usr/local/share/ghostbsd/common-live-settings/etc/* /etc
}


backup_freebsd
freebsd_overrides
copy_files_in
