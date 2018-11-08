#!/bin/bash

source `dirname $0`/utils.sh

if [ $# == "0" ]; then
	echo "Usage: sync_source.sh \$REPOURL \$BRANCH \$REPOARGS \$REPODIR"
	echo "eg: sync_source.sh \"https://github.com/LineageOS/android\" \"-b lineage-15.1\" \"\" \"~/ROM/lineage\""
	exit 0
fi

REPOBIN=`which repo`
if [ ! -f $REPOBIN ]; then
	pr_err_exit "repo cmd doesn't exist"
fi

REPOURL=$1
REPOBRANCH=$2
REPOARGS=$3
REPODIR=$4

if [ $REPOURL == ""]; then
	pr_err_exit "REPOURL empty!"
fi

if [ $REPOBRANCH == ""]; then
	pr_err_exit "REPOBRANCH empty!"
fi

if [ $REPODIR == ""]; then
	pr_err "REPODIR not specified,assume to using default(~/android)"
	REPODIR=~/android
fi

cd $REPODIR
repo init -u $REPOURL -b $REPOBRANCH
if [ $? -ne 0 ]; then
	pr_err_exit "Faile to init repo"
fi

repo sync $REPOARGS
if [$? -ne 0 ]; then
	pr_err_exit "Failed to repo sync"
fi
echo "Sources successfully synced at $REPODIR"
