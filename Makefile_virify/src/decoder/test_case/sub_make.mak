
include ${PRE_MAKE}

TARGET := test_case
TARGET_TYPE := exe

LOCAL_PATH := $(shell pwd)
CSOURCE_LIST := test_main.c
IDIRS 	+= ${LOCAL_PATH}/src/decoder/inc
LDIRS  	+= ${LOCAL_PATH}

STATIC_LIBS += vx_decoder_mul

include ${FINAL_MAKE}
