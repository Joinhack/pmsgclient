#import <Models/PMMsg.h>
#import <Models/PMImageMsgBody.h>

@interface PMImageMsgBody (Inner)
-(NSString*)toJson:(NSError**)err;

+(id)fromDictionary:(NSDictionary*)dict;

-(BOOL)isLocalUrl;

-(NSDictionary*) toDictionary;
@end
