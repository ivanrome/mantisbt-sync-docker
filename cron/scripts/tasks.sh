#!/bin/bash

function checkVariables {

	if [ -z $BASE_URL ]; then
		echo "[ERROR] URL of the mantisbt-sync-core is not defined"
		exit 1
	fi

	if [ -z $OPERATION ]; then
		echo "[ERROR] The operation to perform should be provided"
		exit 1
	elif [ "syncEnumsJob" = $OPERATION ]; then
		echo "[INFO] Enumerations sync job will be launched"
	elif [ "syncProjectsJob" = $OPERATION ]; then
		echo "[INFO] Projects sync job will be launched"
	elif [ "syncIssuesJob" = $OPERATION ]; then
		echo "[INFO] Issues sync job will be launched"
	else
		echo "[ERROR] Operation not recognized : $OPERATION"
		echo "[ERROR] Should be one of syncEnumsJob, syncProjectsJob or syncIssuesJob"
		exit 1
	fi
}

function wait_until_no_run {

	IS_RUNNING=1
	TIME=0

	while [ $IS_RUNNING -ne 0 ] && [ $TIME -lt 600 ]; do
		RUNNING_JOBS=`curl --silent -X GET $BASE_URL/monitoring/jobs/runningexecutions`
		if [ $RUNNING_JOBS = "[]" ]; then
			IS_RUNNING=0
		else
			IS_RUNNING=1
			sleep 10
			TIME=$(( $TIME + 10))
		fi
	done

	if [ $TIME -ge 600 ]; then
		echo "Abort launch after 600s wait because another job is running"
		exit 1
	fi
}

function lauchSyncEnums {

	echo "[INFO] Launch syncEnumsJob with parameters username=$MANTIS_USERNAME, password=$MANTIS_PASSWORD"

	curl --silent -X POST "$BASE_URL/operations/jobs/syncEnumsJob" --data "jobParameters=mantis.username=$MANTIS_USERNAME,mantis.password=$MANTIS_PASSWORD" > /dev/null

}

function lauchSyncProjects {

	echo "Launch syncProjectsJob with parameters username=$MANTIS_USERNAME, password=$MANTIS_PASSWORD, project_id=$MANTIS_PROJECT_ID"

	curl --silent -X POST "$BASE_URL/operations/jobs/syncProjectsJob" --data "jobParameters=mantis.username=$MANTIS_USERNAME,mantis.password=$MANTIS_PASSWORD,mantis.project_id=$MANTIS_PROJECT_ID" > /dev/null

}

function lauchSyncProjects {

	echo "Launch syncIssuesJob with parameters username=$MANTIS_USERNAME, password=$MANTIS_PASSWORD, project_id=$MANTIS_PROJECT_ID"

	curl --silent -X POST "$BASE_URL/operations/jobs/syncIssuesJob" --data "jobParameters=mantis.username=$MANTIS_USERNAME,mantis.password=$MANTIS_PASSWORD,mantis.project_id=$MANTIS_PROJECT_ID" > /dev/null

}

function lauchOperation {

	wait_until_no_run
	if [ "syncEnumsJob" = $OPERATION ]; then
		lauchSyncEnums
	elif [ "syncProjectsJob" = $OPERATION ]; then
		lauchSyncProjects
	elif [ "syncIssuesJob" = $OPERATION ]; then
		lauchSyncIssues
	fi
}

OPERATION=$1

checkVariables
lauchOperation
