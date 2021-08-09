#!/usr/bin/env perl
use strict;

use File::Path;
use File::Basename;
use Switch;
use Data::Dumper;

my %pkg_dep_map = ();

sub _print_help
{
    my ($app) = @_;
    print "Usage:\n";
    print $app  . " -h\n";
    print "  for this help menu.\n";
    print $app  . " -f <path_to_spec_file\n";
    print "  only handle one spec file.\n";
    print $app  . " -d <path_to_openEuler_srcs\n";
    print "  batch handle all subsequent specs.\n";
}

sub _handle_dep_str
{
    my ($_depstr) = @_;

    $_depstr =~ s/\s+?>/>/g;
    $_depstr =~ s/\s+?</</g;
    $_depstr =~ s/\s+?=/=/g;
    $_depstr =~ s/=\s+?/=/g;
    $_depstr =~ s/,/ /g;

    my @deps;
    @deps = split(' ', $_depstr);
    return @deps;
}

sub _handle_one_spec
{
    my ($spec, $name) = @_;
    open(SPEC, $spec);
    while (<SPEC>) {
        my $line = $_;
        if ($line =~ /buildrequires(.*?):(.*)/ig) {
            my @ndeps;
            if (exists($pkg_dep_map{$name})) {
                @ndeps = @{$pkg_dep_map{$name}};
            }
            my @deps = _handle_dep_str($2);

            push(@ndeps, @deps);
            $pkg_dep_map{$name} = [ @ndeps ];
        } else {
            #print $line;
        }
    }
    close(SPEC);
}

sub _handle_src_dir
{
    my ($dir) = @_;
    opendir(DIR, $dir);
    my @dirs = readdir(DIR);
    closedir(DIR);

    foreach my $d (@dirs) {
        unless ($d =~ /\./ or $d =~ /\.\./) {
            print "processing: " . $d . "\n";
            _handle_one_spec($dir . "/" . $d . "/" . $d . ".spec", $d);
        }
    }
}

#####################################################

switch($ARGV[0]) {
    case "-h" {
        _print_help($0);
        exit(0);
    }
    case "-f" {
        my $name = basename($ARGV[1], ".spec");
        _handle_one_spec($ARGV[1], $name);
    }
    case "-d" {
        _handle_src_dir($ARGV[1]);
    }
    else {
        _print_help($0);
    }
}

=for
foreach my $pkg (keys %pkg_dep_map) {
    print "package: [" . $pkg . "] deps:\n";
    my @deps = $pkg_dep_map{$pkg};
    print "@{$pkg_dep_map{$pkg}}\n";
}
=cut


open(DEPS, ">.deps") || die "can not open: $1";
print DEPS Dumper(\%pkg_dep_map);
close(DEPS) || die "error closing file: $1!";

print "Dependencies are saved into [.deps] for further use.\n";

exit(0);
