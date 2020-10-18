SHELL := /bin/bash
THREADS ?= 8
OS ?= UBUNTU

.PHONY:all
all:flash

.PHONY:flash
flash:.cnvrt

.PHONY:convert
convert:.cnvrt

.cnvrt:out/update.img
	- sudo wine SpiImageTools.exe
	- sudo rm -f boot0.bin
	- sudo rm -f boot1.bin
	- sudo rm -rf Log/
	sudo mv data.bin out/
	touch .cnvrt

out/update.img:.bld
	mkdir -p out/
	cp AndroidBuild/RKTools/linux/Linux_Pack_Firmware/rockdev/update.img out/

.PHONY:build
build:.bld

.bld:.repo .copy
	pushd AndroidBuild; \
		source build/envsetup.sh && \
		lunch rk3288-userdebug; \
		$(MAKE) -C kernel/ ARCH=arm PYTHON=python2 rockchip_defconfig; \
		$(MAKE) -C kernel/ ARCH=arm PYTHON=python2 rk3288-miniarm.img -j$(THREADS); \
		$(MAKE) -C u-boot/ PYTHON=python2 rk3288_secure_defconfig; \
		$(MAKE) -C u-boot/ PYTHON=python2 -j$(THREADS); \
		export LC_ALL=C; \
		$(MAKE) PYTHON=python2 -j$(THREADS); \
		./mkimage.sh; \
		pushd RKTools/linux/Linux_Pack_Firmware/rockdev; \
			./collectImages.sh; \
			./mkupdate.sh
	touch .bld

.PHONY:copy
copy:.copy

.copy:.dwnld src/*
	cp -r src/* AndroidBuild/
	touch .copy

.PHONY:download
download:.dwnld

.dwnld:
	mkdir -p AndroidBuild
	(cd AndroidBuild/;repo init -u https://git@bitbucket.org/TinkerBoard_Android/manifest.git -b sbc/tinkerboard/asus/Android-7.1.2;repo sync -j$(THREADS) -c)
	touch .dwnld

.repo:.prereq
	mkdir -p ~/bin
	sudo curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
	chmod a+x ~/bin/repo
	echo 'export PATH="~/bin:$$PATH"' | tee -a ~/.bashrc
	PATH="~/bin:$$PATH"
	touch .repo

.PHONY:prereq
prereq:.prereq

.prereq:
	sudo apt-get install -y openjdk-8-jdk git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip python lzop libncurses5 wine
	sudo apt-get install -y ccache
	sudo /usr/sbin/update-ccache-symlinks 
	echo 'export PATH="/usr/lib/ccache:$$PATH"' | tee -a ~/.bashrc
	PATH="/usr/lib/ccache:$$PATH"
	touch .prereq

.PHONY:clean
clean:
	rm -rf AndroidBuild/
	rm -rf out/
	rm -f .prereq
	rm -f .dwnld


