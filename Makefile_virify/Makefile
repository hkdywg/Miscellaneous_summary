
MAKE_TARGET := 

include compilers/tools_path.mak
include compilers/build_flags.mak

TOP_PATH := $(shell pwd)
PRE_MAKE := ${TOP_PATH}/compilers/pre.mak
FINAL_MAKE := ${TOP_PATH}/compilers/final.mak

DIRECTORIES := src

define walk 
$(foreach d,$(wildcard $1/*),$(call walk,$d) $(info *** $d))
endef

rwildcard = $(foreach d,$(wildcard $(1)/*),$(call rwildcard,$d) $(filter %sub_make.mak,$d))

ALL_MAKEFILES := $(call rwildcard,.)

LOCAL_PATH := $(shell pwd)
#include ${LOCAL_PATH}/src/sub_make.mak
include $(ALL_MAKEFILES)

.PHONY:all

all:${MAKE_TARGET}
	@echo make_target is ${MAKE_TARGET}
	@echo build ...

.PHONY:clean

clean:
	-@[ -e src/decoder/src/vx_decoder_lib.o ] && rm src/decoder/src/vx_decoder_lib.o
	-@[ -e src/decoder/src/vx_decoder_lib.d ] && rm src/decoder/src/vx_decoder_lib.d
	-@[ -e src/decoder/test_case/test_main.o ] && rm src/decoder/test_case/test_main.o
	-@[ -e src/decoder/test_case/test_main.d ] && rm src/decoder/test_case/test_main.d
	-@rm *.a
	-@rm src/log/*.o
	-@rm test_case vx_log
