#!/usr/bin/env perl
use strict;

use File::Path;
use File::Basename;
use Switch;
use Data::Dumper;

my %pkg_dep_map = ();
my %g_globals = (
    '_isa', 'riscv64',
    '_prefix', '/usr',
    '_bindir', '/bin',
    '_sbindir', '/sbin',
    '_mandir', '/usr/share/man',
    '_infodir', '/usr/share/info',
    '_includedir', '/usr/include',
    '_libdir', '/usr/lib',
    '_datadir', '/usr/',
    'python3_pkgversion', '3'
);

print Dumper \%g_globals;
sub _save_pkg_dep_map
{
    my ($fn) = @_;
    open(DEPS, ">$fn") || die "can not open: $fn";
    print DEPS Dumper(\%pkg_dep_map);
    close(DEPS) || die "error closing file: $fn!";
}

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

sub _handle_macro
{
    my ($macro_str, %vars) = @_;

    while ($macro_str =~ /\%\{\?(\w+):/) {
        my $old_m = $macro_str;
        my $var = $1;
        my $reg_expr = ".*?";
        my $exprv;

        while ($macro_str =~ /\%\{\?\w+:($reg_expr)\}/) {
            $exprv = $1;
            if ($exprv =~ /\%\{/) {
                $reg_expr = $reg_expr . "\}";
            } else {
                last;
            }
        }

        unless ($reg_expr =~ /\}$/) {
            $reg_expr .= "\}";
        }

        if (exists($vars{$var})) {
            $macro_str =~ s/\%\{\?\w+:$reg_expr/$exprv/;
        } else {
            $macro_str =~ s/\%\{\?\w+:$reg_expr//;
        }

        if ($old_m == $macro_str) {
            #print "unhandled: $macro_str\n";
            last;
        }
    }

    while ($macro_str =~ /\%\{\!\?(\w+):/) {
        my $old_m = $macro_str;
        my $var = $1;
        my $reg_expr = ".*?";
        my $exprv;

        while ($macro_str =~ /\%\{\!\?\w+:($reg_expr)\}/) {
            $exprv = $1;
            if ($exprv =~ /\{/) {
                $reg_expr = $reg_expr . "\}";
            } else {
                last;
            }
        }

        unless ($reg_expr =~ /\}$/) {
            $reg_expr .= "\}";
        }

        unless (exists($vars{$var})) {
            $macro_str =~ s/\%\{\!\?\w+:$reg_expr/$exprv/;
        } else {
            $macro_str =~ s/\%\{\!\?\w+:$reg_expr\}//;
        }

        if ($old_m == $macro_str) {
            #print "unhandled: $macro_str\n";
            last;
        }
    }

    # nasty fix for MACRO like: %{?epoch:%{epoch}:}%{version}-%{release}
    # the extra :} seems like pointless however there were exists words
    if ($macro_str =~ /\s:\}/) {
        $macro_str =~ s/\s:\}/ /;
    }

    return $macro_str;
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
        } elsif (exists($g_globals{$var})) {
            $var_str =~ s/\%\{$var\}/$g_globals{$var}/g;
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

sub _get_pkg_for_fl
{
    my ($line, $pn) = @_;

    $line =~ s/%files//;
    $line =~ s/^\s+|\s+$//;

    # just [%files]
    if ($line =~ /^$/) {
        return $pn;
    }

    my $sub_name_reg = '[\w-\%\{\}\.\-]';

    # for [%files sub-pkg]
    if ($line =~ /^($sub_name_reg+)$/) {
        $pn = "$pn-$1";
        return $pn;
    }

    # for [%files sub-pkg -f ...]
    if ($line =~ /^($sub_name_reg+)\s+-/) {
        #print "?? $line\n";
        $pn = "$pn-$1";
        $line =~ s/^($sub_name_reg+)\s+-/ -/;
        # We are done if there is NO more stuff need handling
        if ($line =~ /^$/) {
            return $pn;
        }
    }

    # for [%files -n exact_name]
    if ($line =~ /-n\s+([\w-\%\{\}\.]+)/) {
        $pn = $1;
        $line =~ s/-n\s+([\w-\%\{\}\.]+)//;
    }

    $line = "$line  ";
    # if there are [-f <file_name_for_files_list>]*
    while (length($line) > 0) {
        if ($line =~ /^\s+$/) {
            last;
        }
        if ($line =~ /-f\s+(.*?)\s/) {
            my $plf = $1;
            $line =~ s/-f\s+(.*?)\s/ /;
        } else {
            print "unhandled: $line\n";
            last;
        }
    }

    return $pn;
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
    my $fl_handling = 0;
    my $fl_pkg;

    $pinfo{'name'} = $name;
    $globals{'name'} = $name;
    $globals{'nil'} = "";
    $pkg_map{$pkg_name} = {};

    open(SPEC, $spec) or print "file [ " . $spec . " ] does not exists.\n";
    while (<SPEC>) {
        my $line = $_;
        $line =~ s/^\s+|\s+$//g;

        if ($fl_handling == 1) {
            unless (exists($pkg_map{$fl_pkg})) {
                $fl_handling = 0;
            } elsif ($line =~ /^$/) {
                $fl_handling = 0;
            } else {
                # the $line need be expanded, resolve '%{} / %() / %[] etc'
                # then update the 'provides' of $fl_pkg

                unless(
                    $line =~ /^%doc/ or
                    $line =~ /^%dir/ or
                    $line =~ /^%exclude/ or
                    $line =~ /^%license/
                ) {
                        my @provides;
                        my %pkg = %{$pkg_map{$fl_pkg}};
                        if (exists($pkg{"provides"})) {
                            @provides = @{$pkg{"provides"}};
                        }
                        my $prds = _handle_var($line, %globals);
                        push(@provides, $prds);
                        $pkg{"provides"} = [ @provides ];
                        $pkg_map{$fl_pkg} = { %pkg };
                }
            }
        }

        if ($line =~ /\%.*/g) {
            $line = _handle_macro($line, %globals);
        }

        if ($line =~ /^\%files.*/g) {
            $fl_handling = 1;
            # need determine $fl_pkg
            $fl_pkg = _get_pkg_for_fl($line, $name);
            $fl_pkg = _handle_var($fl_pkg, %globals);
        }

        if ($line =~ /\%global\s+(\w+)\s+(.*)/ig) {
            # get global defines
            my $varname = $1;
            my $varvalue = $2;
            $varvalue = _handle_var($varvalue, %globals);
            #print "get global: $varname -> $varvalue\n";
            $globals{$varname} = $varvalue;
            next;
        }

        if ($line =~ /\%define\s+(\w+)\s+(.*)/ig) {
            # get global defines
            my $varname = $1;
            my $varvalue = $2;
            $varvalue = _handle_var($varvalue, %globals);
            #print "get global: $varname -> $varvalue\n";
            $globals{$varname} = $varvalue;
            next;
        }

        if ($line =~ /^Name:\s*(.*)/ig) {
            # renamed main package
            $name = $1;
            $name = _handle_var($name, %globals);
            $pkg_name = $name;
            $pkg_map{$pkg_name} = {};
        }

        if ($line =~ /^BuildRequires(.*?):(.*)/g) {
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

        if ($line =~ /^Version:(\s*)(.*)/g) {
            my $version = _handle_var($2, %globals);
            $pinfo{version} = $version;
            $globals{version} = $version;
            my %pkg = %{$pkg_map{$pkg_name}};
            $pkg{"version"} = $version;
            $pkg_map{$pkg_name} = { %pkg };
        }

        if ($line =~ /^Release:(\s*)(.*)/g) {
            my $release = _handle_var($2, %globals);
            $pinfo{release} = $release;
            $globals{release} = $release;
            my %pkg = %{$pkg_map{$pkg_name}};
            $pkg{"release"} = $release;
            $pkg_map{$pkg_name} = { %pkg };
        }

        if ($line =~ /^Epoch:(\s*)(.*)/g) {
            my $epoch = $2;
            $pinfo{epoch} = $epoch;
            $globals{epoch} = $epoch;
            my %pkg = %{$pkg_map{$pkg_name}};
            $pkg{"epoch"} = $epoch;
            $pkg_map{$pkg_name} = { %pkg };
        }

        if ($line =~ /^\%package\s+/g) {
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

        if ($line =~ /^Requires.*?:(\s*)(.*)/g) {
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

        if ($line =~ /^Provides.*?:(\s*)(.*)/g) {
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
                print "--- processing: $spec";
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

_save_pkg_dep_map(".deps");

print "Dependencies are saved into [.deps] for further use.\n";

exit(0);
