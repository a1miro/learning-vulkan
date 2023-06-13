cmake_minimum_required(VERSION 3.22)

if(DEFINED ENV{VCPKG_ROOT})
  message(STATUS "Found VCPKG_ROOT=$ENV{VCPKG_ROOT}")
  set(vcpkg_root "$ENV{VCPKG_ROOT}")
  set(CMAKE_TOOLCHAIN_FILE ${vcpkg_root}/scripts/buildsystems/vcpkg.cmake CACHE FILEPATH "" FORCE)
else()
  message(
    [[
    VCPKG_ROOT was not found,
    I highly recommend to install VCPKG and set VCPKG_ROOT, it can be done for Winows, MacOS and Linux.
    Please follow isntructions from this page https://vcpkg.io/en/getting-started.html,
    overwise you have to install manually the following packages:

    glm         OpenGL Mathematics
    glfw3       Free, open-source GL Window system
    stb         header only, portable C utility library
    ]])
endif()

project(VulkanTutorial LANGUAGES CXX)

if(DEFINED ENV{VULKAN_SDK})
  message(STATUS "VULKAN_SDK environment variable is found here: $ENV{VULKAN_SDK}")
else()
  message(STATUS "VULKAN_SDK variable is not found, checking if the package is installed")
endif()

if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Linux")
  add_compile_definitions(HOST_SYSTEM_NAME="Linux")
endif()

if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
  add_compile_definitions(HOST_SYSTEM_NAME="Windows")
endif()

if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin")
  add_compile_definitions(HOST_SYSTEM_NAME="Darwin")
endif()


find_program(GLSLC NAMES glslc glslc.exe)
if(GLSLC)
  message(STATUS "Found GLSLC compiler ${GLSLC}")
else()
  message(FATAL_ERROR "GSLC compiler is not found")
endif()

find_package(Vulkan REQUIRED)
find_package(glfw3 REQUIRED)
find_package(glm REQUIRED)
find_package(Stb REQUIRED)

option(HAND_SHAKE                  "Chapter 3, Shaking Hands with the Device"                  Yes)

if(BASE_CODE)
  add_subdirectory(base_code)
endif()

if(INSTANCE_CREATION)
  add_subdirectory(instance_creation)
endif()

if(VALIDATION_LAYERS)
  add_subdirectory(validation_layers)
endif()

if(PHYSICAL_DEVICE_SELECTION)
  add_subdirectory(physical_device_selection)
endif()

if(LOGICAL_DEVICE)
  add_subdirectory(logical_device)
endif()

if(WINDOW_SURFACE)
  add_subdirectory(window_surface)
endif()

if(SWAP_CHAIN)
  add_subdirectory(swap_chain)
endif()

if(IMAGE_VIEWS)
  add_subdirectory(swap_chain)
endif()

if(GRAPHICS_PIPELINE)
  add_subdirectory(swap_chain)
endif()

if(SHADER_BASE)
  add_subdirectory(shader_base)
endif()

if(FIXED_FUNCTIONS)
  add_subdirectory(fixed_functions)
endif()

if(HELLO_TRIANGLE)
  add_subdirectory(hello_triangle)
endif()

if(TEXTURE_MAPPING)
  add_subdirectory(texture_mapping)
endif()


if(LIST_PHYSICAL_DEVICES)
  add_subdirectory(list_physical_devices)
endif()

