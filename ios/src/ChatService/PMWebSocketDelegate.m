#import <pmsg.h>
#import "PMWebSocketDelegate.h"


@implementation PMWebSocketDelegate {
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

}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError*)e {
	NSLog(@"%@", e);
}

@end