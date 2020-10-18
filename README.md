# SMES-OS
Modification of the Android operating system for SMES middleware use

## Make Commands:

### make prereq
Installs all prerequisite libraries for the given operating system in preparation for compiling Android source 

*Currently only works for Ubuntu 18.04 and 20.04

### make download
Downloads the Android source libraries. Make sure to have at least 120GB of space available for it

### make copy
Copy custom source files over to the Android source directory in preparation for a custom build

### make build
Builds the update.img file that can be transformed and flashed to the device

Make sure /usr/bin/env python is set to Python 2

If the build process fails at any point you may be using too many threads, reduce the THREADS variable and try again

### make convert
Converts the update.img file to data.bin using SpiImageTools

For information on how to use this program check out [SMES_compilation_instructions.pdf](SMES_compilation_instructions.pdf)

After closing the GUI data.bin will appear in the out/ folder

### make flash
Flashes the data.bin output file to the TinkerBoard S or SD card 

### make all / make
Run all items in the following order:
1. prereq
2. download
3. copy
4. build
5. convert
6. flash

### make clean
Removes the Android source directory and installation flags so that a fresh version may be installed

### Variables:
THREADS: The number of threads to use when downloading or building. Defaults to 8

OS: The Linux OS in use. Defaults to UBUNTU