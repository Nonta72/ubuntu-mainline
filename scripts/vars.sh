source ./deviceinfo

IFS=':' read -r DEVICE_NAME DEVICE <<< "${DEVICE}"
IFS='-' read -r SOC VENDOR CODENAME <<< "${DEVICE}"

WORK_DIR=$(readlink -f "$(dirname $0)/..")
BUILD_DIR="${WORK_DIR}/build"
GIT_CACHE_DIR="${WORK_DIR}/cache_git"

KERNEL_DIR="${GIT_CACHE_DIR}/$(basename "${KERNEL_SOURCE}")"
FIRMWARE_DIR="${GIT_CACHE_DIR}/$(basename "${FIRMWARE_SOURCE}")"

ARCH="arm64"
KERNEL_OUTPUT="${KERNEL_DIR}/.output"
MAKEPROPS="-j$(nproc) O=${KERNEL_OUTPUT} ARCH=${ARCH} CROSS_COMPILE=aarch64-linux-gnu-"

# Define paths to the Image and DTB files
IMAGE_PATH="${KERNEL_OUTPUT}/arch/arm64/boot/Image.gz"
DTB_PATH="${KERNEL_OUTPUT}/arch/arm64/boot/dts/qcom/${DEVICE}.dtb"

# Define output directories
KERNEL_PACKAGE_DIR="${BUILD_DIR}/linux-${VENDOR}-${CODENAME}"
BOOT_DIR="${KERNEL_PACKAGE_DIR}/boot"

FIRMWARE_PACKAGE_DIR="${BUILD_DIR}/firmware-${VENDOR}-${CODENAME}"

