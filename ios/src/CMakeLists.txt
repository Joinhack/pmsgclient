SET(CMAKE_C_COMPILER clang)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fobjc-arc ")


include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/deps/AFNetworking/AFNetworking)
include_directories(${CMAKE_SOURCE_DIR}/src)

file(GLOB ChatServiceSRC "ChatService/*.m")
FOREACH(
file ${ChatServiceSRC}
)
SET(SRC_LIST ${SRC_LIST} ${file})
ENDFOREACH()

file(GLOB ModelsSRC "Models/*.m")
FOREACH(
file ${ModelsSRC}
)
SET(SRC_LIST ${SRC_LIST} ${file})
ENDFOREACH()

SET(SRC_LIST ${SRC_LIST} pmsg.m 
	websocket/SRWebSocket.m
)


ADD_LIBRARY(pmsg STATIC ${SRC_LIST})


add_dependencies(pmsg AFNetworking)

target_link_libraries(pmsg -L${CMAKE_SOURCE_DIR}/lib AFNetworking)

TARGET_LINK_LIBRARIES(pmsg sqlite3)


set_target_properties(pmsg PROPERTIES
         ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)