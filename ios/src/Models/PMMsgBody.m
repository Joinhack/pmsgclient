#import "PMMsgBody+Inner.h"
#import "PMTextMsgBody+Inner.h"

@implementation PMMsgBody

+(PMMsgBody*) fromDictionary:(NSDictionary*)dict {
	PMMsgBody *body;
	NSNumber *type = dict[@"type"];
	switch(type.intValue) {
	case PMTextMsgBodyType:
	body = [PMTextMsgBody fromDictionary:dict];
	break;
	}
	return body;
}

@end

