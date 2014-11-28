#import <Foundation/Foundation.h>
#import "PMMsg.h"

@class PMMsg;

typedef enum {
	PMTextMsgBodyType = 1,
	PMImageMsgBodyType,
	PMLocationMsgBodyType,
	PMStickMsgBodyType
} PMMsgBodyType;

@protocol PMMsgBody <NSObject>

@property (nonatomic) PMMsgBodyType type;

@property (nonatomic, weak) PMMsg* msg;

@end



@interface PMMsgBody:NSObject <PMMsgBody> {
}

@property (nonatomic) PMMsgBodyType type;

@property (nonatomic, weak) PMMsg* msg;

@end