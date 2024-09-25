cmake_minimum_required(VERSION 3.12)
set(CMAKE_EXPORT_COMPILE_COMMANDS True)

set(PROJECT example-project)

include($ENV{PICO_SDK_PATH}/pico_sdk_init.cmake)
include($ENV{PICO_EXTRAS_PATH}/external/pico_extras_import.cmake)

project(${PROJECT})
pico_sdk_init()

file(GLOB_RECURSE SRCS src/*.cpp src/*.h src/*.c src/*.s)
add_executable(${PROJECT} ${SRCS})

target_include_directories(${PROJECT} PUBLIC ./src ./include)
target_link_libraries(${PROJECT} pico_stdlib)

pico_enable_stdio_usb(${PROJECT} 1)
pico_enable_stdio_uart(${PROJECT} 0)

pico_add_extra_outputs(${PROJECT})
