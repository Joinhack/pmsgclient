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

-(PMMsg*) send:(PMMsg*)msg;

-(PMMsg*) send:(PMMsg*)msg withError:(NSError**)err;

-(void) asyncSend:(PMMsg*)msg;

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(PMMsg*,NSError*)) completion;

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(PMMsg*,NSError*)) completion onQueue:(dispatch_queue_t)queue;

-(void) reconnect;
@end