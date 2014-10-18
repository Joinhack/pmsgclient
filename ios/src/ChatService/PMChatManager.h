#import <ChatService/IChatManager.h>
#import <websocket/SRWebSocket.h>


@interface PMChatManager : NSObject <IChatManager> {
}

@property (atomic, strong) id<SRWebSocketDelegate> delegate;

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd;

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd withError:(NSError**) err;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*)) completion;

@end

