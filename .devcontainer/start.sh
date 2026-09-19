#!/usr/bin/env bash
# Brings up the docker compose stack and works around a networking quirk seen
# on some Codespace/dev container hosts: Docker programs this network's
# forwarding rules into iptables-nft, but a leftover iptables-legacy FORWARD
# chain (with policy DROP, from an earlier Docker iptables-mode run) still
# gets evaluated by the kernel and has no matching rule for this bridge. Both
# chains are consulted, so the legacy DROP wins even though nftables says
# accept. Two things break as a result:
#   - container-to-container: pgAdmin can resolve "db" but every packet to it
#     is dropped, so pgAdmin can never reach Postgres even though both are "Up"
#   - container-to-internet: DNS and HTTPS from the containers time out, which
#     surfaces in the pgAdmin UI as "<urlopen error [Errno -3] Try again>"
#     from its version check
# This is documented (and its fix recommended) by Docker itself:
# https://docs.docker.com/engine/network/firewall-nftables/
# This detects that case and adds the missing rules if needed.
#
# The bridge gets a new name (br-<network-id>) every time the compose
# network is recreated (e.g. `docker compose down && up`, or restarting the
# containers via an IDE/Docker extension instead of this script), so rules
# added for a previous bridge go stale and this whole workaround silently
# stops applying to the new one. This script both prunes any stale rules
# for bridges that no longer exist and (re)adds the current ones, so it's
# safe to re-run any time connectivity looks broken.
set -e

cd "$(dirname "$0")/.."

docker compose up -d

if command -v iptables-legacy >/dev/null 2>&1; then
  # Drop rules left behind for bridges that no longer exist.
  while read -r br; do
    if [ -n "$br" ] && ! ip link show "$br" >/dev/null 2>&1; then
      sudo iptables-legacy -S FORWARD | grep -- "$br" | sed 's/^-A/-D/' | while read -r rule; do
        sudo iptables-legacy $rule 2>/dev/null \
          && echo "Removed stale forwarding rule for gone bridge $br"
      done
    fi
  done < <(sudo iptables-legacy -S FORWARD | grep -oE 'br-[0-9a-f]+' | sort -u)

  CID=$(docker compose ps -q db 2>/dev/null || true)
  if [ -n "$CID" ]; then
    NET_NAME=$(docker inspect "$CID" --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}}{{end}}' 2>/dev/null || true)
    if [ -n "$NET_NAME" ]; then
      NET_ID=$(docker network inspect "$NET_NAME" -f '{{.Id}}' 2>/dev/null | cut -c1-12 || true)
      if [ -n "$NET_ID" ]; then
        BR="br-$NET_ID"
        if ip link show "$BR" >/dev/null 2>&1; then
          # Mirrors the rules Docker itself installs for docker0: traffic
          # between containers on the bridge, traffic out to the internet, and
          # the replies coming back.
          add_rule() {
            if ! sudo iptables-legacy -C FORWARD "$@" -j ACCEPT 2>/dev/null; then
              sudo iptables-legacy -I FORWARD "$@" -j ACCEPT 2>/dev/null \
                && echo "Added missing forwarding rule for $BR: $*" \
                || echo "Warning: could not add iptables rule for $BR: $*"
            fi
          }
          add_rule -o "$BR" -m conntrack --ctstate RELATED,ESTABLISHED
          add_rule -i "$BR" ! -o "$BR"
          add_rule -i "$BR" -o "$BR"
        fi
      fi
    fi
  fi
fi
