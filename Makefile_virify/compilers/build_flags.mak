
BUILD_DEBUG = 
BUILD_QUIET := y

ifeq ($(BUILD_DEBUG),1)
CFLAGS := -std=gnu99 -fPIC -Wall -fms-extensions -Wno-write-strings -Wno-format-security -fno-short-enums -O3 -DNDDEBUG -mlittle-endian \
		  -mcpu=cortex-a72 -Wno-format-truncation -MMD -g
else
CFLAGS := -std=gnu99 -fPIC -Wall -fms-extensions -Wno-write-strings -Wno-format-security -fno-short-enums -O3 -DNDDEBUG -mlittle-endian \
		  -mcpu=cortex-a72 -Wno-format-truncation -MMD
endif

LINK_START_GROUP := -Wl,--start-group
LINK_END_GROUP	:= -Wl,--end-group

ifeq (${BUILD_QUIET},y)
CFLAGS += -s
endif
