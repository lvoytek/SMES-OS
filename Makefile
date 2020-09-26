.PHONY:all
all:flash

.PHONY:flash
flash:convert

.PHONY:convert
convert:build

.PHONY:build
build:prereq copy

.PHONY:copy
copy:download 

.PHONY:download
download:AndroidBuild
	mkdir AndroidBuild
	(cd AndroidBuild/;repo init -u https://git@bitbucket.org/TinkerBoard_Android/manifest.git -b sbc/tinkerboard/asus/Android-7.1.2;repo sync -j'nproc' -c)

.PHONY:prereq
prereq:~/bin/repo
	sudo apt-get install -y openjdk-8-jdk git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip python lzop libncurses5
	sudo apt-get install -y ccache
	sudo /usr/sbin/update-ccache-symlinks 
	echo 'export PATH="/usr/lib/ccache:$PATH"' | tee -a ~/.bashrc
	source ~/.bashrc
	mkdir ~/bin
	sudo curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
	chmod a+x ~/bin/repo
	echo 'export PATH="~/bin:$PATH"' | tee -a ~/.bashrc
	source ~/.bashrc

