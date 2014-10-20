#import <Foundation/Foundation.h>
#import <pmsg.h>
#import "ChatService/PMChatManager.h"


@implementation PMChat {
	PMChatManager *manager;
	dispatch_once_t once;
	NSOperationQueue* oq;
}

@synthesize wsUrl = wsUrl;

@synthesize restUrl = restUrl;

+(PMChat*) sharedInstance {
	static PMChat* chat = nil;
	if(chat) return chat;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		chat = [[PMChat alloc] init];
	});
	return chat;
}

-(id<IChatManager>) chatManager {
	dispatch_once(&once, ^{
		manager = [[PMChatManager alloc] init];
	});
	return manager;
}

-(NSOperationQueue*) operationQueue {
	if(oq) return oq;
	@synchronized(self) {
		if(oq) return oq;
		oq = [[NSOperationQueue alloc] init];
		return oq;
	}
}

-(void) setOperationQueue:(NSOperationQueue*)q {
	@synchronized(self) {
		oq = q;
	}
}

@end
