#import <Foundation/Foundation.h>
#import "ILoginManager.h"
#import "IMsgManager.h"


@protocol IChatManagerDelegate <ILoginManagerDelegate>
@end

@protocol IChatManager <ILoginManager, IMsgManager>
@required

-(void)addDelegate:(id<IChatManagerDelegate>)delegate :(dispatch_queue_t)queue;

-(void)removeDelegate:(id<IChatManagerDelegate>)delegate;

-(NSArray*)delegates;

-(void)invokeDelegate:(NSString*)method, ...;
@end
