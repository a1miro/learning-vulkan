
# retreiving all shader files from shaders sub-folder
file(GLOB_RECURSE SHADER_SRC ${CMAKE_CURRENT_SOURCE_DIR}/shaders/*)

# retrieving all texture files from textures sub-folder
file(GLOB_RECURSE TEXTURE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/textures/*)

# searching for all source files in current directory
file(GLOB_RECURSE CXX_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp)

# searching for all header files in current directory
file(GLOB_RECURSE CXX_HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h)

# retrieving base directory as project name
get_filename_component(projectId ${CMAKE_CURRENT_SOURCE_DIR} NAME)

add_executable(${projectId} ${CXX_SOURCES} ${CXX_HEADERS} ${SHADER_SOURCES})
target_link_libraries(${projectId} glm::glm Vulkan::Vulkan glfw)
target_include_directories(${projectId} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(${projectId} PRIVATE ${glfw_INCLUDE_DIRS})
target_include_directories(${projectId} PRIVATE ${Stb_INCLUDE_DIR})
target_include_directories(${projectId} PRIVATE ${Vulkan_INCLUDE_DIR})
set_property(TARGET ${projectId} PROPERTY CXX_STANDARD 17)

# Adding compiling shader command for every shader from SHADER_SRC
# the binary files will be put under output binary folder in shaders sub-folder
add_custom_command(
    TARGET ${projectId}
    PRE_BUILD
    COMMAND ${CMAKE_COMMAND}
    ARGS -E make_directory  "$<TARGET_FILE_DIR:${projectId}>/shaders"
    COMMAND ${CMAKE_COMMAND}
    ARGS -E make_directory  "$<TARGET_FILE_DIR:${projectId}>/textures"
  )

foreach(shader ${SHADER_SRC})
  cmake_path(GET shader EXTENSION LAST_ONLY shader_ext)
  string(REPLACE "." "" shader_ext ${shader_ext})
  add_custom_command(
    TARGET ${projectId}
    POST_BUILD
    COMMAND ${GLSLC}
    ARGS ${shader} -o "$<TARGET_FILE_DIR:${projectId}>/shaders/${shader_ext}.spv"
    DEPENDS ${shader}
  )
endforeach()

foreach(TEXTURE_FILE ${TEXTURE_FILES})
add_custom_command(
    TARGET ${projectId}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND}
    ARGS -E copy  ${TEXTURE_FILE} "$<TARGET_FILE_DIR:${projectId}>/textures"
    DEPENDS ${TEXTURE_FILE}
  )
endforeach()
