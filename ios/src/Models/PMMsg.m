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
	body.msg = self;
	[bodies	addObject:body];
}

-(void) removeMsgBody:(id<PMMsgBody>)body {
	[bodies	removeObject:body];
}

-(void) dealloc {
	bodies = nil;
}

@end

@implementation PMMsg (Serial)

-(NSDictionary*) toDictionary {
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	dict[@"id"] = self.id;
	dict[@"type"] = [NSNumber numberWithInt:self.type];
	dict[@"to"] = [NSNumber numberWithInt:self.to];
	if(bodies) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		for(id body in bodies) {
			[array addObject:[body toDictionary]];
		}
		dict[@"bodies"] = array;
	}
	return dict;
}

-(NSString*)toJson:(NSError**)error {
	NSError *err;
	NSData *data = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:0 error:&err];
	if(error && err) *error = err;

	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
