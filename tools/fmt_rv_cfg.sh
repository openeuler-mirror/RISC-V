#!/bin/sh

prj="openEuler:Mainline:RISC-V"

function usage()
{
    echo "Usage: sh fmt_rv_cfg.sh -f CFG-DIR-TO-FORMAT | -r CONFIG-TO-REFRESH | -h"
}

if [ $# == 0 ]; then
    usage
    exit 1
fi


function format_cfg()
{
    local topdir=$1
    outfile=rv_cfg.list
    echo -e "name\trepository\trevision\tstatus-on-riscv" > $outfile
    url=
    revision=
    file=_service
    for pkg in `ls $topdir`
    do
        url=`grep -r "url" $topdir/$pkg/$file | cut -d '<' -f2 | cut -c 18-`
        revision=`grep -r "revision" $topdir/$pkg/$file | cut -d '<' -f2 | cut -c 23-`
	status=`osc results $prj $pkg | grep riscv | tr -s ' ' | cut -d' ' -f3`
        echo -e "$pkg\t\t $url\t\t $revision\t\t $status" >> $outfile
    done
}

function rename()
{
topdir=$1
file=_service
for dir in `ls $topdir`
do
        cmtID=`git ls-remote https://tmpuser:tmppwd@gitee.com/src-openeuler/${dir}.git HEAD| awk '{print $1}'`
	if [ -z ${cmtID} ]
	then 
		echo "src-openeuler/${dir} doesn't exist, remove it."
		rm -rf $topdir/$dir
		continue
	fi
	sed -ri  "s|<param name=\"url\">.*</param>|<param name=\"url\">git@gitee.com:src-openeuler/${dir}.git</param>|g"  $topdir/$dir/_service
	sed -ri  "s|<service name=\"tar_scm_kernel_repo\">|<service name=\"tar_scm\">|g"  $topdir/$dir/_service
	sed -ri  "s|<param name=\"scm\">.*</param>|<param name=\"scm\">git</param>|g"  $topdir/$dir/_service
	sed -i  "/\/service>/i\      <param name=\"exclude\">.git<\/param>"  $topdir/$dir/_service
	sed -i  "/\/service>/i\      <param name=\"revision\">${cmtID}<\/param>"  $topdir/$dir/_service
	sed -i  "/\/services/i\    <service name=\"extract_file\">"  $topdir/$dir/_service
	sed -i  "/\/services/i\        <param name=\"archive\">*.tar<\/param>"  $topdir/$dir/_service
	sed -i  "/\/services/i\        <param name=\"files\">*\/*<\/param>"  $topdir/$dir/_service
	sed -i  "/\/services/i\    <\/service>"  $topdir/$dir/_service
done
}

while getopts "f:r:h" opt; do
    case $opt in
        h)
        usage; exit 0;;
        f)
        format_cfg $OPTARG; exit 0;;
        r)
        rename $OPTARG; exit 0;;
        \?)
        break;;
    esac
done
