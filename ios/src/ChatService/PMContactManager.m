#import <pmsg.h>
#import <AFNetworking.h>
#import "PMContactManager.h"


@implementation PMContactManager {
}

-(BOOL) followUser:(NSInteger)uid {
	return [self followUser:uid withError:nil];
}

-(BOOL) followUser:(NSInteger)uid withError:(PMError**)error {
	return [self followUser:uid withError:error];
}

-(BOOL) followUser:(NSInteger)uid withMessage:(NSString*)msg withError:(PMError**)error {
	dispatch_semaphore_t sema = dispatch_semaphore_create(0);
	__block PMError *err;
	[self asyncFollowUser:uid withMessage:msg withCompletion:^(PMError* e){
		if(e) err = e;
		dispatch_semaphore_signal(sema);
	} onQueue:nil];
	dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
	if(error) *error = err;
	if(err)
		return YES;
	else
		return NO;
}

-(void) asyncFollowUser:(NSInteger)uid withMessage:(NSString*)msg withCompletion:(void(^)(PMError*))completion onQueue:(dispatch_queue_t)queue {
	PMChat *chat = PMChat.sharedInstance;
	NSString *addUrl = [chat.restUrl stringByAppendingString:@"/user/follow"];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id": [NSNumber numberWithInt:uid]}];
	if(msg) 
		params[@"message"] = msg;
	[self asyncContactOperater:addUrl parameters:params errorCode:PMFollowUserFail didInvoke:@"didFollowUser" withCompletion:completion onQueue:queue];
}

-(void) asyncContactOperater:(NSString*)url parameters:(NSDictionary*)parameters errorCode:(ErrorCode)code didInvoke:(NSString*)invoke withCompletion:(void(^)(PMError*))completion onQueue:(dispatch_queue_t)queue {
	PMChat *chat = PMChat.sharedInstance;
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	if(queue == nil) queue = PMChat.sharedInstance.defaultQueue;
	manager.completionQueue = queue;
	manager.responseSerializer = [AFJSONResponseSerializer serializer];

	AFHTTPRequestOperation *post = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		PMError *error;
    NSDictionary *dict = responseObject;
    if(!dict[@"code"]) {
			error = [PMError errorWithCode:code withDescription:@"error format"];
			goto FINISH;
		}
		if(![dict[@"code"] isEqual:[NSNumber numberWithInt:0]]) {
			NSString *desc = [NSString stringWithFormat:@"error return value."];
			if(dict[@"msg"])
				desc = [NSString stringWithFormat:@"%@", dict[@"msg"]];
			error = [PMError errorWithCode:code withDescription:desc];
			goto FINISH;
		}
		FINISH:
		[chat.chatManager invokeDelegate:[NSString stringWithFormat:@"%@:%%@", invoke], error];
		if(completion) completion(error);
	} failure:^(AFHTTPRequestOperation *o, NSError *e){
		if(completion) completion([PMError errorWithCode:code withError:e]);
	}];
}

-(BOOL) acceptUser:(NSInteger)uid {
	return [self acceptUser:uid withError:nil];
}

-(BOOL) acceptUser:(NSInteger)uid withError:(PMError**)error {
	return [self acceptUser:uid withMessage:nil withError:error];
}

-(BOOL) acceptUser:(NSInteger)uid withMessage:(NSString*)msg withError:(PMError**)error {
	dispatch_semaphore_t sema = dispatch_semaphore_create(0);
	__block PMError *err;
	[self asyncAcceptUser:uid withMessage:msg withCompletion:^(PMError* e){
		if(e) err = e;
		dispatch_semaphore_signal(sema);
	} onQueue:nil];
	dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
	if(error) *error = err;
	if(err)
		return YES;
	else
		return NO;
}

-(void) asyncAcceptUser:(NSInteger)uid withMessage:(NSString*)msg withCompletion:(void(^)(PMError*))completion onQueue:(dispatch_queue_t)queue {
	PMChat *chat = PMChat.sharedInstance;
	NSString *addUrl = [chat.restUrl stringByAppendingString:@"/user/accept"];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id": [NSNumber numberWithInt:uid]}];
	if(msg) 
		params[@"message"] = msg;
	[self asyncContactOperater:addUrl parameters:params errorCode:PMAcceptUserFail didInvoke:@"didAcceptUser" withCompletion:completion onQueue:queue];
}

-(BOOL) rejectUser:(NSInteger)uid {
	return [self rejectUser:uid withMessage:nil withError:nil];
}

-(BOOL) rejectUser:(NSInteger)uid withError:(PMError**)error {
	return [self rejectUser:uid withMessage:nil withError:error];
}


-(BOOL) rejectUser:(NSInteger)uid withMessage:(NSString*)msg withError:(PMError**)error {
	dispatch_semaphore_t sema = dispatch_semaphore_create(0);
	__block PMError *err;
	[self asyncRejectUser:uid withMessage:msg withCompletion:^(PMError* e){
		if(e) err = e;
		dispatch_semaphore_signal(sema);
	} onQueue:nil];
	dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
	if(error) *error = err;
	if(err)
		return YES;
	else
		return NO;
}

-(void) asyncRejectUser:(NSInteger)uid withMessage:(NSString*)msg withCompletion:(void(^)(PMError*))completion onQueue:(dispatch_queue_t)queue {
	PMChat *chat = PMChat.sharedInstance;
	NSString *addUrl = [chat.restUrl stringByAppendingString:@"/user/reject"];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id": [NSNumber numberWithInt:uid]}];
	if(msg) 
		params[@"message"] = msg;
	[self asyncContactOperater:addUrl parameters:params errorCode:PMRejectUserFail didInvoke:@"didRejectUser" withCompletion:completion onQueue:queue];
}


@end