#import <Models/PMMsgBody.h>
#import <Models/PMImageMsgBody.h>


@implementation PMImageMsgBody:PMMsgBody {
	BOOL _isLocalUrl;
}

+(id)fromDictionary:(NSDictionary*)dict {
	PMImageMsgBody *body = [[PMImageMsgBody alloc] init];
	body.scaledUrl = dict[@"surl"];
	body.url = dict[@"url"];
	body.name = dict[@"name"];
	return body;
}

-(id)init {
	self = [super init];
	_isLocalUrl = NO;
	self.type = PMImageMsgBodyType;
	return self;
}

+(id)localFile:(NSString*)path {
	PMImageMsgBody *body = [[PMImageMsgBody alloc] init];
	body.url = path;
	body.isLocalUrl = YES;
	return body;
}

-(void)setIsLocalUrl:(BOOL)b {
	_isLocalUrl = b;
}

-(BOOL)isLocalUrl {
	return _isLocalUrl;
}

-(NSDictionary*) toDictionary {
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	dict[@"type"] = [NSNumber numberWithInt:self.type];
	dict[@"url"] = self.url;
	dict[@"surl"] = self.scaledUrl;
	if(self.name)
		dict[@"name"] = self.name;
	return dict;
}

@end