#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long qw(GetOptions);
use Cwd 'abs_path';
use File::Basename;

sub usage() {
  print "Given domains, produce cron-able script to create and renew certs. Always use with --install, --script, or both.\n";
  print "Usage: $0 domain [-a alternative]\n";
  print "  -a, --alternative  FQDN to include.\n";
  print "  -f, --force        Overwrite -cron.sh file (with --script).\n";
  print "\n";
  print "Example: $0 static.envoy.com -a dashboard.static.envoy.com -a web.static.envoy.com --install\n";
  print "\n";
  exit(0);
}

my $help;
my @alt_args;
my $force;
my $keysize;
GetOptions(
  'help'          => \$help,
  'alternative=s' => \@alt_args,
  'force'         => \$force,
  'keysize=i'       => \$keysize,
);
# AWS doesn't like keys over 2048
$keysize ||= 2048;

if ($help || scalar(@ARGV) != 1) {
  usage();
}

my $domain = $ARGV[0];
my @alt_strings = ();
my $alt;
my $alt_string;
my $dir = dirname(abs_path($0));

foreach $alt (@alt_args) {
  push @alt_strings, "  --domain $alt \\";
}
$alt_string = join("\n", @alt_strings);

my $config = <<EOF;
EOF

my $configfile = "$dir/config";
open my $fh, ">", $configfile or die "Can't open $configfile for writing";
print $fh $config;
close $fh;

my $cron = <<EOF;
#!/bin/bash
set -x
cat <<CONFIGEOL > leconfig
# See letsencrypt.sh/docs/examples/config
CERTDIR="$dir/certs"
KEYSIZE="$keysize"
CONFIGEOL
$dir/letsencrypt.sh/letsencrypt.sh \\
  --config leconfig \\
  --cron \\
  --domain $domain \\
$alt_string
  --challenge dns-01 \\
  --hook '$dir/letsencrypt-cloudflare-hook/hook.py'
rm leconfig
EOF

my $scriptfile = "$dir/scripts/$domain-cron.sh";

(! -e $scriptfile || $force) or die "File $scriptfile already exists. Try --force";

open $fh, ">", $scriptfile or die "Can't open $scriptfile for writing";
print $fh $cron;
close $fh;

exit(0);
