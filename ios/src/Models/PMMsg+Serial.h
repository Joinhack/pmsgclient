#import <Models/PMMsg.h>

@interface PMMsg (Serial)
-(NSData*)toJson:(NSError**)err;

-(NSString*) toDictionary;
@end