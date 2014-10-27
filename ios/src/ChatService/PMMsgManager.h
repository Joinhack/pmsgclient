
@class PMMsg;

@interface PMMsgManager:NSObject <IMsgManager, SRWebSocketDelegate> {

}

@property (atomic) PMConnectStat connectState;

-(PMMsg*) send:(PMMsg*)msg;

-(PMMsg*) send:(PMMsg*)msg withError:(NSError**)err;

-(void) asyncSend:(PMMsg*)msg;

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(PMMsg*,NSError*)) completion;

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;

-(void) reconnect;

@end