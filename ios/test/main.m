#import <Foundation/Foundation.h>

#import <pmsg.h>

@interface TestDelegate : NSObject <IChatManagerDelegate> {
}

-(void)didLogin:(NSDictionary*)dict :(NSError*)err;
@end

@implementation TestDelegate {
}
-(void)didLogin:(NSDictionary*)dict :(NSError*)err {
	NSLog(@"--%@ %@", dict, err);
}

-(void) didConnectStateChange:(PMConnectStat)state from:(PMConnectStat)old {
	NSLog(@"state %u %u", state, old);
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
		[chat.chatManager send:nil withError:&err];
		NSLog(@"error %@", err);
		while([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
			
		};
	}
}
