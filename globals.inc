
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
WEB_RPM_REPO_SRV=http://192.168.0.100:8000/risc-v/RPMS/
#WEB_RPM_REPO_SYNC=http://192.168.0.104/oelriscv


