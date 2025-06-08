#!/bin/bash
# crave run --no-patch -- "curl https://raw.githubusercontent.com/Dityay/Android-Scripts/refs/heads/main/script.sh | bash"

# R#!/bin/bash

rm -rf .repo/local_manifests/

# repo init rom
repo init -u https://github.com/WitAqua/manifest.git -b 15.2 --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# Local manifests
git clone https://github.com/Dityay/local_manifests -b witaqua .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# build
/opt/crave/resync.sh
echo "============="
echo "Sync success"
echo "============="

# Signing keys
git clone https://github.com/AbuRider/vendor_signing.git vendor/lineage/signing/keys

# Export
export BUILD_USERNAME=deltarune
export BUILD_HOSTNAME=crave
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true

# initiate build setup
. build/envsetup.sh


echo "======= Export Done ======"
brunch earth
#lunch lineage_earth-bp1a-userdebug && mka derp
