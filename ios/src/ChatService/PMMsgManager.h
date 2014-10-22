
@class PMMsg;

@interface PMMsgManager:NSObject <IMsgManager, SRWebSocketDelegate> {

}

@property (atomic, strong) NSMutableDictionary *sendingMsgs;

@property (atomic) PMConnectStat connectState;

-(NSDictionary*) send:(PMMsg*)msg;

-(NSDictionary*) send:(PMMsg*)msg withError:(NSError**)err;

-(void) asyncSend:(PMMsg*)msg;

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(NSDictionary*,NSError*)) completion;

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;

-(void) reconnect;

@end