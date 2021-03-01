
COMPILE_TOOL_PATH	 := /opt/toolchain/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
export VISION_APPS_PATH 	 := /home/yinwg/ywg_workspace/psdk_rtos/vision_apps
export PSDK_PATH 			 := /home/yinwg/ywg_workspace/psdk_rtos
export PDK_PATH 			 := /home/yinwg/ywg_workspace/psdk_rtos/pdk_jacinto_07_00_00
export TIOVX_PATH 			 := /home/yinwg/ywg_workspace/psdk_rtos/tiovx
export IMAGING_PATH 		 := /home/yinwg/ywg_workspace/psdk_rtos/imaging

export CC := ${COMPILE_TOOL_PATH}gcc 
export AR := ${COMPILE_TOOL_PATH}ar
export LD := ${COMPILE_TOOL_PATH}g++

COMMON_IDIRS       := $(VISION_APPS_PATH)
COMMON_IDIRS       += $(VISION_APPS_PATH)/utils/remote_service/include
COMMON_IDIRS       += $(VISION_APPS_PATH)/utils/ipc/include
COMMON_IDIRS       += $(PDK_PATH)/packages
COMMON_IDIRS       += $(PSDK_PATH)/xdctools_3_61_00_16_core/packages
COMMON_IDIRS       += $(PSDK_PATH)/bios_6_82_01_19/packages
COMMON_IDIRS 	   += ${TIOVX_PATH}/include
COMMON_IDIRS 	   += ${TIOVX_PATH}/kernels/include
COMMON_IDIRS       += ${TIOVX_PATH}/conformance_tests
COMMON_IDIRS       += ${TIOVX_PATH}/utils/include
COMMON_IDIRS       += ${TIOVX_PATH}/kernels_j7/include
COMMON_IDIRS       += $(VISION_APPS_PATH)/apps/basic_demos/app_tirtos/tirtos_linux/mpu1

export COMMON_IDIRS

COMMON_LDIRS		:= ${VISION_APPS_PATH}/out/J7/A72/LINUX/release 
COMMON_LDIRS 		+= ${TIOVX_PATH}/out/J7/A72/LINUX/release
COMMON_LDIRS 		+= ${IMAGING_PATH}/lib/J7/A72/LINUX/release
COMMON_LDIRS 		+= ${IMAGING_PATH}/lib/J7/R5F/SYSBIOS/release



