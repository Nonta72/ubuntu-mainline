#!/bin/bash

generate_control() {
	local package_type="$1"
	local version
	local extra_fields=""
	local description

	case "$package_type" in
		linux)
			version="$KERNEL_VER-$SOC"
			extra_fields="Section: kernel"
			description="Kernel and Modules"
			;;
		firmware)
			version="1.0"
			extra_fields="Conflicts: linux-firmware
Replaces: linux-firmware"
			description="Nonfree firmware blobs"
			;;
		alsa)
			version="1.0"
			extra_fields="Depends: alsa-ucm-conf"
			description="Alsa UCM configurations"
			;;
		*)
			echo "Unknown package type: $package_type"
			return 1
			;;
	esac

	mkdir -p "$package_type-$VENDOR-$CODENAME/DEBIAN"

cat << EOF > "$package_type-$VENDOR-$CODENAME/DEBIAN/control"
Package: $package_type-$VENDOR-$CODENAME
Version: $version
Architecture: $ARCH
Maintainer: $MAINTAINER
$extra_fields
Description: $description for $DEVICE_NAME
EOF
}

