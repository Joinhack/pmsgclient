#import <Models/PMMsgBody.h>

@interface PMMsgBody (Inner)

+(instancetype)fromDictionary:(NSDictionary*)dict;

-(NSString*) toDictionary;

@end