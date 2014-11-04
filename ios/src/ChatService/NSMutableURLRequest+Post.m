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
	[self setHTTPBody:postData];
	return self;
}

-(id)initWithURL:(NSURL*)url withFileData:(NSData*)fdata withFileName:(NSString*)fileName withFieldName:(NSString*)fieldName withParams:(NSDictionary*)param {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setHTTPMethod:@"POST"];

	NSMutableData *body = [NSMutableData data];

	NSString *boundary = @"--A-PMMsg(0.1)-14737809831466499882746641449";
	NSString *endBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];

	if(param) {
		for(NSString *key in param) {
			[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Type: form-data; name=\"%@\"\r\n\r\n%@\r\n" , key, param[key]]  dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	//The file to upload
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"%@\"; filename=\"%@\"\r\n", fieldName, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:fdata]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

	// close the form
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

	// set request body
	[request setHTTPBody:body];
	return self;
}
@end