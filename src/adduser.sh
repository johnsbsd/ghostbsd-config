#!/bin/sh
#
# Copyright (c) 2011 Dario Freni
#
# See COPYRIGHT for licence terms.
#
# adduser.sh,v 1.5_1 Friday, January 14 2011 13:06:55

set -e -u

if [ -z "${LOGFILE:-}" ]; then
    echo "This script can't run standalone."
    echo "Please use launch.sh to execute it."
    exit 1
fi

su liveuser -c /usr/local/share/ghostbsd/common-live-settings/config-live-settings
