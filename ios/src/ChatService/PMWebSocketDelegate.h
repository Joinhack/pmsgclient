#import <Foundation/Foundation.h>
#import <websocket/SRWebSocket.h>



@interface PMWebSocketDelegate:NSObject <SRWebSocketDelegate> {

}
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;

@end
