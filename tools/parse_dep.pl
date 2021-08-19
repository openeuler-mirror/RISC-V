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

sub _handle_var
{
    my ($var_str, %vars) = @_;

    while ($var_str =~ /\%\{(\w+)\}/) {
        my $var = $1;
        if (exists($vars{$var})) {
            unless ($vars{$var} =~ /\%\{$var\}/) {
                $var_str =~ s/\%\{$var\}/$vars{$var}/g;
            } else {
                # recursive definition like 'global optval %{optval}xyz'
                $var_str =~ s/\%\{$var\}//g;
            }
        } else {
            $var_str =~ s/\%\{$var\}/_\$_\{$var\}/g;
        }
    }

    $var_str =~ s/_\$_/\%/g;

    return $var_str;
}

sub _handle_str
{
    my ($_depstr, %vars) = @_;

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
    my %pinfo = ();
    my $pkg_name = $name;
    my %globals;
    $pinfo{'name'} = $name;
    $globals{'name'} = $name;
    $globals{'nil'} = "";
    $pkg_map{$pkg_name} = {};

    open(SPEC, $spec) or print "file [ " . $spec . " ] does not exists.\n";
    while (<SPEC>) {
        if ($_ =~ /\%global\s+(\w+)\s+(.*)/ig) {
            # get global defines
            my $varname = $1;
            my $varvalue = $2;
            $varvalue = _handle_var($varvalue, %globals);
            #print "get global: $varname -> $varvalue\n";
            $globals{$varname} = $varvalue;
        }

        if ($_ =~ /Name:\s*(.*)/ig) {
            # renamed main package
            $name = $1;
            $name = _handle_var($name, %globals);
            $pkg_name = $name;
            $pkg_map{$pkg_name} = {};
        }

        if ($_ =~ /^BuildRequires(.*?):(.*)/g) {
            my @ndeps;
            my %pkg = %{$pkg_map{$pkg_name}};
            if (exists($pkg{"bdep"})) {
                @ndeps = @{$pkg{"bdep"}};
            }
            #my $brstr = _handle_var($2, %globals);
            my @deps = _handle_str($2);
            #print Dumper \@deps;

            push(@ndeps, @deps);
            $pkg{"bdep"} = [ @ndeps ];
            $pkg_map{$pkg_name} = { %pkg };
        }

        if ($_ =~ /Version:(\s*)(.*)/g) {
            my $version = _handle_var($2, %globals);
            $pinfo{version} = $version;
            $globals{version} = $version;
            my %pkg = %{$pkg_map{$pkg_name}};
            $pkg{"version"} = $version;
            $pkg_map{$pkg_name} = { %pkg };
        }

        if ($_ =~ /Release:(\s*)(.*)/g) {
            my $release = _handle_var($2, %globals);
            $pinfo{release} = $release;
            $globals{release} = $release;
            my %pkg = %{$pkg_map{$pkg_name}};
            $pkg{"release"} = $release;
            $pkg_map{$pkg_name} = { %pkg };
        }

        if ($_ =~ /Epoch:(\s*)(.*)/g) {
            my $epoch = $2;
            $pinfo{epoch} = $epoch;
            $globals{epoch} = $epoch;
            my %pkg = %{$pkg_map{$pkg_name}};
            $pkg{"epoch"} = $epoch;
            $pkg_map{$pkg_name} = { %pkg };
        }

        if ($_ =~ /\%package*/g) {
            my @gs = split(' ', $_);
            my $subpn = $gs[scalar @gs - 1];
            if (scalar @gs == 2) {
                $pkg_name = $name . "-" . $subpn;
            } else {
                $pkg_name = $subpn;
            }
            $pkg_name = _handle_var($pkg_name, %globals);
            $pkg_map{$pkg_name} = {};
        }

        if ($_ =~ /^Requires.*?:(\s*)(.*)/g) {
            my @rdeps;
            my %pkg = %{$pkg_map{$pkg_name}};
            if (exists($pkg{"rdep"})) {
                @rdeps = @{$pkg{"rdep"}};
            }
            #my $rqstr = _handle_var($2, %globals);
            my @deps = _handle_str($2);
            push(@rdeps, @deps);
            $pkg{"rdep"} = [ @rdeps ];
            $pkg_map{$pkg_name} = { %pkg };
        }

        if ($_ =~ /^Provides.*?:(\s*)(.*)/g) {
            my @provides;
            my %pkg = %{$pkg_map{$pkg_name}};
            if (exists($pkg{"provides"})) {
                @provides = @{$pkg{"provides"}};
            }
            #my $prds = _handle_var($2, %globals);
            my @pros = _handle_str($2);
            push(@provides, @pros);
            $pkg{"provides"} = [ @provides ];
            $pkg_map{$pkg_name} = { %pkg };
        }
    }

    my %fpkg;
    $fpkg{'info'} = { %pinfo };

    # fix globals to resolve vars as much as possible
    for my $_k (keys(%globals)) {
        $globals{$_k} = _handle_var($globals{$_k}, %globals);
    }

    $fpkg{'globals'} = { %globals};
    $fpkg{'pkgs'} = { %pkg_map };

    $pkg_dep_map{$name} = { %fpkg };

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
Need fix 'provides', 'bdep', 'rdep' and so on
=cut
my @pkgs = keys(%pkg_dep_map);
for my $p (@pkgs) {
    my %pkg = %{ $pkg_dep_map{$p} };
    my %subpkgs = %{ $pkg{pkgs} };
    my %subglobals = %{ $pkg{globals} };
    my @skeys = keys(%subpkgs);

    for my $k (@skeys) {
        my %rpkg = %{ $subpkgs{$k} };

        if (exists($rpkg{rdep})) {
            my @rdep = @{ $rpkg{rdep} };
            my $i = 0;
            while ($i < scalar @rdep) {
                $rdep[$i] = _handle_var($rdep[$i], %subglobals);
                $i++;
            }
            $rpkg{rdep} = [ @rdep ];
        }

        if (exists($rpkg{bdep})) {
            my @bdep = @{ $rpkg{bdep} };

            my $i = 0;
            while ($i < scalar @bdep) {
                $bdep[$i] = _handle_var($bdep[$i], %subglobals);
                $i++;
            }
            $rpkg{bdep} = [ @bdep ];
        }

        if (exists($rpkg{provides})) {
            my @pvds = @{ $rpkg{provides} };

            my $i = 0;
            while ($i < scalar @pvds) {
                $pvds[$i] = _handle_var($pvds[$i], %subglobals);
                $i++;
            }
            $rpkg{provides} = [ @pvds ];
        }

        $subpkgs{$k} = { %rpkg };
    }

    $pkg{pkgs} = { %subpkgs };
    $pkg_dep_map{$p} = { %pkg };
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
