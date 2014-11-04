#import <Foundation/Foundation.h>
#import <websocket/SRWebSocket.h>

#import <Models/PMMsg.h>
#import <pmsg.h>
#import "PMChatManager.h"
#import "PMMsgManager.h"
#import "PMDBManager.h"
#import "PMFileManager.h"


@implementation DelegatePair {
}

-(id)init:(id<IChatManagerDelegate>)d :(dispatch_queue_t)q {
	self = [super init];
	self.delegate = d;
	self.queue = q;
	return self;
}

@end

@implementation PMChatManager {
	PMLoginManager* _loginManager;
	PMMsgManager* _msgManager;
	PMDBManager* _dbManager;
	NSMutableArray *_delegates;
	NSInteger _seq;
}

-(id) init {
	self = [super init];
	if(self) {
		_delegates = [[NSMutableArray alloc] init];
		_seq = 0;
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

-(PMLoginManager*) loginManager {
	if(_loginManager) return _loginManager;
	@synchronized(self) {
		if(_loginManager) return _loginManager;
		_loginManager = [[PMLoginManager alloc] init];
	}
	return _loginManager;
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

-(NSDictionary*) login:(NSString*)user :(NSString*)passwd withError:(NSError**) err {
	return [self.loginManager login:user :passwd withError:err];
}

-(void) asyncLogin:(NSString*)user :(NSString*)passwd {
	[self.loginManager asyncLogin:user :passwd];
}

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*)) completion {
	[self.loginManager asyncLogin:user :passwd withCompletion:completion];
}

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*))completion onQueue:(dispatch_queue_t)q {
	[self.loginManager asyncLogin:user :passwd withCompletion:completion onQueue:q];
}

-(void) reconnect {
	[[self msgManager] reconnect];
}

-(PMMsg*) send:(PMMsg*)msg {
	return [self.msgManager send:msg];
}

-(PMMsg*) send:(PMMsg*)msg withError:(NSError**)err {
	return [self.msgManager send:msg withError:err];
}

-(void) asyncSend:(PMMsg*)msg {
	[self.msgManager asyncSend:msg];
}

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(PMMsg*,NSError*)) completion {
	[self.msgManager asyncSend:msg withCompletion:completion];
}

-(void) asyncSend:(PMMsg*)msg withCompletion:(void (^)(PMMsg*,NSError*)) completion onQueue:(dispatch_queue_t)queue {
	[self.msgManager asyncSend:msg withCompletion:completion onQueue:queue];
}

-(NSUInteger)saveMsg:(PMMsg*)msg error:(NSError**)err {
	PMDBManager *db = self.dbManager;
	if(db)
		return [db saveMsg:msg error:err];
	return 0;
}

-(NSInteger)updateMsg:(PMMsg*)msg withNewId:(NSString*)nid error:(NSError**)err {
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

@end