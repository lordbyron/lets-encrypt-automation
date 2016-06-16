#!/bin/bash
set -x
cat <<CONFIGEOL > leconfig
# See letsencrypt.sh/docs/examples/config
CERTDIR="/Users/chrisb/work/lets-encrypt-automation/certs"
KEYSIZE="2048"
CONFIGEOL
/Users/chrisb/work/lets-encrypt-automation/letsencrypt.sh/letsencrypt.sh \
  --config leconfig \
  --cron \
  --domain static.envoy.christmas \
  --domain dashboard.static.envoy.christmas \
  --domain web.static.envoy.christmas \
  --challenge dns-01 \
  --hook '/Users/chrisb/work/lets-encrypt-automation/letsencrypt-cloudflare-hook/hook.py'
rm leconfig
