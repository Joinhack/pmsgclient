#import <Foundation/Foundation.h>

@interface PMFileManager:NSObject <NSObject> {
}

-(void)uploadImage:(NSString*)file completion:(void(^)(NSDictionary*, NSError*))completion;

-(void)uploadImage:(NSString*)file withProgress:(void(^)(NSUInteger,long long,long long))progress completion:(void(^)(NSDictionary*, NSError*))completion;

-(void)uploadImage:(NSString*)file withProgress:(void(^)(NSUInteger,long long,long long))progress completion:(void(^)(NSDictionary*, NSError*))completion onQueue:(dispatch_queue_t)q;

@end