enable_testing()
find_package(Check REQUIRED)
include_directories(${CHECK_INCLUDE_DIRS})
include_directories(. ../src ../include/)
link_directories(${CHECK_LIBRARY_DIRS})

add_executable(check_fb EXCLUDE_FROM_ALL check_fb.c)
add_dependencies(check_fb optv)

add_executable(check_calibration EXCLUDE_FROM_ALL check_calibration.c)
add_dependencies(check_calibration optv)

add_executable(check_parameters EXCLUDE_FROM_ALL check_parameters.c)
add_dependencies(check_parameters optv)

add_executable(check_lsqadj EXCLUDE_FROM_ALL check_lsqadj.c)
add_dependencies(check_lsqadj optv)

add_executable(check_ray_tracing EXCLUDE_FROM_ALL check_ray_tracing.c)
add_dependencies(check_ray_tracing optv)

add_executable(check_trafo EXCLUDE_FROM_ALL check_trafo.c)
add_dependencies(check_trafo optv)

add_executable(check_vec_utils EXCLUDE_FROM_ALL check_vec_utils.c)
add_dependencies(check_vec_utils optv)

add_executable(check_image_proc EXCLUDE_FROM_ALL check_image_proc.c)
add_dependencies(check_image_proc optv)

add_executable(check_multimed EXCLUDE_FROM_ALL check_multimed.c)
add_dependencies(check_multimed optv)

add_executable(check_imgcoord EXCLUDE_FROM_ALL check_imgcoord.c)
add_dependencies(check_imgcoord optv)

add_executable(check_orientation EXCLUDE_FROM_ALL check_orientation.c)
add_dependencies(check_orientation optv)

add_executable(check_epi EXCLUDE_FROM_ALL check_epi.c)
add_dependencies(check_epi optv)

get_property(OPTV_LIBRARY TARGET optv PROPERTY LOCATION)
set(LIBS ${LIBS} ${CHECK_LIBRARIES} ${OPTV_LIBRARY})

# Satysfy the new dynamic linker rules on Linux.
if (UNIX)
    set(LIBS ${LIBS} -lm -pthread)
endif (UNIX)

target_link_libraries(check_fb ${LIBS})
add_test(check_fb ${CMAKE_CURRENT_BINARY_DIR}/check_fb)

add_custom_command(TARGET check_fb PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR}/testing_fodder $<TARGET_FILE_DIR:check_fb>/testing_fodder)

target_link_libraries(check_vec_utils ${LIBS})
add_test(check_vec_utils ${CMAKE_CURRENT_BINARY_DIR}/check_vec_utils)

add_custom_command(TARGET check_vec_utils PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR}/testing_fodder $<TARGET_FILE_DIR:check_vec_utils>/testing_fodder)

target_link_libraries(check_calibration ${LIBS})
add_test(check_calibration ${CMAKE_CURRENT_BINARY_DIR}/check_calibration)

add_custom_command(TARGET check_calibration PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR}/testing_fodder $<TARGET_FILE_DIR:check_calibration>/testing_fodder)

target_link_libraries(check_parameters ${LIBS})
add_test(check_parameters ${CMAKE_CURRENT_BINARY_DIR}/check_parameters)

add_custom_command(TARGET check_parameters PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR}/testing_fodder $<TARGET_FILE_DIR:check_parameters>/testing_fodder)

target_link_libraries(check_lsqadj ${LIBS})
add_test(check_lsqadj ${CMAKE_CURRENT_BINARY_DIR}/check_lsqadj)

add_custom_command(TARGET check_lsqadj PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR}/testing_fodder $<TARGET_FILE_DIR:check_lsqadj>/testing_fodder)
 
 
target_link_libraries(check_ray_tracing ${LIBS})
add_test(check_ray_tracing ${CMAKE_CURRENT_BINARY_DIR}/check_ray_tracing)
    
add_custom_command(TARGET check_ray_tracing PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR}/testing_fodder $<TARGET_FILE_DIR:check_ray_tracing>/testing_fodder)
    
    
target_link_libraries(check_trafo ${LIBS})
add_test(check_trafo ${CMAKE_CURRENT_BINARY_DIR}/check_trafo)
    
add_custom_command(TARGET check_trafo PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR}/testing_fodder $<TARGET_FILE_DIR:check_trafo>/testing_fodder)   
    
    
target_link_libraries(check_image_proc ${LIBS})
add_test(check_image_proc ${CMAKE_CURRENT_BINARY_DIR}/check_image_proc)

target_link_libraries(check_multimed ${LIBS})
add_test(check_multimed ${CMAKE_CURRENT_BINARY_DIR}/check_multimed)

add_custom_command(TARGET check_multimed PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR}/testing_fodder $<TARGET_FILE_DIR:check_multimed>/testing_fodder)
    
target_link_libraries(check_imgcoord ${LIBS})
add_test(check_imgcoord ${CMAKE_CURRENT_BINARY_DIR}/check_imgcoord)

target_link_libraries(check_orientation ${LIBS})
add_test(check_orientation ${CMAKE_CURRENT_BINARY_DIR}/check_orientation)

target_link_libraries(check_epi ${LIBS})
add_test(check_epi ${CMAKE_CURRENT_BINARY_DIR}/check_epi)
 
add_custom_command(TARGET check_orientation PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR}/testing_fodder $<TARGET_FILE_DIR:check_orientation>/testing_fodder)
    
add_custom_target(verify COMMAND ${CMAKE_CTEST_COMMAND})
add_dependencies(verify check_fb check_calibration check_parameters check_lsqadj \ 
check_ray_tracing check_trafo check_vec_utils check_image_proc check_multimed \ 
check_imgcoord check_orientation check_epi)

