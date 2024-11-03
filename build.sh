#!/bin/bash

bash ./scripts/kernel_build.sh
bash ./scripts/firmware_build.sh
sudo bash ./scripts/rootfs_build.sh ubuntu-desktop

