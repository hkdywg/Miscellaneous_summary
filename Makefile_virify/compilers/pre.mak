
SUB_MAKEFILE_NAME := sub_make.mak

SUB_MAKEFILES := $(filter %/$(SUB_MAKEFILE_NAME),${MAKEFILE_LIST})
THIS_MAKEFILE := $(lastword ${SUB_MAKEFILES})
_MODPATH := $(subst /${SUB_MAKEFILE_NAME},,${MAKEFILE_LIST})

$(if $(_MODPATH),,$(error ${MAKEFILE_LIST} failed to get module path))

SDIR := $(_MODPATH)

all-type-files-in = $(notdir $(wildcard $(2)/$(1)))
all-type-files  = $(call all-type-files-in,$(1),$(SDIR))

all-c-files 	= $(call all-type-files,*.c)
all-cpp-files 	= $(call all-type-files,*.cpp)
all-h-files 	= $(call all-type-files,*.h)
all-S-files 	= $(call all-type-files,*.S)

BUILD_OUT = 
MAKE_OUT = $(1)/$(BUILD_OUT)


