#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long qw(GetOptions);
use File::Temp qw/ tempfile tempdir /;
use File::Spec;

sub usage() {
  print "Given a script, install into cron. Expects CF_EMAIL and CF_KEY env vars to be set.\n";
  print "Usage: $0 script\n";
  print "\n";
  print "Example: CF_EMAIL=chris\@envoy.com CF_KEY=K9uX2HyUjeWg5AhAb $0 static.envoy.com-cron.sh\n";
  print "\n";
  exit(0);
}

my $help;
if ($help || scalar(@ARGV) != 1) {
  usage();
}

my $scriptfile = File::Spec->rel2abs($ARGV[0]);
print "$scriptfile\n";

die "When installing cron, must set CF_EMAIL env var" unless defined $ENV{'CF_EMAIL'};
die "When installing cron, must set CF_KEY env var" unless defined $ENV{'CF_KEY'};
print "Installing crontab. Note that this appends the cron and does not delete old installations.\n";
my ($fh, $cronfile) = tempfile();
my $crontab = `crontab -l`;
print $fh $crontab;
print $fh "CF_EMAIL=$ENV{'CF_EMAIL'}\n";
print $fh "CF_KEY=$ENV{'CF_KEY'}\n";
print $fh "41 2,14 * * * $scriptfile >> $scriptfile.log\n";
system("crontab $cronfile");
close $fh;

exit(0);
