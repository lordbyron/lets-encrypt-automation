#!/bin/bash
set -x
/home/ubuntu/lets-encrypt-automation/letsencrypt.sh/letsencrypt.sh \
  --cron \
  --domain static.envoy.com \
  --domain dashboard.static.envoy.com \
  --domain web.static.envoy.com \
  --challenge dns-01 \
  --hook '/home/ubuntu/lets-encrypt-automation/letsencrypt-cloudflare-hook/hook.py'
