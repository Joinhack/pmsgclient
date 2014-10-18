#import <Foundation/Foundation.h>

#import <pmsg.h>


int main() {
	@autoreleasepool {
		PMChat *chat = [PMChat sharedInstance];
		chat.restUrl = @"http://localhost:8000";
		NSError*  err = nil;

		id v = [[chat chatManager] login:@"joinhack" :@"111111"  withError:&err];
		if(err) {
			NSLog(@"%@", err);
			return -1;
		} else {
			NSLog(@"%@", v);
		}
		


		while([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
			
		};
	}
}
