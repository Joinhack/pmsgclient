#import <Foundation/Foundation.h>
#import <Models/PMMsg.h>

@interface PMDBManager : NSObject <NSObject>
-(instancetype)init:(NSString*)db;

-(NSUInteger)saveMsg:(PMMsg*)msg error:(PMError**)err;

-(NSInteger)updateMsg:(PMMsg*)msg withNewId:(NSString*)nid  error:(PMError**)error;

-(NSInteger)seq:(NSInteger)inMem;

@end