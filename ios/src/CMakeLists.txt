SET(CMAKE_C_COMPILER clang)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fobjc-arc")


include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/src)

SET(SRC_LIST pmsg.m 
	ChatService/PMChatManager.m
	ChatService/PMWebSocketDelegate.m
	Models/PMMsg.m
	Models/PMMsgBody.m
	Models/PMTextMsgBody.m
)

ADD_LIBRARY(pmsg STATIC ${SRC_LIST})

set_target_properties(pmsg PROPERTIES
         ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)