#!/bin/bash

export working_directory="/var/www"
export sync_path="obs"
export sync_name="Factory"
export sync_arch="riscv64"
export gpg_command="--nogpgcheck"
export log_file="$working_directory/log/$sync_name.log"
export log_command="|tee -a $log_file"
export sync_command="dnf reposync -a $sync_arch -a noarch --repo $sync_name -p $working_directory/private/$sync_path/ $gpg_command $log_command"
export meta_gen_command="createrepo_c --update $working_directory/private/$sync_path/$sync_name/ $log_command"

bash "$working_directory/sync/script/sync_common.sh"