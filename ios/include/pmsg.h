#import <Foundation/Foundation.h>
#import <Models/PMMsg.h>
#import <Models/PMMsgBody.h>
#import <Models/PMTextMsgBody.h>
#import <ChatService/IChatManager.h>

@interface PMChat:NSObject {

}

@property (atomic) NSInteger whoami;

@property (atomic, copy) NSString* name;

@property (atomic, copy) NSString* wsUrl;

@property (atomic, copy) NSString* restUrl;


@property (atomic) NSOperationQueue* operatorQueue;

+(PMChat*) sharedInstance;

-(id<IChatManager>) chatManager;

-(id<IChatManager>) chatManager;

@end
