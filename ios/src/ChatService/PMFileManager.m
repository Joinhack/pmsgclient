#import "PMFileManager.h"
#import <AFNetworking.h>
#import <pmsg.h>


@implementation PMFileManager{
}

-(void)uploadImage:(NSString*)file completion:(void(^)(NSDictionary*, NSError*))completion {
	[self uploadImage:file withProgress:nil completion:completion];
}

-(void)uploadImage:(NSString*)file withProgress:(void(^)(NSUInteger,long long,long long))progress completion:(void(^)(NSDictionary*, NSError*))completion {
	[self uploadImage:file withProgress:progress completion:completion onQueue:PMChat.sharedInstance.defaultQueue];
} 

-(void)uploadImage:(NSString*)file withProgress:(void(^)(NSUInteger,long long,long long))progress completion:(void(^)(NSDictionary*, NSError*))completion onQueue:(dispatch_queue_t)q {
	NSString* fileName = [[file lastPathComponent] stringByDeletingPathExtension];
	NSData *data = [NSData dataWithContentsOfFile:
                      [file stringByExpandingTildeInPath]];
	[self uploadFile:fileName data:data parameters:nil
		withProgress:progress success:^(AFHTTPRequestOperation *op, id data) {
			if(completion) completion((NSDictionary*)data, nil);
		} failure: ^(AFHTTPRequestOperation *op, NSError *err) {
			if(completion) completion(nil, err);
		} onQueue:q];
}

-(void)uploadFile:(NSString*)fileName data:(NSData*)data parameters:(NSDictionary*)parameters withProgress:(void(^)(NSUInteger,long long,long long))progress success:(void(^)(AFHTTPRequestOperation *, id ))success failure:(void(^)(AFHTTPRequestOperation *, NSError *))failure onQueue:(dispatch_queue_t)queue {
	NSString* url = [NSString stringWithFormat:@"%@/fileupload",PMChat.sharedInstance.restUrl];
	AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
	NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    	[formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
		} error:nil
	];

	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	if(queue == nil) queue = PMChat.sharedInstance.defaultQueue;
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.completionQueue = queue;
	AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:success failure:failure];
	if(progress) [operation setUploadProgressBlock:progress];
	[operation start];
}


@end