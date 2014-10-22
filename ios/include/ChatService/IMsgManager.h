typedef enum  NSInteger {
	CLOSED = 1,
	CONNECTING = 2,
	CONNECTED = 3,
} PMConnectStat;

@protocol IMsgManagerDelegate <NSObject>
@optional
-(void) didConnectStateChange:(PMConnectStat)state from:(PMConnectStat)old;
@end

@class PMMsg;

@protocol IMsgManager <NSObject>
@required

-(NSDictionary*) send:(PMMsg*)msg;

-(NSDictionary*) send:(PMMsg*)msg withError:(NSError**)err;

-(void) asyncSend:(PMMsg*)msg;

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(NSDictionary*,NSError*)) completion;

-(void) reconnect;
@end