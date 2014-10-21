typedef enum  NSInteger {
	CLOSED = 0,
	CONNECTING = 1,
	CONNECTED = 2,
} PMConnectStat;

@protocol IMsgManagerDelegate <NSObject>
@optional
-(void) didConnectStateChange:(PMConnectStat)state;
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