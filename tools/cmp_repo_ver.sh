#!/bin/bash
# List openEuler packages that RISC-V missed or version lower than X86_64 source repo.
# Usage: $0 [x86-src-rpms-url]

set -e

# default urls and result file name
riscv_url="http://119.3.219.20:82/openEuler:/Mainline:/RISC-V/standard_riscv64/src/"
x86_url=${1:-"http://119.3.219.20:82/openEuler:/22.03:/LTS/standard_x86_64/src/"}
result=version-diff

# list format: arch(riscv/x86) name version
function get_pkg_list()
{
    truncate -s 0 $1.pkg
    gawk -F '>' -v outfile=$1.pkg -v arch=$2 -- '
        /^<img/ {
            sub(/\.oe[^.]*\.src\.rpm<\/a/, "", $3)
            n = gsub(/-/, "-", $3)
            str = gensub(/-/, " ", n-1, $3)
            print arch, str >> outfile
        }
    ' $1.index
}

riscv_file=riscv_ver
x86_file=x86_ver
wget -q -O ${riscv_file}.index ${riscv_url} 
wget -q -O ${x86_file}.index ${x86_url}
get_pkg_list ${x86_file} "x86"
get_pkg_list ${riscv_file} "riscv"
rm ${riscv_file}.index
rm ${x86_file}.index

function cmp_ver_diff()
{
    sort -V -k2,3 -s $1 $2 > __temp_file__

    temp=(`cat __temp_file__`)
    rm __temp_file__

    printf "%-40s%-30s%-30s\n" "0E PACKAGES" "0E MAINLINE" "OE RISC-V" > $3
    declare -i j
    for (( i = 0; i < ${#temp[@]}; i += $j )); do
        first[0]=${temp[$i]}
        first[1]=${temp[$i + 1]}
        first[2]=${temp[$i + 2]}
        second[0]=${temp[$i + 3]}
        second[1]=${temp[$i + 4]}
        second[2]=${temp[$i + 5]}

         # riscv must missed
        if [ "${first[1]}" != "${second[1]}" ]; then
            printf "%-40s%-30s\n" ${first[1]} ${first[2]} >> $3
            j=3
            continue
        fi

        # riscv less than x86
        if [[ "${first[2]}" != "${second[2]}" && "${first[0]}" != "x86" ]]; then
            printf "%-40s%-30s%-30s\n" ${first[1]} ${second[2]} ${first[2]} >> $3
        fi
        j=6
    done
}

cmp_ver_diff ${riscv_file}.pkg ${x86_file}.pkg $result

