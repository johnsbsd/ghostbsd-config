#!/bin/sh
#
# Copyright (c) 2011 GhostBSD
#
# See COPYING for licence terms.
#
# autologin.sh,v 1.2_1 Monday, January 31 2011 01:06:12 Eric
#
# Enable autologin of the $GHOSTBSD_ADDUSER user on the first terminal
#

GHOSTBSD_ADDUSER=${GHOSTBSD_ADDUSER:-"liveuser"}

echo "# ${GHOSTBSD_ADDUSER} user autologin" >> /etc/gettytab
echo "${GHOSTBSD_ADDUSER}:\\" >> /etc/gettytab
echo ":al=${GHOSTBSD_ADDUSER}:ht:np:sp#115200:" >> /etc/gettytab

sed -i "" "/ttyv0/s/Pc/${GHOSTBSD_ADDUSER}/g" /etc/ttys
#echo "sh sysconfig.sh" >> /root/.login
echo "startx" >> /ghostbsd/.login
#echo 'if ($tty == ttyv0) then' >> /home/ghostbsd/.cshrc
#echo 'if ($tty == ttyv0) then' >> /home/ghostbsd/.shrc
#echo "  sudo netcardmgr" >> /home/ghostbsd/.cshrc
#echo "  startx" >> /home/ghostbsd/.cshrc
#echo "  startx" >> /home/ghostbsd/.shrc
#echo "endif" >> /home/ghostbsd/.cshrc
#echo "endif" >> /home/ghostbsd/.shrc

