
MAKE_TARGET += ${TARGET} 

LOCAL_${TARGET}_PATH := $(lastword $(subst sub_make.mak,,$(filter %sub_make.mak,${MAKEFILE_LIST})))

TARGET_NAME_${TARGET} := ${TARGET}
TARGET_NAME_${TARGET}_TYPE := ${TARGET_TYPE}

${TARGET}_STATIC_LIBS := ${STATIC_LIBS}
${TARGET}_SHARED_LIBS := ${SHARED_LIBS}

${TARGET_NAME_${TARGET}}_IDIRS += ${COMMON_IDIRS} ${IDIRS}
${TARGET_NAME_${TARGET}}_LDIRS += ${COMMON_LDIRS} ${LDIRS}

${TARGET_NAME_${TARGET}}_STATIC_LIBS += ${PLATFORM_STATIC_LIBS} ${${TARGET}_STATIC_LIBS}
${TARGET_NAME_${TARGET}}_SHARED_LIBS += ${SYS_SHARED_LIBS} ${${TARGET}_SHARED_LIBS}

${TARGET_NAME_${TARGET}}_INCLUDES := $(foreach inc,${${TARGET_NAME_${TARGET}}_IDIRS},-I${inc})

LINK_STATIC_LIBS := $(foreach lib,${${TARGET_NAME_${TARGET}}_STATIC_LIBS},${LDIRS}/lib${lib}.a)
LINK_SHARED_LIBS := $(foreach lib,${${TARGET_NAME_${TARGET}}_SHARED_LIBS},${LDIRS}/lib${lib}.so)

${TARGET_NAME_${TARGET}}_LIBRARIES := $(foreach ldir,${${TARGET_NAME_${TARGET}}_LDIRS},-L${ldir}) \
					   -Wl,-Bstatic \
					   ${LINK_START_GROUP} \
					   $(foreach lib,${${TARGET_NAME_${TARGET}}_STATIC_LIBS},-l${lib}) \
					   ${LINK_END_GROUP} \
					   -Wl,-Bdynamic  \
					   $(foreach lib,${${TARGET_NAME_${TARGET}}_SHARED_LIBS},-l$(lib)) 

${TARGET_NAME_${TARGET}}_SRCS := $(addprefix ${LOCAL_${TARGET}_PATH},${CSOURCE_LIST} ${CPPSOURCE_LIST} ${ASSEMBLY_LIST})
${TARGET_NAME_${TARGET}}_OBJS := $(patsubst %.c,%.o,${${TARGET_NAME_${TARGET}}_SRCS})

${TARGET_NAME_${TARGET}}_LINK_EXE := $(LD)  $(${TARGET_NAME_${TARGET}}_OBJS) $(${TARGET_NAME_${TARGET}}_LIBRARIES) -o ${TARGET_NAME_${TARGET}} 
${TARGET_NAME_${TARGET}}_LINK_DSO := ${LD} -shared -Wl,-soname,${TARGET_NAME_${TARGET}} ${TARGET_NAME_${TARGET}}_OBJS 
${TARGET_NAME_${TARGET}}_LINK_LIB := ${AR} -rsc ${TARGET_NAME_${TARGET}} ${${TARGET_NAME_${TARGET}}_OBJS} 

#.PHONY: ${TARGET_NAME_${TARGET}}

#${TARGET_NAME_${TARGET}}: ${${TARGET_NAME_${TARGET}}_OBJS}
#	@echo build ${TARGET_NAME_${TARGET}}


ifeq (${TARGET_NAME_${TARGET}_TYPE},static_library)

define BUILD_OBJ
${${TARGET_NAME_${TARGET}}_OBJS}:${${TARGET_NAME_${TARGET}}_SRCS} 
	echo [GCC] compiling C99 
	$(CC) -std=c99 ${CFLAGS} -c -o $$@  $$< ${${TARGET_NAME_${TARGET}}_INCLUDES} ${${TARGET_NAME_${TARGET}}_LIBRARIES} 
endef

define BUILD_LIB
${TARGET_NAME_${TARGET}}: ${${TARGET_NAME_${TARGET}}_OBJS} ${${TARGET_NAME_${TARGET}}_LIBS}
		@echo Linking $$@
		${${TARGET_NAME_${TARGET}}_LINK_LIB} 
endef

#$(eval $(call BUILD_OBJ))
$(eval $(call BUILD_LIB))

else ifeq (${TARGET_NAME_${TARGET}_TYPE},shared_library)

else ifeq (${TARGET_NAME_${TARGET}_TYPE},exe)

define BUILD_EXE 
${TARGET_NAME_${TARGET}}: ${${TARGET_NAME_${TARGET}}_OBJS} 
	@echo Linking $$@ 
	$(call ${TARGET_NAME_${TARGET}}_LINK_EXE)
endef

#$(eval $(call BUILD_OBJ))
$(eval $(call BUILD_EXE))

endif

%.o: %.c
	$(CC) -std=c99 ${CFLAGS} -c -o $@ $< ${${TARGET_NAME_${TARGET}}_INCLUDES} 

%.o: %.cpp
	$(CP) ${CPPFLAGS} -c -o $@ $< ${${TARGET_NAME_${TARGET}}_INCLUDES} 

%.o: %.S
	${AS} ${AFLAGS} -c -o $@ $< ${${TARGET_NAME_${TARGET}}_INCLUDES} 

