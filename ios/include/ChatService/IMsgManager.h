typedef enum  NSInteger {
	CLOSED = 1,
	CONNECTING = 2,
	CONNECTED = 3,
} PMConnectStat;

@protocol IMsgManagerDelegate <NSObject>
@optional
-(void) didConnectStateChange:(PMConnectStat)state from:(PMConnectStat)old;

-(void) didReceiveMsg:(PMMsg*)msg;

- (void)didSendMsg:(PMMsg *)msg
                error:(NSError *)error;

@end

@class PMMsg;

@protocol IMsgManager <NSObject>
@required

-(NSDictionary*) send:(PMMsg*)msg;

-(NSDictionary*) send:(PMMsg*)msg withError:(NSError**)err;

-(void) asyncSend:(PMMsg*)msg;

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(NSDictionary*,NSError*)) completion;

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(NSDictionary*,NSError*)) completion onQueue:(dispatch_queue_t)queue;

-(void) reconnect;
@end