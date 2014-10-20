#import <Foundation/Foundation.h>
#import "NSMutableURLRequest+Post.h"

@implementation NSMutableURLRequest(Post) 

-(id)initWithURL:(NSURL*)url withParams:(NSDictionary*)param {
	self = [super initWithURL:url];
	self.HTTPMethod = @"POST";
	[self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
	for(NSString *key in param) {

		[array addObject:[NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEncodingWithAllowedCharacters:set], [param[key] stringByAddingPercentEncodingWithAllowedCharacters:set]]];	
	}
	NSString *post = [array componentsJoinedByString:@"&"];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	[self setValue:[NSString stringWithFormat:@"%lu", [post length]] forHTTPHeaderField:@"Content-Length"];
	NSLog(@"%@", post);
	[self setHTTPBody:postData];
	return self;
}
@end