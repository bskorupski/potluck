#!/bin/sh

# shellcheck disable=SC1091
. /root/.env.cook

set -e
# shellcheck disable=SC3040
set -o pipefail

export PATH=/usr/local/bin:$PATH

echo "server:
        local-zone: active.vault.service.consul typetransparent
        local-data: \"active.vault.service.consul A $1\"
" >/etc/unbound/conf.d/vault-static.conf

service local_unbound enable || true
service local_unbound restart || true