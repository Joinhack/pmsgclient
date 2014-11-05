#import <Models/PMMsgBody.h>

@interface PMMsgBody (Inner)

+(id)fromDictionary:(NSDictionary*)dict;

-(NSString*) toDictionary;

@end