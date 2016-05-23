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

function lauchSyncEnums {

	echo "[INFO] Launch syncEnumsJob with parameters username=$MANTIS_USERNAME"

	curl --silent --show-error -X POST "$BASE_URL/operations/jobs/syncEnumsJob" --data "jobParameters=mantis.username=$MANTIS_USERNAME,mantis.password=$MANTIS_PASSWORD"; echo;

}

function lauchSyncProjects {

	echo "[INFO] Launch syncProjectsJob with parameters username=$MANTIS_USERNAME, project_id=$MANTIS_PROJECT_ID"

	curl --silent --show-error -X POST "$BASE_URL/operations/jobs/syncProjectsJob" --data "jobParameters=mantis.username=$MANTIS_USERNAME,mantis.password=$MANTIS_PASSWORD,mantis.project_id=$MANTIS_PROJECT_ID"; echo;

}

function lauchSyncIssues {

	echo "[INFO] Launch syncIssuesJob with parameters username=$MANTIS_USERNAME, project_id=$MANTIS_PROJECT_ID"

	curl --silent --show-error -X POST "$BASE_URL/operations/jobs/syncIssuesJob" --data "jobParameters=mantis.username=$MANTIS_USERNAME,mantis.password=$MANTIS_PASSWORD,mantis.project_id=$MANTIS_PROJECT_ID"; echo;

}

function lauchOperation {

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
