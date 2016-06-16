#!/bin/bash
set -x
/home/ubuntu/lets-encrypt-automation/letsencrypt.sh/letsencrypt.sh \
  --cron \
  --domain static.envoy.christmas \
  --domain dashboard.static.envoy.christmas \
  --domain web.static.envoy.christmas \
  --challenge dns-01 \
  --hook '/home/ubuntu/lets-encrypt-automation/letsencrypt-cloudflare-hook/hook.py'
