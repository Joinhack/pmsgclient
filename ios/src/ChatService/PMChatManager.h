#import <ChatService/IChatManager.h>
#import <websocket/SRWebSocket.h>

#import "PMLoginManager.h"


@interface PMChatManager:NSObject <IChatManager> {
}

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd;
-(NSDictionary*) login:(NSString*)user :(NSString*)passwd withError:(NSError**) err;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*)) completion;

@end

