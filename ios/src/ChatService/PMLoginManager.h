#import <ChatService/ILoginManager.h>

@interface PMLoginManager : NSObject <ILoginManager>  {
}

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd;

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd withError:(PMError**) err;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,PMError*)) completion;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,PMError*))completion onQueue:(dispatch_queue_t)queue;

@end
