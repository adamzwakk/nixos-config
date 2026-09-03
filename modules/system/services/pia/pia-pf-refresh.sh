#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=/dev/null
. /var/lib/pia/meta
payload=$(jq -r .payload /var/lib/pia/pf.json)
signature=$(jq -r .signature /var/lib/pia/pf.json)
curl -sG --connect-to "$PF_HOSTNAME::$PF_GATEWAY:" --cacert "$CA" \
  --data-urlencode "payload=$payload" --data-urlencode "signature=$signature" \
  "https://$PF_HOSTNAME:19999/bindPort" >/dev/null