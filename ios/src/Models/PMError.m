#import <Models/PMError.h>

@implementation PMError

@synthesize description = _description; 

-(instancetype)initWithCode:(ErrorCode)code withDescription:(NSString*)description {
	self = [super init];
	if(self) {
		self.code = code;
		_description = description;
	}
	return self;
}

-(NSString*) description {
	return [NSString stringWithFormat:@"code:%d detail:%@", self.code, _description];
}

+(instancetype)errorWithCode:(ErrorCode)code withDescription:(NSString*)description {
	return [[PMError alloc] initWithCode:code withDescription:description];
}

+(instancetype)errorWithCode:(ErrorCode)code withError:(NSError*)error {
	return [[PMError alloc] initWithCode:code withDescription:error.localizedFailureReason];	
}

@end