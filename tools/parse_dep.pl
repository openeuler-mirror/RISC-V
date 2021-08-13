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
    my $version;
    my $release;
    my %pkg_map = ();
    my $pkg_name = $name;
    $pkg_map{$pkg_name} = {};

    open(SPEC, $spec) or print "file [ " . $spec . " ] does not exists.\n";
    while (<SPEC>) {
        my $line = $_;
        if ($line =~ /Name:\s*(.*)/ig) {
            # renamed main package
            $name = $1;
            $pkg_name = $name;
            $pkg_map{$pkg_name} = {};
        }
        if ($line =~ /Version:\s*(.*)/ig) {
            $version = $1;
        }
        if ($line =~ /Release:\s*(.*)/ig) {
            $release = $1;
        }
        if ($line =~ /^BuildRequires(.*?):(.*)/g) {
            my @ndeps;
            my %pkg = %{$pkg_map{$pkg_name}};
            if (exists($pkg{"bdep"})) {
                @ndeps = @{$pkg{"bdep"}};
            }
            my @deps = _handle_dep_str($2);
            #print Dumper \@deps;

            push(@ndeps, @deps);
            $pkg{"bdep"} = [ @ndeps ];
            $pkg_map{$pkg_name} = { %pkg };
        }
        if ($line =~ /Version:(\s*)(.*)/g) {
            my $version = $2;
            my %pkg = %{$pkg_map{$pkg_name}};
            $pkg{"version"} = $version;
            $pkg_map{$pkg_name} = { %pkg };
        }
        if ($line =~ /Release:(\s*)(.*)/g) {
            my $release = $2;
            my %pkg = %{$pkg_map{$pkg_name}};
            $pkg{"release"} = $release;
            $pkg_map{$pkg_name} = { %pkg };
        }
        if ($line =~ /\%package*/g) {
            my @gs = split(' ', $line);
            my $subpn = $gs[scalar @gs - 1];
            if (scalar @gs == 2) {
                $pkg_name = $name . "-" . $subpn;
            } else {
                $pkg_name = $subpn;
            }
            $pkg_map{$pkg_name} = {};
        }
        if ($line =~ /^Requires.*?:(\s*)(.*)/g) {
            my @rdeps;
            my %pkg = %{$pkg_map{$pkg_name}};
            if (exists($pkg{"rdep"})) {
                @rdeps = @{$pkg{"rdep"}};
            }
            my @deps = _handle_dep_str($2);
            push(@rdeps, @deps);
            $pkg{"rdep"} = [ @rdeps ];
            $pkg_map{$pkg_name} = { %pkg };
        }
        if ($line =~ /^Provides.*?:(\s*)(.*)/g) {
            my @provides;
            my %pkg = %{$pkg_map{$pkg_name}};
            if (exists($pkg{"provides"})) {
                @provides = @{$pkg{"provides"}};
            }
            my @pros = _handle_dep_str($2);
            push(@provides, @pros);
            $pkg{"provides"} = [ @provides ];
            $pkg_map{$pkg_name} = { %pkg };
        }
    }
    #print Dumper \%pkg_map;
    $pkg_dep_map{$name} = { %pkg_map };
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
            my @specs = `ls $dir/$d/*spec`;
            for my $spec (@specs) {
                print "processing: " . $spec;
                _handle_one_spec($spec, $d);
            }
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
