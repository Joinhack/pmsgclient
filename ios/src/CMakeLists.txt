SET(CMAKE_C_COMPILER clang)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fobjc-arc ")


include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/src)

SET(SRC_LIST pmsg.m 
	websocket/SRWebSocket.m
	ChatService/PMChatManager.m
	ChatService/PMLoginManager.m
	ChatService/PMMsgManager.m
	ChatService/PMWebSocketDelegate.m
	ChatService/NSMutableURLRequest+Post.m
	Models/PMMsg.m
	Models/PMMsgBody.m
	Models/PMTextMsgBody.m
)



ADD_LIBRARY(pmsg STATIC ${SRC_LIST})

ADD_FRAMEWORK(pmsg Foundation)
ADD_FRAMEWORK(pmsg CFNetwork)
ADD_FRAMEWORK(pmsg Security)

set_target_properties(pmsg PROPERTIES
         ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)