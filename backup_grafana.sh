#!/bin/bash

set -e

trap 'echo -ne "\n:::\n:::\tCaught signal, exiting at line $LINENO, while running :${BASH_COMMAND}:\n:::\n"; exit' SIGINT SIGQUIT

current_path=$(pwd)
backup_dir="_OUTPUT_"
timestamp=$(date +"%Y-%m-%dT%H-%M-%S")

[ -d "${backup_dir}" ] || mkdir -p "${backup_dir}"

for i in dashboards datasources folders alert_channels
do
	F="${backup_dir}/${i}/${timestamp}"
	[ -d "${F}" ] || mkdir -p "${F}"
	python "${current_path}/src/save_${i}.py" "${F}"
done

tar -czvf "grafana-${timestamp}.tar.gz" ${backup_dir}/{dashboards,datasources,folders,alert_channels}/${timestamp}
aws s3 mv "grafana-${timestamp}.tar.gz"  s3://$S3_BUCKET/"grafana-${timestamp}.tar.gz"
rm -rf ${backup_dir}/{dashboards,datasources,folders,alert_channels}/${timestamp}
