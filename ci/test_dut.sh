#!/usr/bin/env bash
set -Eeuo pipefail

: "${DUT_HOST:?Set DUT_HOST to the test router IP}"
: "${SSH_USER:?Set SSH_USER to the DUT SSH username}"
: "${SSH_KEY:?Set SSH_KEY to the private-key file path}"

SSH_OPTS=(
  -i "$SSH_KEY"
  -o BatchMode=yes
  -o ConnectTimeout=5
  -o StrictHostKeyChecking=yes
)

echo "=== DUT reachability ==="
ping -c 3 -W 2 "$DUT_HOST"

ssh-keygen -y -f "$SSH_KEY" > /dev/null && echo KEY_OK_IN_JENKINS

echo "=== DUT board information ==="
ssh "${SSH_OPTS[@]}" "$SSH_USER@$DUT_HOST" \
  'ubus call system board'

echo "=== DUT network interfaces ==="
ssh "${SSH_OPTS[@]}" "$SSH_USER@$DUT_HOST" \
  'ip -br link'

echo "=== DUT smoke test passed ==="
