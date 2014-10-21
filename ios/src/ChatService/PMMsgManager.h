
@class PMMsg;

@interface PMMsgManager:NSObject <IMsgManager> {

}

@property id<SRWebSocketDelegate> wsDelegate; 

-(NSDictionary*) send:(PMMsg*)msg;

-(NSDictionary*) send:(PMMsg*)msg withError:(NSError**)err;

-(void) asyncSend:(PMMsg*)msg;

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(NSDictionary*,NSError*)) completion;

-(void) reconnect;

@end