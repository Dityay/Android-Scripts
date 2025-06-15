#!/bin/bash
# crave run --no-patch -- "curl https://raw.githubusercontent.com/Dityay/Android-Scripts/refs/heads/main/script.sh | bash"


# Remove Unnecessary Files
echo "===================================="
echo "     Removing Unnecessary Files"
echo "===================================="

dirs_to_remove=(
  "vendor/xiaomi"
  "kernel/xiaomi"
  "device/xiaomi"
  "device/xiaomi/sm6150-common"
  "vendor/xiaomi/sm6150-common"
  "hardware/xiaomi"
  "out/target/product/*/*zip"
  "out/target/product/*/*txt"
  "out/target/product/*/boot.img"
  "out/target/product/*/recovery.img"
  "out/target/product/*/super*img"
)

for dir in "${dirs_to_remove[@]}"; do
  [ -e "$dir" ] && rm -rf "$dir"
done

echo "===================================="
echo "  Removing Unnecessary Files Done"
echo "===================================="

# Initialize repo
echo "=============================================="
echo "         Cloning Manifest..........."
echo "=============================================="
if ! repo init -u https://github.com/crdroidandroid/android.git -b 13.0 --git-lfs; then
  echo "Repo initialization failed."
fi
echo "=============================================="
echo "       Manifest Cloned successfully"
echo "=============================================="
# Sync
if ! /opt/crave/resync.sh || ! repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all); then
  echo "Repo sync failed."
fi
echo "============="
echo " Sync success"
echo "============="

# Clone device trees and other dependencies
echo "=============================================="
echo "       Cloning Trees..........."
echo "=============================================="
rm -rf device/xiaomi

rm -rf vendor/xiaomi

rm -rf kernel/xiaomi

rm -rf hardware/xiaomi

rm -rf hardware/mediatek

rm -rf device/mediatek/sepolicy_vndr

git clone https://github.com/Dityay/Bumi-Device-Tree -b lineage-20 device/xiaomi/earth || { echo "Failed to clone device tree"; }

git clone https://github.com/Dityay/proprietary_vendor_xiaomi_earth -b lineage-20 vendor/xiaomi/earth || { echo "Failed to clone vendor tree"; }

git clone https://github.com/mt6768-dev/android_kernel_xiaomi_earth -b lineage-22.2 kernel/xiaomi/earth || { echo "Failed to clone kernel tree"; }

git clone https://github.com/LineageOS/android_hardware_xiaomi.git -b lineage-20 hardware/xiaomi || { echo "Failed to clone xiaomi stuffs"; }

git clone https://github.com/LineageOS/android_hardware_mediatek.git -b lineage-20 hardware/mediatek || { echo "Failed to clone mediatek hardwares"; }

git clone https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr.git -b lineage-20 device/mediatek/sepolicy_vndr || { echo "Failed to sepolicy_vndr"; }

/opt/crave/resync.sh

# Export Environment Variables
echo "======= Exporting........ ======"
export BUILD_USERNAME=dreemurr
export BUILD_HOSTNAME=crave
export TZ=Asia/Jakarta
export ALLOW_MISSING_DEPENDENCIES=true
echo "======= Export Done ======"

# Set up build environment
echo "====== Starting Envsetup ======="
source build/envsetup.sh || { echo "Envsetup failed"; exit 1; }
echo "====== Envsetup Done ======="


# Build ROM
echo "===================================="
echo "  BRINGING TO HORIZON , STARTING BUILD.."
echo "===================================="
. build/envsetup.sh
lunch lineage_earth-userdebug
m bacon
