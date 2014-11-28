#import <pmsg.h>
#import <AFNetworking.h>
#import "PMLoginManager.h"


@implementation PMLoginManager {
	
}

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd {
	return [self login:user :passwd withError:nil];
}

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd withError:(PMError**)error {
	dispatch_semaphore_t sema = dispatch_semaphore_create(0);
	__block NSDictionary *dict;
	__block PMError *er;
	[self asyncLogin:user :passwd withCompletion:^(NSDictionary *d,PMError *e){
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

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,PMError*))completion {
	[self asyncLogin:user :passwd withCompletion:completion onQueue:PMChat.sharedInstance.defaultQueue];
}

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,PMError*)) completion onQueue:(dispatch_queue_t)queue {
	
	PMChat *chat = [PMChat sharedInstance];
	NSString *loginUrl = [chat.restUrl stringByAppendingString:@"/user/login"];
	__block NSString* _password = passwd;

	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	if(queue == nil) queue = PMChat.sharedInstance.defaultQueue;
	manager.completionQueue = queue;
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	AFHTTPRequestOperation *post = [manager POST:loginUrl parameters:@{@"name": user, @"password":passwd} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		PMError *error;
    NSDictionary *dict = responseObject;
    if(!dict[@"code"]) {
			error = [PMError errorWithCode:PMLoginFail withDescription:@"error format"];
			goto FINISH;
		}
		if(![dict[@"code"] isEqual:[NSNumber numberWithInt:0]]) {
			NSString *desc = [NSString stringWithFormat:@"error return value."];
			if(dict[@"msg"])
				desc = [NSString stringWithFormat:@"%@", dict[@"msg"]];
			error = [PMError errorWithCode:PMLoginFail withDescription:desc];
			goto FINISH;
		}
		chat.whoami = dict[@"id"];
		chat.name = dict[@"name"];
		chat.password = _password;
		[[chat chatManager] reconnect];
FINISH:
		[[chat chatManager] invokeDelegate:@"didLogin:%@:%@", dict, error];
		if(completion) completion(dict, error);
	} failure:^(AFHTTPRequestOperation *o, NSError *e){
		if(completion) completion(nil, [PMError errorWithCode:PMLoginFail withDescription:e.description]);
	}];
}


@end