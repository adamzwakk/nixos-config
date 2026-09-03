#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=/dev/null
. /var/lib/pia/meta

sig=$(curl -sG --connect-to "$PF_HOSTNAME::$PF_GATEWAY:" --cacert "$CA" \
  --data-urlencode "token=$PIA_TOKEN" \
  "https://$PF_HOSTNAME:19999/getSignature")
[ "$(jq -r .status <<<"$sig")" = "OK" ] || { echo "$sig" >&2; exit 1; }

payload=$(jq -r .payload <<<"$sig")
signature=$(jq -r .signature <<<"$sig")
port=$(base64 -d <<<"$payload" | jq -r .port)

umask 077
printf '%s' "$port" > /var/lib/pia/port
jq -n --arg p "$payload" --arg s "$signature" \
  '{payload:$p,signature:$s}' > /var/lib/pia/pf.json

curl -sG --connect-to "$PF_HOSTNAME::$PF_GATEWAY:" --cacert "$CA" \
  --data-urlencode "payload=$payload" --data-urlencode "signature=$signature" \
  "https://$PF_HOSTNAME:19999/bindPort" >/dev/null

iptables -I INPUT -p tcp --dport "$port" -j ACCEPT
iptables -I INPUT -p udp --dport "$port" -j ACCEPT