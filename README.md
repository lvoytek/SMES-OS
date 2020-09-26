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

### make convert
Converts the update.img file to data.bin

*Currently unavailable - need to interact with the obscure SPIImageTool exe file to create it

### make flash
Flashes the data.bin output file to the TinkerBoard S or SD card 

*Currently unavailable