
SRCS_OPENEULER=https://repo.openeuler.org/openEuler-20.03-LTS/source/Packages/
WORK_DIR=./work
DOWN_SRCS_DIR=${WORK_DIR}/srpms
TASK_SRCS_DIR=~/openEuler/openEuler-SRPMS/openEuler-20.03-LTS/SRPMPackages
WORK_OUT=${WORK_DIR}/workout
NUMBER_JOBS=5

# qemu|cross|hardware
PLAT=qemu
QEMU_DISK_SIZE="10G"
QEMU_MEM_SIZE="4G"
# round1, round2, round3
#QEMU_DISK_IMAGE=round1-disk.img
QEMU_DISK_IMAGE=round1-disk-stage4-org.img
QEMU_EXTRA="-smp 4"

DEBUG=true

# round1, round2, round3
#WEB_RPM_REPO_SRV=http://192.168.0.104/oelriscv
#WEB_RPM_REPO_SYNC=http://192.168.0.104/oelriscv
#WEB_RPM_REPO_SRV=http://192.168.0.100:8000/risc-v/RPMS/
WEB_RPM_REPO_SRV=https://repo.openeuler.org/openEuler-preview/RISC-V/everything/
#WEB_RPM_REPO_SYNC=http://192.168.0.104/oelriscv

# Preinstalled packages
CORE_RPMS="systemd vim coreutils net-tools systemd-udev libssh openssh passwd NetworkManager dnf wget procps-ng dnf-plugins-core"
BUILD_TOOLS="rpm-build autoconf make gdb dnf-utils git texinfo gcc gcc-c++ hostname"
OBS_RPMS="osc build sudo iputils ntpdate vim cpio curl perl-Compress-Zlib perl-TimeDate perl-Data-Dumper perl-XML-Parser screen psmisc bash binutils bsdtar lzma util-linux openslp lvm2 perl-Digest-MD5 git screen tmux wget expect"
