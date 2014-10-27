#import <Models/PMMsg.h>
#import "PMMsgBody+Serial.h"
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


+(id) fromDictionary:(NSDictionary*)dict {
	NSString *msgId = dict[@"id"];
	NSNumber *to = dict[@"to"];
	NSNumber *type = dict[@"type"];
	if(to == nil || to.intValue == 0) {
		return nil;
	}
	if(type == nil || type.intValue == 0) {
		return nil;
	}
	PMMsg *msg  = [[PMMsg alloc] init];
	msg.to = to.intValue;
	if(dict[@"bodies"]) {
		NSMutableArray *bodies = [[NSMutableArray alloc] init];
		id msgBody;
		for(NSDictionary *bodyDict in dict[@"bodies"]) {
			msgBody = [PMMsgBody fromDictionary:bodyDict];
			if(msgBody)
				[bodies addObject:msgBody];
		}
		msg.bodies = bodies;
	}
	return msg;
}

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
