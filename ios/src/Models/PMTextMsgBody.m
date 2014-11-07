#import <Models/PMMsgBody.h>
#import <Models/PMTextMsgBody.h>


@implementation PMTextMsgBody:PMMsgBody {
}

+(instancetype)fromDictionary:(NSDictionary*)dict {
	PMTextMsgBody *body = [PMTextMsgBody msgBodyWithContent:dict[@"content"]];
	return body;
}

-(instancetype)init {
	self = [super init];
	self.type = PMTextMsgBodyType;
	return self;
}

+(instancetype)msgBodyWithContent:(NSString*)content {
	return [[PMTextMsgBody alloc] initWithContent:content];
}

-(instancetype)initWithContent:(NSString*)content {
	self = [super init];
	self.type = PMTextMsgBodyType;
	self.content = content;
	return self;
}

-(NSDictionary*) toDictionary {
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	dict[@"type"] = [NSNumber numberWithInt:self.type];
	dict[@"content"] = self.content;
	return dict;
}

@end