source ./deviceinfo

IFS=':' read -r DEVICE_NAME DEVICE <<< "${DEVICE}"
IFS='-' read -r SOC VENDOR CODENAME <<< "${DEVICE}"

SOURCE="${KERNEL_SOURCE} -b ${BRANCH}"
KERNEL_DIR=$(basename "${KERNEL_SOURCE}")

ARCH="arm64"
KERNEL_OUTPUT=".output"
MAKEPROPS="-j$(nproc) O=${KERNEL_OUTPUT} ARCH=${ARCH} CROSS_COMPILE=aarch64-linux-gnu-"

# Define paths to the Image and DTB files
IMAGE_PATH="${KERNEL_OUTPUT}/arch/arm64/boot/Image.gz"
DTB_PATH="${KERNEL_OUTPUT}/arch/arm64/boot/dts/qcom/${DEVICE}.dtb"

# Define output directories
OUTPUT_DIR="../linux-${VENDOR}-${CODENAME}"
BOOT_DIR="${OUTPUT_DIR}/boot"

