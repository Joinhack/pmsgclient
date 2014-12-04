#import <Foundation/Foundation.h>
#import "ILoginManager.h"
#import "IMsgManager.h"
#import "IContactManager.h"

@protocol IChatManagerDelegate <ILoginManagerDelegate>
@end

@protocol IChatManager <ILoginManager, 
												IMsgManager,
												IContactManager
												>
@required

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(PMMsg*,PMError*))completion withProgress:(void(^)(id<PMMsgBody>, NSUInteger, NSUInteger))progress onQueue:(dispatch_queue_t)queue;

-(void)addDelegate:(id<IChatManagerDelegate>)delegate :(dispatch_queue_t)queue;

-(void)removeDelegate:(id<IChatManagerDelegate>)delegate;

-(NSArray*)delegates;

-(void)invokeDelegate:(NSString*)method, ...;
@end
