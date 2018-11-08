#!/bin/bash

export CCACHE_DIR="$HOME/.ccache"
prebuilts/misc/linux-x86/ccache/ccache -M 50G
export USE_CCACHE=1
