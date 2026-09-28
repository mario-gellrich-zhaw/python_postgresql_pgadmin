#!/usr/bin/env bash
# Starts the Docker Compose stack and fixes missing iptables-legacy forwarding
# rules that can block container-to-container and container-to-internet traffic.
# Stale rules are removed because the bridge name changes when the network is
# recreated.
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
