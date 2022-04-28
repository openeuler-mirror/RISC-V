#!/bin/bash

export working_directory="/var/www"
export sync_path="openEuler-RISC-V/development/"
export sync_name="22.03"
export sync_arch="riscv64"
export log_file="$working_directory/log/$sync_name.log"
export log_command="|tee -a $log_file"
export sync_command="reposync -a $sync_arch -r $sync_name -p $working_directory/public/$sync_path/ $log_command"
export meta_gen_command="createrepo --update $working_directory/public/$sync_path/$sync_name/ $log_command"

bash "$working_directory/sync/script/sync_common.sh"