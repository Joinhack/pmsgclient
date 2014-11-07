#import <Models/PMMsg.h>
#import <Models/PMImageMsgBody.h>

@interface PMImageMsgBody (Inner)
-(NSString*)toJson:(NSError**)err;

+(id)fromDictionary:(NSDictionary*)dict;

-(BOOL)isLocalUrl;

-(void)setIsLocalUrl:(BOOL)b;

-(NSDictionary*) toDictionary;
@end
