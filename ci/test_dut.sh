
#!/usr/bin/env bash
set -Eeuo pipefail

: "${DUT_HOST:?Set DUT_HOST to the test router IP}"
: "${SSH_USER:?Set SSH_USER to the DUT SSH username}"
: "${SSH_KEY:?Set SSH_KEY to the private-key file path}"


echo "=== SSH configuration ==="
echo "DUT host: $DUT_HOST"
echo "SSH user: $SSH_USER"
test -r "$SSH_KEY" || {
    echo "ERROR: SSH private key is not readable"
    exit 1
}
echo "SSH private key file is readable"

echo "=== DUT reachability ==="
ping -c 3 -W 2 "$DUT_HOST"

echo "=== Test SSH authentication ==="
ssh  "$SSH_USER@$DUT_HOST" \
    'echo "SSH authentication successful"; id'

echo "=== DUT board information ==="
ssh  "$SSH_USER@$DUT_HOST" \
    'ubus call system board'

echo "=== DUT network interfaces ==="
ssh  "$SSH_USER@$DUT_HOST" \
    'ip -br link'

echo "=== DUT smoke test passed ==="
