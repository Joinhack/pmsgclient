#import <Foundation/Foundation.h>
#import <Models/PMMsg.h>

@interface PMDBManager : NSObject <NSObject>
-(instancetype)init:(NSString*)db;

-(NSUInteger)saveMsg:(PMMsg*)msg error:(NSError**)err;

-(NSInteger)updateMsg:(PMMsg*)msg withNewId:(NSString*)nid  error:(NSError**)error;

-(NSInteger)seq:(NSInteger)inMem;

@end