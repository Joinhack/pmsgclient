#import <Foundation/Foundation.h>
#import <Models/PMMsg.h>
#import <Models/PMMsgBody.h>
#import <Models/PMTextMsgBody.h>
#import <Models/PMImageMsgBody.h>
#import <Models/PMGroup.h>
#import <Models/PMError.h>
#import <ChatService/IChatManager.h>


@interface PMChat:NSObject {
}

@property (atomic) NSNumber* whoami;

@property (atomic, copy) NSString* name;

@property (atomic, copy) NSString* password;

@property (atomic, copy) NSString* token;

@property (atomic, copy) NSString* wsUrl;

@property (atomic, copy) NSString* restUrl;

@property (atomic, copy) NSString* dbPath;


+(PMChat*) sharedInstance;

-(id<IChatManager>) chatManager;

-(dispatch_queue_t) defaultQueue;

-(void) setDefaultQueue:(dispatch_queue_t)q;

@end
