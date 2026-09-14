#!/usr/bin/env bash
# Brings up the docker compose stack and works around a networking quirk seen
# on some Codespace/dev container hosts: Docker programs its per-network
# container-to-container forwarding rule into iptables-nft, but the kernel
# actually enforces iptables-legacy (FORWARD policy DROP there). Containers
# can then resolve each other's DNS name but every packet between them is
# dropped, so pgAdmin can never reach Postgres even though both are "Up".
# This detects that case and adds the missing rule if needed.
set -e

cd "$(dirname "$0")/.."

docker compose up -d

if command -v iptables-legacy >/dev/null 2>&1; then
  CID=$(docker compose ps -q db 2>/dev/null || true)
  if [ -n "$CID" ]; then
    NET_NAME=$(docker inspect "$CID" --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}}{{end}}' 2>/dev/null || true)
    if [ -n "$NET_NAME" ]; then
      NET_ID=$(docker network inspect "$NET_NAME" -f '{{.Id}}' 2>/dev/null | cut -c1-12 || true)
      if [ -n "$NET_ID" ]; then
        BR="br-$NET_ID"
        if ip link show "$BR" >/dev/null 2>&1; then
          if ! sudo iptables-legacy -C FORWARD -i "$BR" -o "$BR" -j ACCEPT 2>/dev/null; then
            sudo iptables-legacy -I FORWARD -i "$BR" -o "$BR" -j ACCEPT 2>/dev/null \
              && echo "Added missing container-to-container forwarding rule for $BR" \
              || echo "Warning: could not add iptables rule for $BR (containers may be unable to reach each other)"
          fi
        fi
      fi
    fi
  fi
fi
