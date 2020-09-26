.PHONY:all
all:flash

.PHONY:flash
flash:convert

.PHONY:convert
convert:build

.PHONY:build
build:copy prereq

.PHONY:copy
copy:download 

.PHONY:download
download:

.PHONY:prereq
prereq:

