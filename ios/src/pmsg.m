#import <Foundation/Foundation.h>
#import <pmsg.h>
#import "ChatService/PMChatManager.h"

@implementation PMChat {
	PMChatManager *manager;
	dispatch_once_t once;
	dispatch_queue_t oq;
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

-(dispatch_queue_t) defaultQueue {
	if(oq) return oq;
	@synchronized(self) {
		if(oq) return oq;
		oq = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		return oq;
	}
}

-(void) setDefaultQueue:(dispatch_queue_t)q {
	@synchronized(self) {
		oq = q;
	}
}

@end
