source ./scripts/vars.sh
source ./scripts/funcs.sh

mkdir -p "${GIT_CACHE_DIR}" "${BUILD_DIR}"

# Clone the firmware repository
SOURCE="${FIRMWARE_SOURCE}"
if [ -d "${FIRMWARE_DIR}" ]; then
	echo "Directory ${FIRMWARE_DIR} exists."
	read -p "Do you want to delete it and re-clone? (y/n): " answer
	if [[ "$answer" =~ ^[Yy]$ ]]; then
		rm -rf "${FIRMWARE_DIR}" || { echo "Failed to remove ${FIRMWARE_DIR}"; exit 1; }
		git clone $SOURCE --depth 1 "${FIRMWARE_DIR}" || { echo "Failed to clone the firmware repo"; exit 1; }
	fi
else
	git clone $SOURCE --depth 1 "${FIRMWARE_DIR}" || { echo "Failed to clone the firmware repo"; exit 1; }
fi

# Change to the firmware directory
cd "${FIRMWARE_DIR}"

# Clean the build directory
rm -rf "${FIRMWARE_PACKAGE_DIR}"
mkdir -p "${FIRMWARE_PACKAGE_DIR}"

# Check if the boot files exist and copy them
if [ -d "${FIRMWARE_DIR}/lib" ]; then
	cp -r "${FIRMWARE_DIR}/lib" "${FIRMWARE_PACKAGE_DIR}"
else
	echo "Firmware not found."
	exit 1
fi

# Change to the build directory
cd ${BUILD_DIR}

# Generate Debian control files
generate_control firmware

# Build the Debian package
PACKAGE_NAME="firmware-${VENDOR}-${CODENAME}"
dpkg-deb --build --root-owner-group "${PACKAGE_NAME}"
mv -f "${PACKAGE_NAME}.deb" "${WORK_DIR}/${PACKAGE_NAME}.deb"

