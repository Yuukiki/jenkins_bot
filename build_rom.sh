#!/bin/bash

RUNTIMEDIR=$(cd "$(dirname "$0")";pwd)

source $RUNTIMEDIR/scripts/utils.sh

PREEXEC=$RUNTIMEDIR/preexec.sh
if [ -f $PREEXEC ]; then
	source $PREEXEC
fi

function initial_manifest()
{
	PMANIFESTDIR=$RUNTIMEDIR/manifests
	TMANIFESTDIR="$1/.repo/local_manifests"
	INITIALFILE=$TMANIFESTDIR/.initialized
	if [ -f $INITIALFILE ]; then
		if [ ! -L $TMANIFESTDIR/$2.xml ]; then
			ln -sf $PMANIFESTDIR/$2.xml $TMANIFESTDIR/$2.xml
		fi
	else
		if [ -d $TMANIFESTDIR ]; then
			rm -rf $TMANIFESTDIR
			mkdir $TMANIFESTDIR
			ln -sf $PMANIFESTDIR/$2.xml $TMANIFESTDIR/$2.xml
			touch $INITIALFILE
		fi
	fi
}

if [ $# == "0" ]; then
	echo "Usage: build_rom.sh \$BUILDTOP \$CODENAME \$PRODUCTNAME \$BUILDTYPE \$REPOARGS"
	echo "eg: build_rom.sh ~/android \"wt88047\" \"lineage_wt88047\" \"eng\""
	exit 0
fi

ASSERTERROR="Error:Invalid argument"
BUILDTOP=$1
CODENAME=$2
PRODUCTNAME=$3
BUILDTYPE=$4
REPOARGS=$5

assert_equal $BUILDTOP "" $ASSERTERROR
assert_equal $CODENAME "" $ASSERTERROR
assert_equal $PRODUCTNAME "" $ASSERTERROR
assert_equal $BUILDTYPE "" $ASSERTERROR

if [ ! -d $BULDTOP ]; then
	pr_err_exit "BUILDTOP doesn't exist"
fi

initial_manifest $BUILDTOP $CODENAME

cd $BUILDTOP

repo sync $REPOARGS
assert_unequal $? 0 "Failed to sync source"
. build/envsetup.sh
make clobber
lunch $PRODUCTNAME-$BUILDTYPE
assert_unequal $? 0 "Failed to lunch"
mka bacon -j$(expr $(nproc) \* 2)
assert_unequal $? 0 "Failed to build"

POSTEXEC=$RUNTIMEDIR/postexec.sh
if [ -f $POSTEXEC ]; then
        source $POSTEXEC
fi
