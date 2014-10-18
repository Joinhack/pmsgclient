SET(CMAKE_C_COMPILER clang)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fobjc-arc")


include_directories(${CMAKE_SOURCE_DIR}/include)

SET(SRC_LIST main.m )

add_executable(main ${SRC_LIST})

add_dependencies(main pmsg)

target_link_libraries(main -L${CMAKE_SOURCE_DIR}/lib pmsg)
