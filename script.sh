#!/bin/bash
# crave run --no-patch -- "curl https://raw.githubusercontent.com/Dityay/Android-Scripts/refs/heads/main/script.sh | bash"

# R#!/bin/bash

rm -rf .repo/local_manifests/

# repo init rom
repo init -u https://github.com/crdroidandroid/android.git -b 13.0 --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# Local manifests
git clone https://github.com/Dityay/local_manifests -b lineage-20 .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# build
/opt/crave/resync.sh
echo "============="
echo "Sync success"
echo "============="

# Export
export BUILD_USERNAME=deltarune
export BUILD_HOSTNAME=crave
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true

# initiate build setup
. build/envsetup.sh


echo "======= Export Done ======"
lunch lineage_earth-userdebug
m bacon
