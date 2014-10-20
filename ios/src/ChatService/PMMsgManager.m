#import <Models/PMMsg.h>
#import <ChatService/IMsgManager.h>
#import <pmsg.h>
#import "../websocket/SRWebSocket.h"
#import "PMMsgManager.h"

@implementation PMMsgManager {
	SRWebSocket *_ws;
}

@synthesize wsDelegate = _wsDelegate;

-(NSDictionary*) reconnect {
	if(_ws) {
		_ws.delegate = nil;
		[_ws close];
	};
	 _ws = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[PMChat sharedInstance].wsUrl]]];
	 _ws.delegate = _wsDelegate;
	 [_ws open];
}

-(NSDictionary*) send:(PMMsg*)msg {

}

-(NSDictionary*) send:(PMMsg*)msg withError:(NSError**)err {

}

-(void) asyncSend:(PMMsg*)msg {

}

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(NSDictionary*,NSError*)) completion{

}

@end
