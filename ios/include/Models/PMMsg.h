#import <Foundation/Foundation.h>
#import "PMMsgBody.h"
@protocol PMMsgBody;

@interface PMMsg:NSObject {
}

@property (nonatomic, strong) NSString *id;

@property (nonatomic) NSInteger to;

@property (nonatomic) NSInteger type;

@property (nonatomic, strong) NSArray *bodies;

-(void) addMsgBody:(id<PMMsgBody>)body;

-(void) removeMsgBody:(id<PMMsgBody>)body;

@end

