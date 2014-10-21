#import <ChatService/ILoginManager.h>

@interface PMLoginManager : NSObject <ILoginManager>  {
}

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd;

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd withError:(NSError**) err;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*)) completion;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*))completion withQueue:(NSOperationQueue*)queue;

@end
