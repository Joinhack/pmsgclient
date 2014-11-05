SET(CMAKE_C_COMPILER clang)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fobjc-arc")
SET(CMAKE_EXE_LINKER_FLAGS "-all_load")


include_directories(${CMAKE_SOURCE_DIR}/include)

SET(SRC_LIST main.m )

add_executable(main ${SRC_LIST})

add_dependencies(main pmsg)


ADD_FRAMEWORK(main Foundation)
ADD_FRAMEWORK(main CFNetwork)
ADD_FRAMEWORK(main Security)
ADD_FRAMEWORK(main Cocoa)
ADD_FRAMEWORK(main SystemConfiguration)

target_link_libraries(main -L${CMAKE_SOURCE_DIR}/lib pmsg)
target_link_libraries(main pthread)

