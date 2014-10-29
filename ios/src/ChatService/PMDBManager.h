#import <Foundation/Foundation.h>
#import <Models/PMMsg.h>

@interface PMDBManager : NSObject <NSObject>
-(bool)createMsgTable:(NSInteger)type :(NSInteger)id;

-(long)saveMsg:(PMMsg*)msg;
@end