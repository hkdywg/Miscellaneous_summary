
include ${PRE_MAKE} 

TARGET := libvx_decoder_mul.a
TARGET_TYPE := static_library

LOCAL_PATH :=  $(shell pwd)
CSOURCE_LIST := src/vx_decoder_lib.c

LOCAL_PATH := $(shell pwd)
IDIRS 		+= ${LOCAL_PATH}/src/decoder/inc

CFLAGS 		+= $(patsubst %,-I%,${IDIRS})
LDFLAGS 	+= $(patsubst %,-L%,${LDIRS}) 

include ${FINAL_MAKE}
