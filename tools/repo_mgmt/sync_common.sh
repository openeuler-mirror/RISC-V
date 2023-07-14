#!/bin/bash
BOLDYELLOW="\e[1;33m"
ENDCOLOR="\e[0m"

export status_file="$working_directory/status/$sync_name"

touch $status_file
if [ `cat "$status_file"` == "running" ] ; then
	sync_logtail=`tail -1 "$log_file"`;
	sleep 10m;
	if [ `tail -1 "$log_file"` == $sync_logtail ] ; then
		ps -ef | grep "$sync_command && $meta_gen_command" | grep -v grep | awk '{print $2}' | xargs kill -TERM;
		echo -e "${BOLDYELLOW}:: Syncing Task KILLED${ENDCOLOR}"
		echo "failed" > "$status_file";
	fi
fi

if [ `cat "$status_file"` == "running" ] ; then
	echo -e "${BOLDYELLOW}:: Error: In-progress syncing task for [$sync_name] detected. Skipping...${ENDCOLOR}";
else
	echo -e "${BOLDYELLOW}:: [$sync_name] Syncing...${ENDCOLOR}";
	echo "running" > "$status_file";
    echo;
    echo -e "${BOLDYELLOW}:: Sync task started at${ENDCOLOR}" $(date -u)|tee -a "$log_file";
    echo;
	echo -e "${BOLDYELLOW}:: Starting reposync...${ENDCOLOR}";
	eval $sync_command;
	sync_exit=$?;
	echo -e "${BOLDYELLOW}:: Repository synchronized.${ENDCOLOR}";
	echo -e "${BOLDYELLOW}:: Starting createrepo...${ENDCOLOR}";
	eval $meta_gen_command;
	meta_exit=$?;
	exit_sum=$(expr $sync_exit + $meta_exit);
	if [ $exit_sum -eq 0 ] ; then
		echo -e "${BOLDYELLOW}:: Repo created successfully.${ENDCOLOR}";
		echo -e "${BOLDYELLOW}:: [$sync_name] Sync completed.${ENDCOLOR}";
		echo "succeeded" > "$status_file";
		echo -e "${BOLDYELLOW}:: Sync task finished at${ENDCOLOR}" $(date -u)|tee -a "$log_file";
	elif [ $exit_sum -eq 124 ] ; then
		echo -e "${BOLDYELLOW}:: [$sync_name] Timeout${ENDCOLOR}";
		echo "timeout" > "$status_file";
		echo -e "${BOLDYELLOW}:: Sync task timeout at${ENDCOLOR}" $(date -u)|tee -a "$log_file";
	else
		echo -e "${BOLDYELLOW}:: [$sync_name] Sync failed.${ENDCOLOR}";
		echo "failed" > "$status_file";
		echo -e "${BOLDYELLOW}:: Sync task failed at${ENDCOLOR}" $(date -u)|tee -a "$log_file";
	fi
fi