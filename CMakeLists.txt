cmake_minimum_required(VERSION 3.22)


# Adding our own cmake modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# include vcpkg cmake module
include(vcpkg-utils)

# initialize vcpkg
vcpkg_init()


project(VulkanTutorial LANGUAGES CXX)

#[[
# TODO: Replace hard-coded list of packages with reading from vcpkg.json
# Read packages from vcpkg.json
vcpkg_read_json(${CMAKE_CURRENT_SOURCE_DIR}/vcpkg.json VCPKG_PACKAGES)
#]]

# set the packages to install
set(VCPKG_PACKAGES
  glfw3     # GL Window system
  glm       # OpenGL Mathematics
  Stb       # header only, portable C utility library
  gli       # OpenGL Image
  )

foreach(package ${VCPKG_PACKAGES})
  find_package(${package} REQUIRED)
endforeach()

if(DEFINED ENV{VULKAN_SDK})
set(VULKAN_SDK "$ENV{VULKAN_SDK}")
find_package(Vulkan REQUIRED)
else()
  message(STATUS "VULKAN_SDK variable was not found, trying to find it in the system")
  find_package(Vulkan REQUIRED)
  if(Vulkan_FOUND)
    message(STATUS "Vulkan SDK is found")
  else()
    message(FATAL_ERROR "Vulkan SDK is not found")
  endif()
endif()

add_compile_definitions(HOST_SYSTEM_NAME="${CMAKE_HOST_SYSTEM_NAME}")

find_program(GLSLC NAMES glslc glslc.exe)
if(GLSLC)
  message(STATUS "Found GLSLC compiler ${GLSLC}")
else()
  message(FATAL_ERROR "GSLC compiler is not found")
endif()


option(COMMAND_BUFFER                  "Chapter05/CommandBuffer"                  Yes)
option(TEXTURE_LINEAR_LAYOUT           "Chapter06/TextureLinearLayout"            Yes)


if(COMMAND_BUFFER)
  add_subdirectory(chapter05/CommandBuffer)
endif()

if(TEXTURE_LINEAR_LAYOUT)
  add_subdirectory(chapter11/11a_Texture_LinearLayout)
endif()

