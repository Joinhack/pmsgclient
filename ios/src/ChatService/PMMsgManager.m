#import <Models/PMMsg.h>
#import <ChatService/IMsgManager.h>
#import <pmsg.h>
#import "../websocket/SRWebSocket.h"
#import "PMMsgManager.h"

@implementation PMMsgManager {
	SRWebSocket *_ws;
	PMConnectStat _connectState;
}


-(id) init {
	self = [super init];
	_connectState = CLOSED;
	self.sendingMsgs = [[NSMutableDictionary alloc] init];
	return self;
}

-(PMConnectStat) connectState {
	return _connectState;
}

-(void) setConnectState:(PMConnectStat) state {
	PMConnectStat old;
	@synchronized(self) {
		old = _connectState;
		_connectState = state;
	}
	PMChat *chat = [PMChat sharedInstance];
	[[chat chatManager] invokeDelegate:@"didConnectStateChange:%dfrom:%d", _connectState, old];
}

-(void) reconnect {
	PMChat *chat = [PMChat sharedInstance];
	if(_ws) {
		[_ws close];
	};
	 _ws = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chat.wsUrl]]];
	 _ws.delegate = self;
	 self.connectState = CONNECTING;
	 [_ws open];

}

-(NSDictionary*) send:(PMMsg*)msg {

}

-(NSDictionary*) send:(PMMsg*)msg withError:(NSError**)err {

}

-(void) asyncSend:(PMMsg*)msg {

}

-(void) asyncSend:(PMMsg*)m withCompletion:(void (^)(NSDictionary*,NSError*)) completion{
	__block PMMsg* msg = m;

}


-(void)didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
	PMChat *chat = [PMChat sharedInstance];
	self.connectState = CLOSED;
	self.sendingMsgs = [[NSMutableDictionary alloc] init];
	[[chat chatManager] invokeDelegate:@"didConnectStateChange", self.connectState];
}

- (void)webSocketDidOpen:(SRWebSocket *)ws {
	NSError *err;
	id obj = @{
		@"id": [[PMChat sharedInstance] whoami],
		@"type": @254,
		@"devType": @2,
		@"name": [[PMChat sharedInstance] name]
	};
	[ws send:[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&err]];
	if (err) {
		[self webSocket:ws didFailWithError:err];
	}
}


- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
	NSError *err;
	PMChat *chat = [PMChat sharedInstance];
	NSDictionary *rs = [NSJSONSerialization JSONObjectWithData: [message dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &err];
	if(err) {
		[_ws closeWithCode:-1 reason:[NSString stringWithFormat:@"%@", err]];
		return;
	}
	if (_connectState == CONNECTING) {
		self.connectState = CONNECTED;
	}
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError*)e {
	NSLog(@"%@", e);
}


@end
