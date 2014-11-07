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
		for(int i = 0; i < 20; i++) {
			PMMsg *msg = [[PMMsg alloc] init];
			msg.to = 2;
			msg.type = 1;
			PMImageMsgBody *body = [PMImageMsgBody localFile:@"/Volumes/joinhack/Downloads/a.cc"];
			[msg addMsgBody:body];
	PMImageMsgBody *body2 = [PMImageMsgBody localFile:@"/Volumes/joinhack/Downloads/a.cc"];
			[msg addMsgBody:body2];

			[chat.chatManager asyncSend:msg withCompletion:^(PMMsg* msg,NSError* e){
				NSLog(@"----%@-", e);
			} onQueue:nil];
		}
		NSLog(@"error %@", err);
	}
}

- (void)didSendMsg:(PMMsg *)msg
                error:(NSError *)error {
 	NSLog(@"didSendMsg %@ %@", msg, error);               	
}

- (void)didReceiveMsg:(PMMsg *)msg {
 	NSLog(@"didReceiveMsg %@", msg);               	
}
@end

int main() {
	@autoreleasepool {
		PMChat *chat = [PMChat sharedInstance];
		chat.restUrl = @"http://localhost:8000";
		chat.wsUrl = @"http://localhost:8000";
		chat.dbPath = @"/Volumes/joinhack/Downloads/test.db";
		NSError*  err = nil;
		id<IChatManager> cm = [chat chatManager];
		TestDelegate *delegate = [[TestDelegate alloc] init];
		[cm addDelegate:delegate :nil];
		id v = [[chat chatManager] login:@"join" :@"111111"  withError:&err];
		if(err) {
			NSLog(@"error %@", err);
			return -1;
		}
		NSLog(@"loop....");
		err = nil;
		while([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
			
		};
	}
}
