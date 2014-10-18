#import <Foundation/Foundation.h>
#import <websocket/SRWebSocket.h>

#import <Models/PMMsg.h>
#import <pmsg.h>
#import "PMChatManager.h"

@implementation PMChatManager {
	SRWebSocket *ws;
	NSOperationQueue *operationQueue;
}

@synthesize delegate = delegate;


-(id)init {
	operationQueue = [[NSOperationQueue alloc] init];
	return self;
}

-(void)initWithOperationQueue:(NSOperationQueue*)queue {
	operationQueue = queue;
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

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*)) completion {
	NSString *loginUrl = [[PMChat sharedInstance].restUrl stringByAppendingString:@"/user/login"];
	NSURL *url = [[NSURL alloc] initWithString:loginUrl];
	
	[NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		NSDictionary *dict = nil;
		if(!error) {
			dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
			if(!dict[@"code"]) {
				error = [NSError errorWithDomain:@"Login" code:-1 userInfo:@{@"detail":@"error format"}];
				goto FINISH;
			}
			if(!dict[@"code"] != 0) {
				error = [NSError errorWithDomain:@"Login" code:-1 userInfo:@{@"detail":@"error code"}];
				goto FINISH;
			}

			NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[(NSHTTPURLResponse*)response allHeaderFields] forURL:[NSURL URLWithString:loginUrl]];
			NSLog(@"%@", cookies);

		}
FINISH:
		if(completion)
			completion(dict, error);
	}];

}


-(void)send:(PMMsg*) msg {
	[ws send:@""];
}


@end