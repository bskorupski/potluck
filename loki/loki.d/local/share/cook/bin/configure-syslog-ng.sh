#!/bin/sh

# shellcheck disable=SC1091
. /root/.env.cook

set -e
# shellcheck disable=SC3040
set -o pipefail

export PATH=/usr/local/bin:$PATH

SCRIPT=$(readlink -f "$0")
TEMPLATEPATH=$(dirname "$SCRIPT")/../templates

# shellcheck disable=SC3003
# safe(r) separator for sed
sep=$'\001'

# copy in syslog-ng.conf
< "$TEMPLATEPATH/syslog-ng.conf.in" \
  sed "s${sep}%%myip%%${sep}$IP${sep}g" \
  > /usr/local/etc/syslog-ng.conf

# create remote log dir
mkdir -p /mnt/log/remote

# stop and disable syslogd
service syslogd onestop || true
service syslogd disable

# enable and start syslog-ng
service syslog-ng enable
#sysrc syslog_ng_flags="-u daemon"
sysrc syslog_ng_flags="-R /tmp/syslog-ng.persist"
service syslog-ng start
