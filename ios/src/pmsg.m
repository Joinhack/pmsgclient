#import <Foundation/Foundation.h>
#import <pmsg.h>
#import "ChatService/PMChatManager.h"



@implementation PMChat {
	PMChatManager *manager;
	dispatch_once_t once;
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
@end
