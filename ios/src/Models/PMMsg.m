#import <Models/PMMsg.h>

@implementation PMMsg {
	NSMutableArray *bodies;
}

@synthesize bodies = bodies;

-(id)init {
	bodies = [[NSMutableArray alloc] init];
	return self;
}

-(void) addMsgBody:(id<PMMsgBody>)body {
	[bodies	addObject:body];
}

-(void) removeMsgBody:(id<PMMsgBody>)body {
	[bodies	removeObject:body];
}

-(void) dealloc {
	bodies = nil;
}

@end