PLATFORM_CC             = gcc
PLATFORM_AR             = ar
PLATFORM_OS             = linux
PLATFORM_NETWORK        = linuxsock
PLATFORM_SSL            = mbedtls

SETTING_VARS := \
    BUILD_TYPE \
    PLATFORM_CC \
    PLATFORM_AR \
    PLATFORM_OS \
    PLATFORM_NETWORK \
    PLATFORM_SSL \
    FEATURE_DIRECT_MQTT \
    FEATURE_DIRECT_MQTT_NOTLS \

$(foreach v, \
    $(SETTING_VARS), \
    $(eval export $(v)=$($(v))) \
)

include build-rules/settings.mk
sinclude $(CONFIG_TPL)

ifeq (debug,$(strip $(BUILD_TYPE)))
CFLAGS  += -DALIOT_DEBUG
endif

ifeq (y,$(strip $(FEATURE_DIRECT_MQTT)))
CFLAGS  += -DDIRECT_MQTT
ifeq (y,$(strip $(FEATURE_DIRECT_MQTT_NOTLS)))
CFLAGS  += -DALIOT_MQTT_TCP
endif

else    # ifeq (y,$(strip $(FEATURE_DIRECT_MQTT)))

ifeq (y,$(strip $(FEATURE_DIRECT_MQTT_NOTLS)))
$(error FEATURE_DIRECT_MQTT_NOTLS = y requires FEATURE_DIRECT_MQTT = y!)
endif

endif   # ifeq (y,$(strip $(FEATURE_DIRECT_MQTT)))

ifneq ($(subst gcc,,$(PLATFORM_CC)),$(subst ar,,$(PLATFORM_AR)))
$(error PLATFORM_CC and PLATFORM_AR requires same prefix!)
endif

CROSS_PREFIX        := $(shell echo "$(strip $(PLATFORM_CC))"|sed 's:gcc::1')
