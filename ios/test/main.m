#import <Foundation/Foundation.h>

#import <pmsg.h>

@interface TestDelegate : NSObject <IChatManagerDelegate> {
}
@end

@implementation TestDelegate {
}
-(void)didLogin:(NSDictionary*)dict :(NSError*)err {
	NSLog(@"--%@ %@", dict, err);
}

-(void) didConnectStateChange:(PMConnectStat)state from:(PMConnectStat)old {
	NSLog(@"state %u %u", state, old);
	NSError *err;
	PMChat *chat = [PMChat sharedInstance];
	if(state == 3 && old == 2) {
		PMMsg *msg = [[PMMsg alloc] init];
		msg.id = @"1";
		msg.to = 3;
		msg.type = 1;
		[msg addMsgBody:[PMTextMsgBody msgBodyWithContent:@"hi"]];
		[chat.chatManager send:msg withError:&err];
		NSLog(@"error %@", err);
	}
}

- (void)didSendMsg:(PMMsg *)msg
                error:(NSError *)error {
 	NSLog(@"didSendMsg %@ %@", msg, error);               	
}
@end

int main() {
	@autoreleasepool {
		PMChat *chat = [PMChat sharedInstance];
		chat.restUrl = @"http://localhost:8000";
		chat.wsUrl = @"http://localhost:8000";
		NSError*  err = nil;
		id<IChatManager> cm = [chat chatManager];
		TestDelegate *delegate = [[TestDelegate alloc] init];
		[cm addDelegate:delegate :nil];
		id v = [[chat chatManager] login:@"join2" :@"111111"  withError:&err];
		if(err) {
			NSLog(@"error %@", err);
			return -1;
		} else {
			NSLog(@"%@", v);
		}
		err = nil;
		while([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
			
		};
	}
}
