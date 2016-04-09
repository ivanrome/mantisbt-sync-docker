#!/bin/sh

set -e

exec java "$@" -jar /mantis-sync-core-batch/mantisbt-sync-core-$MANTIS_SYNC_CORE_VERSION.jar
