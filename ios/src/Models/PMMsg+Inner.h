#import <Models/PMMsg.h>

@interface PMMsg (Serial)
-(NSString*)toJson:(NSError**)err;

+(id)fromDictionary:(NSDictionary*)dict;

-(NSDictionary*) toDictionary;
@end

@interface PMMsg (Persistent) 
@property NSUInteger rowid;
@end