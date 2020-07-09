#
# Component Cmake
#
message("Enter component.cmake")

if(CONFIG_STDK_IOT_CORE)
	set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" include include/bsp include/os include/mqtt)
	set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" include/external)

	if(CONFIG_STDK_IOT_CORE_BSP_SUPPORT_ESP8266)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/bsp/esp8266)
		set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" include/bsp/esp8266)
	elseif(CONFIG_STDK_IOT_CORE_BSP_SUPPORT_ESP32)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/bsp/esp32)
		set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" include/bsp/esp32)
	elseif(CONFIG_STDK_IOT_CORE_BSP_SUPPORT_RTL8195)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/bsp/rtl8195)
		set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" include/bsp/rtl8195)
	elseif(CONFIG_STDK_IOT_CORE_BSP_SUPPORT_RTL8720C)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/bsp/rtl8720c)
		set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" include/bsp/rtl8720c)
	elseif(CONFIG_STDK_IOT_CORE_BSP_SUPPORT_RTL8721C)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/bsp/rtl8721c)
		set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" include/bsp/rtl8721c)
	elseif(CONFIG_STDK_IOT_CORE_BSP_SUPPORT_MT7682)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/bsp/mt7682)
		set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" include/bsp/mt7682)
	elseif(CONFIG_STDK_IOT_CORE_BSP_SUPPORT_EMW3166)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/bsp/emw3166)
		set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" include/bsp/emw3166)
	elseif(CONFIG_STDK_IOT_CORE_BSP_SUPPORT_LPC54018)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/bsp/lpc54018)
		set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" include/bsp/lpc54018)
	else()
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/bsp/posix)
		set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" include/bsp/posix)
	endif()

	if(CONFIG_STDK_IOT_CORE_USE_MBEDTLS)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/net/mbedtls)
		set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" port/net/mbedtls)
	else()
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/net/openssl)
		set(COMPONENT_ADD_INCLUDEDIRS "${COMPONENT_ADD_INCLUDEDIRS}" port/net/openssl)
	endif()

	if(CONFIG_STDK_IOT_CORE_OS_SUPPORT_FREERTOS)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/os/freertos)
	elseif(CONFIG_STDK_IOT_CORE_OS_SUPPORT_TIZENRT)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/os/tizenrt)
	elseif(CONFIG_STDK_IOT_CORE_OS_SUPPORT_POSIX)
		set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" port/os/posix)
	endif()

	set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" security)
	set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" easysetup)
	set(COMPONENT_SRCDIRS "${COMPONENT_SRCDIRS}" mqtt)


	include_directories(${COMPONENT_PATH}/include/iot_common.h)

	set(BOILERPLATE_HEADER ${COMPONENT_PATH}/include/certs/boilerplate.h)
		file(GLOB ROOT_CA_FILE_LIST "${COMPONENT_PATH}/certs/root_ca_*.pem")
	set(ROOT_CA_FILE ${COMPONENT_PATH}/certs/root_ca.pem)
	set(ROOT_CA_SOURCE ${COMPONENT_PATH}/iot_root_ca.c)
	add_custom_command(
			PRE_BUILD
			OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/${ROOT_CA_SOURCE}
			COMMENT "Generating root certiciate"
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
			COMMAND if [ -e ${ROOT_CA_FILE} ] \; then rm ${ROOT_CA_FILE} \; fi \;
			COMMAND cat ${ROOT_CA_FILE_LIST} >> ${ROOT_CA_FILE}
			COMMAND cat ${BOILERPLATE_HEADER} > ${ROOT_CA_SOURCE}
			COMMAND xxd -i ${ROOT_CA_FILE} >> ${ROOT_CA_SOURCE}
			COMMAND sed -i.bak 's/cert.*_pem/st_root_ca/g' ${ROOT_CA_SOURCE}
			COMMAND sed -i.bak 's/unsigned/const unsigned/g' ${ROOT_CA_SOURCE}
			COMMAND rm -f ${ROOT_CA_SOURCE}.bak
			COMMAND rm -f ${ROOT_CA_FILE}
			BYPRODUCTS ${CMAKE_CURRENT_SOURCE_DIR}/${ROOT_CA_SOURCE}
			)

	set(CMAKE_C_STANDARD 99)
else()
	message("Fail to find SDK config")
# Disable SmartThing Device SDK support
	set(COMPONENT_ADD_INCLUDEDIRS "")
	set(COMPONENT_SRCDIRS "")
endif()
