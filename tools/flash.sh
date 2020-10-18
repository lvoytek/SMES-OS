#!/bin/bash

lsblk
read -p "Enter drive name for SD card or TinkerBoard flash listed above (usually /dev/sda or /dev/sdb): " drive
sudo dd bs=4M if=data.bin of=$drive