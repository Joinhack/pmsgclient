#import <ChatService/IChatManager.h>
#import <websocket/SRWebSocket.h>

#import "PMLoginManager.h"

@interface DelegatePair:NSObject {
}
@property id<IChatManagerDelegate> delegate;
@property dispatch_queue_t queue;
-(id)init:(id<IChatManagerDelegate>)d :(dispatch_queue_t)q;
@end

@interface PMChatManager:NSObject <IChatManager> {
}

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd;

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd withError:(NSError**) err;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*)) completion;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*))completion onQueue:(dispatch_queue_t)queue;

-(void)invokeDelegate:(NSString*)method, ...;

-(void)addDelegate:(id<IChatManagerDelegate>)delegate :(dispatch_queue_t)queue;

-(void)removeDelegate:(id<IChatManagerDelegate>)delegate;

-(NSUInteger)saveMsg:(PMMsg*)msg error:(NSError**)err;

-(NSInteger)updateMsg:(PMMsg*)msg withNewId:(NSString*)nid error:(NSError**)err;

-(NSInteger)seq;

@end

