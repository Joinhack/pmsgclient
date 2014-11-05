#import <Models/PMMsg.h>

@interface PMMsg (Inner)
-(NSString*)toJson:(NSError**)err;

+(id)fromDictionary:(NSDictionary*)dict;

@property NSUInteger rowid;

-(NSDictionary*) toDictionary;
@end

