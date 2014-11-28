#import <Foundation/Foundation.h>
#import "PMMsgBody.h"
@protocol PMMsgBody;

typedef enum {
	PMMsgSending,
	PMMsgSended,
	PMMsgReceived,
	PMMsgReaded,
} PMMsgState;

@interface PMMsg:NSObject {
}

@property (nonatomic, strong) NSString *id;

@property (nonatomic) NSInteger to;

@property (nonatomic) NSInteger from;

@property (nonatomic) NSInteger type;

@property (nonatomic) PMMsgState state;

@property (nonatomic, strong) NSArray *bodies;

-(void) addMsgBody:(id<PMMsgBody>)body;

-(void) removeMsgBody:(id<PMMsgBody>)body;

@end

