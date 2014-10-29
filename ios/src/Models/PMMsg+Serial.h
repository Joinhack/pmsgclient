#import <Models/PMMsg.h>

@interface PMMsg (Serial)
-(NSString*)toJson:(NSError**)err;

+(id)fromDictionary:(NSDictionary*)dict;

-(NSDictionary*) toDictionary;
@end