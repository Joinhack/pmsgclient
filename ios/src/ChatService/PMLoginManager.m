#import <pmsg.h>
#import <AFNetworking.h>
#import "PMLoginManager.h"
#import "NSMutableURLRequest+Post.h"


@implementation PMLoginManager {
	
}

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd {
	return [self login:user :passwd withError:nil];
}

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd withError:(NSError**)error {
	dispatch_semaphore_t sema = dispatch_semaphore_create(0);
	__block NSDictionary *dict;
	__block NSError *er;
	[self asyncLogin:user :passwd withCompletion:^(NSDictionary *d,NSError *e){
		if(e) {
			er = e;
		} else
			dict = d;
		dispatch_semaphore_signal(sema);
	}];
	dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
	if(error) *error = er;
	return dict;
}

-(void) asyncLogin:(NSString*)user :(NSString*)passwd {
	[self asyncLogin:user :passwd withCompletion:nil];
}

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*))completion {
	[self asyncLogin:user :passwd withCompletion:completion onQueue:PMChat.sharedInstance.defaultQueue];
}

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*)) completion onQueue:(dispatch_queue_t)queue {
	
	PMChat *chat = [PMChat sharedInstance];
	NSString *loginUrl = [chat.restUrl stringByAppendingString:@"/user/login"];
	NSURL *url = [[NSURL alloc] initWithString:loginUrl];
	__block NSString* _password = passwd;

	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	if(queue == nil) queue = PMChat.sharedInstance.defaultQueue;
	manager.completionQueue = queue;
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	AFHTTPRequestOperation *post = [manager POST:loginUrl parameters:@{@"name": user, @"password":passwd} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSError *error;
    NSDictionary *dict = responseObject;
    if(!dict[@"code"]) {
			error = [NSError errorWithDomain:@"Login" code:-1 userInfo:@{@"detail":@"error format"}];
			goto FINISH;
		}
		if(![dict[@"code"] isEqual:[NSNumber numberWithInt:0]]) {
			error = [NSError errorWithDomain:@"Login" code:-1 userInfo:@{@"detail":@"error code"}];
			goto FINISH;
		}
		chat.whoami = dict[@"id"];
		chat.name = dict[@"name"];
		chat.password = _password;
		
		[[chat chatManager] reconnect];
FINISH:
		[[chat chatManager] invokeDelegate:@"didLogin:%@:%@", dict, error];
		if(completion)
			completion(dict, error);
	} failure:^(AFHTTPRequestOperation *o, NSError *e){
		if(completion) completion(nil, e);
	}];
}


@end