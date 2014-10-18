#import <Foundation/Foundation.h>
#import "PMMsg.h"

@class PMMsg;

typedef enum : NSInteger {
	PMTextMsgBodyType = 0,
	PMImageMsgBodyType,
	PMLocationMsgBodyType,
	PMStickMsgBodyType
} PMMsgType;

@protocol PMMsgBody <NSObject>

@property (nonatomic) PMMsgType msgType;

@end



@interface PMMsgBody:NSObject <PMMsgBody> {
}

@property (nonatomic) PMMsgType msgType;

@property (nonatomic, weak) PMMsg* msg;

@end