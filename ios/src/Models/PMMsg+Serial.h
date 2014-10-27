#import <Models/PMMsg.h>

@interface PMMsg (Serial)
-(NSData*)toJson:(NSError**)err;

+(id)fromDictionary:(NSDictionary*)dict;

-(NSString*) toDictionary;
@end