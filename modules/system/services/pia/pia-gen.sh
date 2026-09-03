#!/usr/bin/env bash
set -euo pipefail
REGION="nl_amsterdam"
OUT="/var/lib/pia/wg.conf"

servers=$(curl -s https://serverlist.piaservers.net/vpninfo/servers/v4 | head -1)
region=$(echo "$servers" | jq -r --arg r "$REGION" '.regions[] | select(.id==$r)')
[ -n "$region" ] || { echo "unknown region"; exit 1; }

meta_ip=$(echo "$region" | jq -r '.servers.meta[0].ip')
meta_cn=$(echo "$region" | jq -r '.servers.meta[0].cn')
wg_ip=$(echo "$region"  | jq -r '.servers.wg[0].ip')
wg_cn=$(echo "$region"  | jq -r '.servers.wg[0].cn')

token=$(curl -s -u "$PIA_USER:$PIA_PASS" \
  --connect-to "$meta_cn::$meta_ip" --cacert "$CA" \
  "https://$meta_cn/authv3/generateToken" | jq -r '.token')

priv=$(wg genkey); pub=$(echo "$priv" | wg pubkey)

json=$(curl -s -G --connect-to "$wg_cn::$wg_ip:" --cacert "$CA" \
  --data-urlencode "pt=$token" --data-urlencode "pubkey=$pub" \
  "https://$wg_cn:1337/addKey")
[ "$(echo "$json" | jq -r .status)" = "OK" ] || { echo "$json"; exit 1; }

umask 077; mkdir -p "$(dirname "$OUT")"
cat > "$OUT" <<EOF
[Interface]
PrivateKey = $priv
Address = $(echo "$json" | jq -r '.peer_ip')/32
DNS = $(echo "$json" | jq -r '.dns_servers[0] // .server_vip')

[Peer]
PublicKey = $(echo "$json" | jq -r '.server_key')
AllowedIPs = 0.0.0.0/0
Endpoint = $wg_ip:$(echo "$json" | jq -r '.server_port')
PersistentKeepalive = 25
EOF

umask 077
cat > /var/lib/pia/meta <<EOF
PF_GATEWAY=$(echo "$json" | jq -r '.server_vip')
PF_HOSTNAME=$wg_cn
PIA_TOKEN=$token
EOF