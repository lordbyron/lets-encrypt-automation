#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long qw(GetOptions);
use Cwd;

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
GetOptions(
  'help'          => \$help,
  'alternative=s' => \@alt_args,
  'force'         => \$force,
);

if ($help || scalar(@ARGV) != 1) {
  usage();
}

my $domain = $ARGV[0];
my @alt_strings = ();
my $alt;
my $alt_string;
my $here = getcwd;

foreach $alt (@alt_args) {
  push @alt_strings, "  --domain $alt \\";
}
$alt_string = join("\n", @alt_strings);

my $cron = <<EOF;
#!/bin/bash
set -x
$here/letsencrypt.sh/letsencrypt.sh \\
  --cron \\
  --domain $domain \\
$alt_string
  --challenge dns-01 \\
  --hook '$here/letsencrypt-cloudflare-hook/hook.py'
EOF
#print $cron;

my $scriptfile = "$domain-cron.sh";

(! -e $scriptfile || $force) or die "File $scriptfile already exists. Try --force";

open my $fh, ">", $scriptfile or die "Can't open $scriptfile for writing";
print $fh $cron;
close $fh;

exit(0);
