SET(CMAKE_C_COMPILER clang)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fobjc-arc ")


include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/deps/AFNetworking/AFNetworking)
include_directories(${CMAKE_SOURCE_DIR}/src)

SET(SRC_LIST pmsg.m 
	websocket/SRWebSocket.m
	ChatService/PMChatManager.m
	ChatService/PMLoginManager.m
	ChatService/PMMsgManager.m
	ChatService/PMDBManager.m
	ChatService/NSMutableURLRequest+Post.m
	Models/PMMsg.m
	Models/PMMsgBody.m
	Models/PMTextMsgBody.m
	Models/PMImageMsgBody.m
	Models/PMLocationMsgBody.m
)

ADD_LIBRARY(pmsg STATIC ${SRC_LIST})


add_dependencies(pmsg AFNetworking)

target_link_libraries(pmsg -L${CMAKE_SOURCE_DIR}/lib AFNetworking)

TARGET_LINK_LIBRARIES(pmsg sqlite3)


set_target_properties(pmsg PROPERTIES
         ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)