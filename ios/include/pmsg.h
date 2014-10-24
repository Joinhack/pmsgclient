#import <Foundation/Foundation.h>
#import <Models/PMMsg.h>
#import <Models/PMMsgBody.h>
#import <Models/PMTextMsgBody.h>
#import <ChatService/IChatManager.h>

#define NullValue(v) v?v:[NSNull null]

@interface PMChat:NSObject {
}

@property (atomic) NSNumber* whoami;

@property (atomic, copy) NSString* name;

@property (atomic, copy) NSString* password;

@property (atomic, copy) NSString* token;

@property (atomic, copy) NSString* wsUrl;

@property (atomic, copy) NSString* restUrl;


+(PMChat*) sharedInstance;

-(id<IChatManager>) chatManager;

-(NSOperationQueue*) operationQueue;

-(void) setOperationQueue:(NSOperationQueue*)q;

@end
