#!/bin/sh

set -e -u

if [ -z "${LOGFILE:-}" ]; then
  echo "This script can't run standalone."
  echo "Please use launch.sh to execute it."
  exit 1
fi

if [ ! -f "/usr/local/bin/git" ]; then
  echo "Install Git to fetch pkg from GitHub"
  exit 1
fi

# Installing pc-sysinstall and ghostbsd installer
if [ ! -d pc-sysinstall ]; then
  echo "Downloading pcbsd tools from GitHub"
  git clone https://github.com/trueos/pc-sysinstall.git >/dev/null 2>&1
fi

cd pc-sysinstall
sh install.sh >/dev/null 2>&1

cd ..

rm -rf pc-sysinstall

