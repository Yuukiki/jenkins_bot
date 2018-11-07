#!/bin/bash

PRODUCT_OUT=out/target/product/wt88047
ROMS=~/ROMs
RRO=~/android/rro
DEVICE=rr_wt88047-userdebug
CLEAN="make clean && make clobber"
CCACHE="/home/jenkins/.ccache"
SETUP="prebuilts/misc/linux-x86/ccache/ccache -M 50G"
SYNC="repo sync -c -f --force-sync --no-clone-bundle --no-tags -j12"

### cd to build directory ###
cd $RRO
$SYNC

### Lets start build and clean it ###
. build/envsetup.sh
lunch $DEVICE
$CLEAN

### Lets start clean build with all needed commands ###
lunch $DEVICE
export USE_CCACHE=1 && export CCACHE_DIR=$CCACHE && $SETUP && export LC_ALL=C
export KBUILD_BUILD_USER="karthik"
export KBUILD_BUILD_HOST="Jacksparrrow"
mka bacon -j 12

### Now build done###

### Lets copy ROMs to separe Directory and clean our build directory ###
cd $PRODUCT_OUT 
cp RR-O*.zip $ROMS
cd $RRO
$CLEAN

