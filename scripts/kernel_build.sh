source ./scripts/vars.sh
source ./scripts/funcs.sh

# Clone the kernel source repository
if [ -d "$KERNEL_DIR" ]; then
	echo "Directory '$KERNEL_DIR' exists."
	read -p "Do you want to delete it and re-clone? (y/n): " answer
	if [[ "$answer" =~ ^[Yy]$ ]]; then
		sudo rm -rf "$KERNEL_DIR" || { echo "Failed to remove $KERNEL_DIR"; exit 1; }
		git clone $SOURCE --depth 1 || { echo "Failed to clone kernel source"; exit 1; }
	fi
else
	git clone $SOURCE --depth 1 || { echo "Failed to clone kernel source"; exit 1; }
fi

# Change to the kernel directory
cd "$KERNEL_DIR"

# Build the kernel using the specified defconfig
make $MAKEPROPS $DEFCONFIG && make $MAKEPROPS

# Get the kernel version
KERNEL_VER="$(make $MAKEPROPS kernelrelease -s)"

# Create the boot directory
mkdir -p "$BOOT_DIR"

# Check if the boot files exist and copy them
ls $IMAGE_PATH
if [ -f "$IMAGE_PATH" ] && [ -f "$DTB_PATH" ]; then
    cp "$IMAGE_PATH" "$BOOT_DIR/vmlinuz-$KERNEL_VER"
    cp "$DTB_PATH" "$BOOT_DIR/dtb-$KERNEL_VER"
else
    echo "Boot files not found."
    exit 1
fi

# Remove the lib directory if it exists
rm -rf "${OUTPUT_DIR}/lib"

# Install the modules to the output directory
make $MAKEPROPS INSTALL_MOD_PATH="$OUTPUT_DIR" modules_install || { echo "Modules installation failed"; exit 1; }

# Remove all 'build' directories within the modules
find "$OUTPUT_DIR/lib/modules" -type d -name "build" -exec rm -rf {} + || { echo "Failed to remove build directories"; }

# Change back to the parent directory
cd ..

# Generate Debian control files
generate_control linux

# Build the Debian package
dpkg-deb --build --root-owner-group "linux-${VENDOR}-${CODENAME}"

