# lets-encrypt-automation

## Cloning

This module includes two submodules which need to be installed. The best option is to fetch them during clone
  `git clone --recursive <this repo>`

If you already cloned, you can fetch with
- `git submodule init`
- `git submodule update`

Also make sure to install the python requirements for the cloudflare submodule
`pip install -r letsencrypt-cloudflare-hook/requirements.txt`
(if python2.7 use `requirements-python-2.txt`)

## Usage

This single repo is used for all our lets-encrypt cert generation and automation, which means multiple certs being renews at different times.

`make.pl` produces a script that can be used to create/renew a single certificate.

`install.pl` takes a script and installs it in crontab.
- When installing the cron, expects two env vars to be set: `CF_EMAIL` and `CF_KEY`

```
$ ./make.pl static.envoy.com -a dashboard.static.envoy.com -a web.static.envoy.com
$ cat static.envoy.com-cron.sh
#!/bin/bash
set -x
/Users/chrisb/work/lets-encrypt-automation/letsencrypt.sh/letsencrypt.sh \
  --cron \
  --domain static.envoy.com \
  --domain dashboard.static.envoy.com \
  --domain web.static.envoy.com \
  --challenge dns-01 \
  --hook '/Users/chrisb/work/lets-encrypt-automation/letsencrypt-cloudflare-hook/hook.py'
$ CF_EMAIL=chris@envoy.com CF_KEY=K9uX2HyUjeWg5AhAb ./install.pl static.envoy.com-cron.sh
Installing crontab. Note that this appends the cron and does not delete old installations.
```

