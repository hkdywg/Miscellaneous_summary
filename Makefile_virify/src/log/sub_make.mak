include ${PRE_MAKE}

TARGET := vx_log
TARGET_TYPE := exe

LOCAL_PATH := $(shell pwd)

CSOURCE_LIST := main.c
CSOURCE_LIST += print.c
CSOURCE_LIST += log.c

IDIRS += ${LOCAL_PATH} 

include ${FINAL_MAKE}
