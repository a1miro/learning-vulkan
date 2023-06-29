
function(vcpkg_init)
  if(NOT CMAKE_TOOLCHAIN_FILE)
    set(VCPKG_ROOT ${CMAKE_SOURCE_DIR}/vcpkg CACHE PATH "VCPKG root directory" FORCE)
  else()
    # Get VCPKG_RROT from CMAKE_TOOLCHAIN_FILE
    get_filename_component(VCPKG_ROOT ${CMAKE_TOOLCHAIN_FILE} DIRECTORY)
    string(REPLACE "/scripts/buildsystems" "" VCPKG_ROOT ${VCPKG_ROOT})
    set(VCPKG_ROOT ${VCPKG_ROOT} CACHE PATH "VCPKG root directory" FORCE)
  endif()

  # check directory existence
  if(NOT EXISTS ${VCPKG_ROOT}/vcpkg)
    message(STATUS "vcpkg is not initialised, let's run bootstrap-vcpkg")

    if(CMAKE_HOST_SYTEM_NAME STREQUAL "Windows")
      # set(VCPKG_TARGET_TRIPLET "x64-windows" CACHE STRING "VCPKG target triplet" FORCE)
      execute_process(COMMAND ${CMAKE_SOURCE_DIR}/vcpkg/bootstrap-vcpkg.bat)
    else()
      # set(VCPKG_TARGET_TRIPLET "x64-linux" CACHE STRING "VCPKG target triplet" FORCE)
      execute_process(COMMAND ${CMAKE_SOURCE_DIR}/vcpkg/bootstrap-vcpkg.sh)
    endif()
  else()
  endif()

  set(CMAKE_TOOLCHAIN_FILE
    ${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake CACHE FILEPATH
    "VCPKG CMake toolchain file"
    FORCE)

  message(STATUS "CMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")
endfunction()

# function to install package using vcpkg
function(vcpkg_install packages)
  foreach(package ${packages})
    message("Installing ${package} package using vcpkg")
    find_package(${package})

    if(${package}_FOUND)
      message(STATUS "${package} is found")
    else()
      message("Installing ${package} package using vcpkg")
      execute_process(COMMAND vcpkg install ${package})
      find_package(${package} REQUIRED)
    endif()
  endforeach()
endfunction()


