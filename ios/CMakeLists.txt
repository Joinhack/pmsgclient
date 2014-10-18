cmake_minimum_required (VERSION 2.6)
project (pmsg)

add_custom_target(clean-all
   COMMAND ${CMAKE_COMMAND} -P clean-all.cmake
   DEPENDS clean
)

add_subdirectory(src)
add_subdirectory(test)


