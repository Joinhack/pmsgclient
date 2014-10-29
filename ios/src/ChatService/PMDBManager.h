#import <Foundation/Foundation.h>
#import <Models/PMMsg.h>

@interface PMDBManager : NSObject <NSObject>
-(id)init:(NSString*)db;

-(NSInteger)saveMsg:(PMMsg*)msg error:(NSError**)err;

-(NSInteger)seq:(NSInteger)inMem;

@end