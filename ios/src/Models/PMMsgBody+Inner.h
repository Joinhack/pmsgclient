#import <Models/PMMsgBody.h>

@interface PMMsgBody (Serial)

+(id)fromDictionary:(NSDictionary*)dict;

-(NSString*) toDictionary;
@end