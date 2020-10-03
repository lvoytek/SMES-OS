SHELL := /bin/bash
THREADS ?= 8
OS ?= UBUNTU

.PHONY:all
all:flash

.PHONY:flash
flash:convert

.PHONY:convert
convert:out/update.img

out/update.img:build
	mkdir -p out/
	cp AndroidBuild/RKTools/linux/Linux_Pack_Firmware/rockdev/update.img out/

.PHONY:build
build:~/bin/repo copy
	(source build/envsetup.sh; lunch rk3288-userdebug; cd kernel/; make ARCH=arm rockchip_defconfig; make ARCH=arm rk3288-miniarm.img -j$(THREADS); cd ../u-boot; make rk3288_secure_defconfig; make -j$(THREADS); cd ..; export LC_ALL=C; make -j$(THREADS); ./mkimage.sh; cd RKTools/linux/Linux_Pack_Firmware/rockdev; ./collectImages.sh; ./mkupdate.sh)

.PHONY:copy
copy:download src/*
	cp -r src/* AndroidBuild/

.PHONY:download
download:.dwnld

.dwnld:
	touch .dwnld
	mkdir -p AndroidBuild
	(cd AndroidBuild/;repo init -u https://git@bitbucket.org/TinkerBoard_Android/manifest.git -b sbc/tinkerboard/asus/Android-7.1.2;repo sync -j$(THREADS) -c)

~/bin/repo:prereq
	mkdir -p ~/bin
	sudo curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
	chmod a+x ~/bin/repo
	echo 'export PATH="~/bin:$$PATH"' | tee -a ~/.bashrc
	PATH="~/bin:$$PATH"

.PHONY:prereq
prereq:.prereq

.prereq:
	touch .prereq
	sudo apt-get install -y openjdk-8-jdk git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip python lzop libncurses5
	sudo apt-get install -y ccache
	sudo /usr/sbin/update-ccache-symlinks 
	echo 'export PATH="/usr/lib/ccache:$$PATH"' | tee -a ~/.bashrc
	PATH="/usr/lib/ccache:$$PATH"

.PHONY:clean
clean:
	rm -rf AndroidBuild/
	rm -f .prereq
	rm -f .dwnld


