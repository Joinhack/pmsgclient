#import <Foundation/Foundation.h>
#import <websocket/SRWebSocket.h>

#import <Models/PMMsg.h>
#import <pmsg.h>
#import "PMChatManager.h"
#import "PMMsgManager.h"
#import "PMContactManager.h"
#import "PMDBManager.h"
#import "PMFileManager.h"
#import "../Models/PMImageMsgBody+Inner.h"


@implementation DelegatePair {
}

-(instancetype)init:(id<IChatManagerDelegate>)d :(dispatch_queue_t)q {
	self = [super init];
	self.delegate = d;
	self.queue = q;
	return self;
}

@end

@implementation PMChatManager {
	PMLoginManager* _loginManager;
	PMMsgManager* _msgManager;
	PMFileManager* _fileManager;
	PMDBManager* _dbManager;
	PMContactManager *_contactManager;
	NSMutableDictionary *_requestChains;
	NSMutableArray *_delegates;
	long _chainId;
	NSInteger _seq;
}

-(instancetype) init {
	self = [super init];
	if(self) {
		_requestChains = [[NSMutableDictionary alloc]init];
		_delegates = [[NSMutableArray alloc] init];
		_seq = 0;
		_chainId = 0;
	}
	return self;
}

-(PMDBManager*) dbManager {
	if(_dbManager) return _dbManager;
	if(PMChat.sharedInstance.dbPath == nil) return nil;
	@synchronized(self) {
		if(_dbManager) return _dbManager;
		_dbManager = [[PMDBManager alloc] init:PMChat.sharedInstance.dbPath];
	}
	return _dbManager;
}

-(PMContactManager*) contactManager {
	if(_contactManager) return _contactManager;
	@synchronized(self) {
		if(_contactManager) return _contactManager;
		_contactManager = [[PMContactManager alloc] init];
	}
	return _contactManager;
}

-(PMLoginManager*) loginManager {
	if(_loginManager) return _loginManager;
	@synchronized(self) {
		if(_loginManager) return _loginManager;
		_loginManager = [[PMLoginManager alloc] init];
	}
	return _loginManager;
}

-(PMFileManager*) fileManager {
	if(_fileManager) return _fileManager;
	@synchronized(self) {
		if(_fileManager) return _fileManager;
		_fileManager = [[PMFileManager alloc] init];
	}
	return _fileManager;
}

-(PMMsgManager*) msgManager {
	if(_msgManager) return _msgManager;
	@synchronized(self) {
		if(_msgManager) return _msgManager;
		_msgManager = [[PMMsgManager alloc] init];
	}
	return _msgManager;
}

-(void)addDelegate:(id<IChatManagerDelegate>)delegate :(dispatch_queue_t)q {
	for(NSInteger i = 0; i < _delegates.count; i++) {
		DelegatePair *pair = _delegates[i];
		if(pair.delegate == delegate) {
			pair.queue = q;
			return;
		}
	}
	[_delegates addObject:[[DelegatePair alloc] init:delegate :q]];
}

-(void)removeDelegate:(id<IChatManagerDelegate>)delegate {
	NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
	for(NSInteger i = 0; i < _delegates.count; i++) {
		DelegatePair *pair = _delegates[i];
		if(pair.delegate == delegate)
			[set addIndex:i];
	}
	[_delegates removeObjectsAtIndexes:set];
}

-(void)invokeDelegate:(NSString*)method, ... {
	NSString *selStr = [method stringByReplacingOccurrencesOfString:@"%@" withString:@""];
	selStr = [selStr stringByReplacingOccurrencesOfString:@"%d" withString:@""];
	SEL sel = NSSelectorFromString(selStr);
	for(DelegatePair *pair in _delegates) {
		if([pair.delegate respondsToSelector:sel]) {
			NSMethodSignature *signature = [[pair.delegate class] instanceMethodSignatureForSelector:sel];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setSelector:sel];
			[invocation setTarget:pair.delegate];
			va_list args;
			va_start(args, method);
			int len = [method length];
			int idx = 0;

			for (int i=0; i < len; i++) {
				if ([method characterAtIndex:i] == '%') {
					if(i == len - 1) break;
					char nextChar = [method characterAtIndex:i+1];
					if(nextChar == '@') {
						i++;
						id arg = va_arg(args, id);
						if(arg == nil) {
							idx++;
							continue;
						}
						[invocation setArgument:&arg atIndex:idx+2];
						idx++;
					}
					if(nextChar == 'd') {
						i++;
						NSInteger arg = va_arg(args, NSInteger);
						[invocation setArgument:&arg atIndex:idx+2];
						idx++;
					}
				}
			}
			va_end(args);
			[invocation retainArguments];
			if(pair.queue) 
				dispatch_async(pair.queue, ^(){[invocation invoke];});
			else
				[invocation invoke];
		}
	}
}

-(NSArray*)delegates {
	return _delegates;
}

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd {
	return [self.loginManager login:user :passwd];
}

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd withError:(PMError**) err {
	return [self.loginManager login:user :passwd withError:err];
}

-(void) asyncLogin:(NSString*)user :(NSString*)passwd {
	[self.loginManager asyncLogin:user :passwd];
}

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,PMError*)) completion {
	[self.loginManager asyncLogin:user :passwd withCompletion:completion];
}

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,PMError*))completion onQueue:(dispatch_queue_t)q {
	[self.loginManager asyncLogin:user :passwd withCompletion:completion onQueue:q];
}

-(void) reconnect {
	[[self msgManager] reconnect];
}

-(PMMsg*) send:(PMMsg*)msg {
	return [self.msgManager send:msg];
}

-(PMMsg*) send:(PMMsg*)msg withError:(PMError**)err {
	return [self.msgManager send:msg withError:err];
}

-(void) asyncSend:(PMMsg*)msg {
	[self.msgManager asyncSend:msg];
}

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(PMMsg*,PMError*))completion {
	[self.msgManager asyncSend:msg withCompletion:completion];
}

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(PMMsg*,PMError*))completion onQueue:(dispatch_queue_t)queue {
	[self asyncSend:msg withCompletion:completion withProgress:nil onQueue:queue];
}

-(void) processImageBody:(PMImageMsgBody*)imgBody withCompletion:(void (^)(PMMsg*,PMError*))completion withProgress:(void(^)(id<PMMsgBody>, NSUInteger, NSUInteger))progress onQueue:(dispatch_queue_t)queue chainId:(NSNumber*)chainId {

	if(imgBody.isLocalUrl) {
		NSMutableArray *chain = [self getChain:chainId];
		[chain addObject:^{
			
			[self.fileManager uploadImage:imgBody.url withProgress:^(NSUInteger i,long long n,long long t){
				if(progress) {
					progress(imgBody, n, t);
				}
			}
			completion:^(NSDictionary* d, NSError* e){
				if(e) {
					[self removeChain:chainId];
					completion(nil, [PMError errorWithCode:PMUploadFileError withError:e]);
					return;
				}
				imgBody.url = d[@"url"];
				imgBody.isLocalUrl = NO;
				imgBody.scaledUrl = @"test";
				[self chainCall:chainId];
			} onQueue:queue];
			}];
		}
}

-(void) removeChain:(NSNumber*)key {
	@synchronized(self) {
		[_requestChains removeObjectForKey:key];
	}
}

-(void) addChain:(NSNumber*)key chain:(NSArray*)chain {
	@synchronized(self) {
		_requestChains[key] = chain;
	}
}

-(NSMutableArray*) getChain:(NSNumber*)key {
	@synchronized(self) {
		return _requestChains[key];
	}
}

-(NSNumber*) nextChainId {
	@synchronized(self) {
		++_chainId;
		if(_chainId <= 0)
			_chainId = 1;
		return [NSNumber numberWithLong:_chainId];
	}
}

-(void) chainCall:(NSNumber*)chainId {
	NSMutableArray *chain = [self getChain:chainId];
	if(chain.count > 0) {
		void(^call)() = chain[0];
		[chain removeObjectAtIndex:0];
		call();
		if(chain.count == 0)
			[self removeChain:chainId];
	}
}

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(PMMsg*,PMError*))completion withProgress:(void(^)(id<PMMsgBody>, NSUInteger, NSUInteger))progress onQueue:(dispatch_queue_t)queue {
	if(queue == nil) queue = PMChat.sharedInstance.defaultQueue;
	NSMutableArray *chain = [[NSMutableArray alloc] init];
	NSNumber *chainId = self.nextChainId;
		
	[self addChain:chainId chain:chain];

	if(msg.bodies) {
		for(int i = 0; i < msg.bodies.count; i++) {
			id<PMMsgBody> body = msg.bodies[i];
			if(body.type == PMImageMsgBodyType) {
				PMImageMsgBody *imgBody = body;
				[self processImageBody:imgBody withCompletion:completion withProgress:progress onQueue:queue chainId:chainId];
			}
		}
	}
	[chain addObject:^{
		[self.msgManager asyncSend:msg withCompletion:completion onQueue:queue];
	}];

	[self chainCall:chainId];
}

-(NSUInteger)saveMsg:(PMMsg*)msg error:(PMError**)err {
	PMDBManager *db = self.dbManager;
	if(db)
		return [db saveMsg:msg error:err];
	return 0;
}

-(NSInteger)updateMsg:(PMMsg*)msg withNewId:(NSString*)nid error:(PMError**)err {
	PMDBManager *db = self.dbManager;
	if(db)
		return [db updateMsg:msg withNewId:nid error:err];
	return 0;
}

-(NSInteger)seq {
	@synchronized(self) {
		PMDBManager *db = self.dbManager;

		if(db)
			_seq = [db seq:_seq ];
		else 
			_seq++;
		return _seq;
	}
}

-(BOOL) followUser:(NSInteger)uid {
	return [self.contactManager followUser:uid];
}

-(BOOL) followUser:(NSInteger)uid withError:(PMError**)error {
	return [self.contactManager followUser:uid withError:error];
}

-(BOOL) followUser:(NSInteger)uid withMessage:(NSString*)msg withError:(PMError**)error {
	return [self.contactManager followUser:uid withMessage:msg withError:error];
}

-(void) asyncFollowUser:(NSInteger)uid withMessage:(NSString*)msg withCompletion:(void(^)(PMError*))completion onQueue:(dispatch_queue_t)queue {
	[self.contactManager asyncFollowUser:uid withMessage:msg withCompletion:completion onQueue:queue];
}

-(BOOL) acceptUser:(NSInteger)uid {
	return [self.contactManager acceptUser:uid];
}

-(BOOL) acceptUser:(NSInteger)uid withError:(PMError**)error {
	return [self.contactManager acceptUser:uid withError:error];
}

-(BOOL) acceptUser:(NSInteger)uid withMessage:(NSString*)msg withError:(PMError**)error {
	return [self.contactManager acceptUser:uid withMessage:msg withError:error];
}

-(void) asyncAcceptUser:(NSInteger)uid withMessage:(NSString*)msg withCompletion:(void(^)(PMError*))completion onQueue:(dispatch_queue_t)queue {
	[self.contactManager asyncAcceptUser:uid withMessage:msg withCompletion:completion onQueue:queue];
}

-(BOOL) rejectUser:(NSInteger)uid {
	return [self.contactManager rejectUser:uid];
}

-(BOOL) rejectUser:(NSInteger)uid withError:(PMError**)error {
	return [self.contactManager rejectUser:uid withError:error];
}

-(BOOL) rejectUser:(NSInteger)uid withMessage:(NSString*)msg withError:(PMError**)error {
	return [self.contactManager rejectUser:uid withMessage:msg withError:error];
}

-(void) asyncRejectUser:(NSInteger)uid withMessage:(NSString*)msg withCompletion:(void(^)(PMError*))completion onQueue:(dispatch_queue_t)queue {
	[self.contactManager asyncRejectUser:uid withMessage:msg withCompletion:completion onQueue:queue];
}

@end