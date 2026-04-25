#!/bin/bash

# Set the main script to stop if any of the sub-scripts exits with a non-zero status
set -e

bash ./scripts/build_tools.sh
bash ./scripts/kernel_build.sh
bash ./scripts/firmware_build.sh
sudo bash ./scripts/rootfs_build.sh ubuntu-desktop
