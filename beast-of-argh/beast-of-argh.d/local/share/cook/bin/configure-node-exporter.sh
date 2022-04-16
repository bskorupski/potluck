#!/bin/sh

# shellcheck disable=SC1091
. /root/.env.cook

set -e

# add node_exporter user

if ! id -u "nodeexport" >/dev/null 2>&1; then
  /usr/sbin/pw useradd -n nodeexport -c 'nodeexporter user' -m -s /usr/bin/nologin -h -
fi

# enable node_exporter service
service node_exporter enable
sysrc node_exporter_args="--log.level=warn"
sysrc node_exporter_user=nodeexport
sysrc node_exporter_group=nodeexport
echo "node_exporter_listen_address=\"$IP:9100\"" >> /etc/rc.conf
