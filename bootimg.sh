#!/bin/bash
cd ..
cd rr5.1

# Time of build startup
res1=$(date +%s.%N)
echo `date +%Y_%m_%d_%H-%M-%S`

export USE_CCACHE=1
export CCACHE_DIR=~/androidcache/.rr5_1

prebuilts/misc/linux-x86/ccache/ccache -M 20G

. build/envsetup.sh

breakfast g2m

mka bootimage

# Get elapsed time
res2=$(date +%s.%N)
echo "Total time elapsed: $(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds)"

cd ~/0_skrypty
./dzwiek.sh

