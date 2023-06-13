

#set(SHADER_SRC
#  ${CMAKE_CURRENT_SOURCE_DIR}/shaders/shader.frag
#  ${CMAKE_CURRENT_SOURCE_DIR}/shaders/shader.vert
#)


set(SHADER_SRC "")
set(TEXTURE_FILES "")

get_filename_component(project_name ${CMAKE_CURRENT_SOURCE_DIR} NAME)
message(STATUS "Building project: ${project_name}")


# Gather list of header and source files for compilation
file(GLOB_RECURSE cxx_source_files ${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp)
file(GLOB_RECURSE cxx_header_files ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h)


add_executable(${project_name} ${source_files} ${cxx_source_files} ${cxx_header_files})

target_include_directories(${project_name} PUBLIC ${glfw_INCLUDE_DIRS})
target_include_directories(${project_name} PRIVATE ${Stb_INCLUDE_DIR})
target_include_directories(${project_name} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)

target_link_libraries(${project_name} glm::glm Vulkan::Vulkan glfw)
set_property(TARGET ${project_name} PROPERTY CXX_STANDARD 17)


if(WIN32)
# Add any required preprocessor definitions here
add_definitions(-DVK_USE_PLATFORM_WIN32_KHR)
endif()



# Adding compiling shader command for every shader from SHADER_SRC
# the binary files will be put under output binary folder in shaders sub-folder
foreach(shader ${SHADER_SRC})
  cmake_path(GET shader EXTENSION LAST_ONLY shader_ext)
  string(REPLACE "." "" shader_ext ${shader_ext})
  add_custom_command(
    TARGET ${project_name} 
    POST_BUILD
    COMMAND ${CMAKE_COMMAND}
    ARGS -E make_directory  "$<TARGET_FILE_DIR:${project_name}>/shaders"
    COMMAND ${GLSLC}
    ARGS ${shader} -o "$<TARGET_FILE_DIR:${project_name}>/shaders/${shader_ext}.spv"
    DEPENDS ${SHADER_SRC}
  )
endforeach()

add_custom_command(
    TARGET ${project_name} 
    POST_BUILD
    COMMAND ${CMAKE_COMMAND}
    ARGS -E make_directory  "$<TARGET_FILE_DIR:${project_name}>/textures"
)

foreach(texture_file ${TEXTURE_FILES})
add_custom_command(
    TARGET ${project_name} 
    POST_BUILD
    COMMAND ${CMAKE_COMMAND}
    ARGS -E copy  ${texture_file} "$<TARGET_FILE_DIR:${project_name}>/textures"
    DEPENDS ${TEXTURE_FILES}
  )
endforeach()
