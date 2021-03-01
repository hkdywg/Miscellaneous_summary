PLATFORM_STATIC_LIBS := vx_tiovx_tests vx_conformance_tests vx_conformance_engine vx_conformance_tests_testmodule
PLATFORM_STATIC_LIBS += vx_vxu vx_framework
PLATFORM_STATIC_LIBS += vx_platform_psdk_j7_linux
PLATFORM_STATIC_LIBS += vx_kernels_openvx_core
PLATFORM_STATIC_LIBS += vx_kernels_test_kernels_tests vx_kernels_test_kernels
PLATFORM_STATIC_LIBS += vx_kernels_host_utils
PLATFORM_STATIC_LIBS += vx_kernels_target_utils
PLATFORM_STATIC_LIBS += vx_kernels_hwa_tests vx_kernels_hwa vx_tiovx_tidl_tests vx_kernels_tidl
PLATFORM_STATIC_LIBS += vx_framework vx_utils vx_tutorial
PLATFORM_STATIC_LIBS += app_utils_mem
PLATFORM_STATIC_LIBS += app_utils_console_io
PLATFORM_STATIC_LIBS += app_utils_ipc
PLATFORM_STATIC_LIBS += app_utils_remote_service
PLATFORM_STATIC_LIBS += app_tirtos_linux_mpu1_common
PLATFORM_STATIC_LIBS += app_utils_draw2d
PLATFORM_STATIC_LIBS += app_utils_mem
PLATFORM_STATIC_LIBS += app_utils_ipc
PLATFORM_STATIC_LIBS += itt_server
PLATFORM_STATIC_LIBS += network_api
PLATFORM_STATIC_LIBS += app_utils_console_io
PLATFORM_STATIC_LIBS += app_utils_remote_service
PLATFORM_STATIC_LIBS += app_utils_perf_stats
PLATFORM_STATIC_LIBS += app_utils_iss
PLATFORM_STATIC_LIBS += app_utils_grpx
PLATFORM_STATIC_LIBS += app_tirtos_linux_mpu1_common
PLATFORM_STATIC_LIBS += vx_kernels_imaging
PLATFORM_STATIC_LIBS += vx_target_kernels_imaging_aewb
PLATFORM_STATIC_LIBS += vx_kernels_img_proc
PLATFORM_STATIC_LIBS += vx_kernels_fileio
PLATFORM_STATIC_LIBS += vx_target_kernels_fileio

export PLATFORM_STATIC_LIBS 

SYS_SHARED_LIBS := pthread
SYS_SHARED_LIBS += stdc++
SYS_SHARED_LIBS += rt

export SYS_SHARED_LIBS


