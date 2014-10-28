#import <Models/PMMsgBody.h>
#import <Models/PMLocationMsgBody.h>


@implementation PMLocationMsgBody:PMMsgBody {
}

+(id)fromDictionary:(NSDictionary*)dict {
	PMLocationMsgBody *body = [[PMLocationMsgBody alloc] init:dict[@"lat"] :dict[@"lng"] :dict[@"addr"]];
	return body;
}

-(id)init {
	self = [super init];
	if(self) {
		self.type = PMLocationMsgBodyType;
	}
	return self;
}

-(id)init:(NSNumber*)lat :(NSNumber*)lng :(NSString*)addr {
	self = [super init];
	if(self) {
		self.type = PMLocationMsgBodyType;
		self.lat = lat;
		self.lng = lng;
		self.address = addr;
	}
	return self;
}

-(NSDictionary*) toDictionary {
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	dict[@"type"] = [NSNumber numberWithInt:self.type];
	dict[@"lat"] = self.lat;
	dict[@"lng"] = self.lng;
	if(self.address)
		dict[@"address"] = self.address;
	return dict;
}

@end