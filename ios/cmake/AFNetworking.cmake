MACRO (AFNetworkingBuild)
	SET(AFNetworking_LIBRARY  AFNetworking)
  SET(AFNetworking_INC_DIRS 
  	${CMAKE_SOURCE_DIR}/deps/AFNetworking/AFNetworking
  )
  file(GLOB files "${CMAKE_SOURCE_DIR}/deps/AFNetworking/AFNetworking/*.m")
  FOREACH(file ${files})
    SET(AFNetworking_SOURCES ${AFNetworking_SOURCES} ${file})
  ENDFOREACH()

  SET(CMAKE_C_COMPILER clang)

	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc")
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fobjc-arc ")
	ADD_LIBRARY(AFNetworking STATIC ${AFNetworking_SOURCES})


	set_target_properties(AFNetworking PROPERTIES
         ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)

ENDMACRO()

AFNetworkingBuild()
