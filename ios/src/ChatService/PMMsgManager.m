#import <Models/PMMsg.h>
#import <ChatService/IMsgManager.h>
#import <pmsg.h>
#import "../websocket/SRWebSocket.h"
#import "PMMsgManager.h"

@implementation PMMsgManager {
	SRWebSocket *_ws;
	PMConnectStat _connectState;
	NSMutableDictionary *_sendingMsgs;
	dispatch_queue_t _queue;
}


-(id) init {
	self = [super init];
	if(self) {
		_connectState = CLOSED;
		_sendingMsgs = [[NSMutableDictionary alloc] init];
		_queue = dispatch_queue_create("pm.message.queue", NULL);		
	}
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
	return [self send:msg withError:nil];
}

-(NSDictionary*) send:(PMMsg*)msg withError:(NSError**)err {
	__block NSError *error;
	__block NSDictionary *dict;
	dispatch_semaphore_t sema = dispatch_semaphore_create(0);
	[self asyncSend:msg withCompletion:^(NSDictionary* rs, NSError* e){
		if(e) error = e; else dict = rs;
		dispatch_semaphore_signal(sema);
	}];
	
	dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
	if(err && error) *err = error;
	return dict;
}

-(void) asyncSend:(PMMsg*)msg {
	[self asyncSend:msg withCompletion:nil];
}

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(NSDictionary*,NSError*))completion{
	[self asyncSend:msg withCompletion:completion onQueue:_queue];
}


-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(NSDictionary*,NSError*))completion onQueue:(dispatch_queue_t)queue {
	if(msg == nil && completion) {
		dispatch_async(queue?queue:_queue, ^(){
			completion(nil, [NSError errorWithDomain:@"PMMsg" code:-1 userInfo:@{@"detail":@"invaild msg"}]);
		});
		return;
	}
	if (_connectState != CONNECTING) {
		dispatch_queue_t q = queue?queue:_queue;
		dispatch_async(q, ^(){
			completion(nil, [NSError errorWithDomain:@"PMMsg" code:-1 userInfo:@{@"detail":@"connection is closed"}]);
		});
		return;
	}

	__block dispatch_queue_t q = queue?queue:_queue;
	__block NSString *msgId = msg.id;
	@synchronized(_sendingMsgs) {
		_sendingMsgs[msg.id] = msg;
	}
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC), q, ^{
		@synchronized(_sendingMsgs) {
			PMMsg *msg = _sendingMsgs[msgId];
			if(msg != nil && completion) {
					dispatch_async(q, ^(){
						completion(nil, [NSError errorWithDomain:@"PMMsg" code:-1 userInfo:@{@"detail":@"connection is closed"}]);
					});
			}

		}
	});
}


-(void)didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
	PMChat *chat = [PMChat sharedInstance];
	self.connectState = CLOSED;
	_sendingMsgs = [[NSMutableDictionary alloc] init];
	[[chat chatManager] invokeDelegate:@"didConnectStateChange", self.connectState];
}

- (void)webSocketDidOpen:(SRWebSocket *)ws {
	NSError *err;
	PMChat *chat = PMChat.sharedInstance;
	id obj = @{
		@"id": chat.whoami,
		@"type": @254,
		@"devType": @2,
		@"name": chat.name, 
		@"password": chat.password
	};
	[ws send:[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&err]];
	if (err) {
		[self webSocket:ws didFailWithError:err];
	}
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
	NSError *err;
	PMChat *chat = PMChat.sharedInstance;
	NSDictionary *rs = [NSJSONSerialization JSONObjectWithData: [message dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &err];
	if(err) {
		[_ws closeWithCode:-1 reason:[NSString stringWithFormat:@"%@", err]];
		return;
	}
	if (_connectState == CONNECTING) {
		if([rs[@"type"] intValue] == 255 && [rs[@"code"] intValue] == 0)
			self.connectState = CONNECTED;
		else {
			[_ws close];
			[self webSocket:_ws didCloseWithCode:-1 reason:rs[@"msg"] wasClean:true];
		}
	}
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean; {
	self.connectState = CLOSED;
	NSLog(@"code:%ld reason:%@", code, reason);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError*)e {
	self.connectState = CLOSED;
}


@end
