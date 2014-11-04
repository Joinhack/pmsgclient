#import <Foundation/Foundation.h>

@protocol ILoginManagerDelegate <NSObject>
@optional
-(void) didLogin:(NSDictionary*)dict :(NSError*)error;
@end

@protocol ILoginManager <NSObject>
@required
-(NSDictionary*) login:(NSString*)user :(NSString*)passwd;
-(NSDictionary*) login:(NSString*)user :(NSString*)passwd withError:(NSError**) err;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*)) completion;

-(void) asyncLogin:(NSString*)user :(NSString*)passwd withCompletion:(void (^)(NSDictionary*,NSError*))completion onQueue:(dispatch_queue_t)queue;
@end
