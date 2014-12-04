#import <Foundation/Foundation.h>

typedef enum {

	PMNotLogin = 1,

	PMLoginFail,

	PMFollowUserFail,

	PMAcceptUserFail,

	PMRejectUserFail,

	PMInvalidParameter,

	PMConnectionClosed,

	PMTimeout,

	PMUploadFileError,

	PMDBOperatorError,

} ErrorCode;

@interface PMError : NSObject {
}

@property (nonatomic) ErrorCode code;

@property (readonly, nonatomic) NSString *desciption;

-(instancetype)initWithCode:(ErrorCode)code withDescription:(NSString*)description;

+(instancetype)errorWithCode:(ErrorCode)code withDescription:(NSString*)description;

+(instancetype)errorWithCode:(ErrorCode)code withError:(NSError*)error;

@end