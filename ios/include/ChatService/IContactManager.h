#import <Foundation/Foundation.h>

@protocol IContactManager <NSObject>
@required

-(BOOL) followUser:(NSInteger)uid;

-(BOOL) followUser:(NSInteger)uid withError:(PMError**)error;

-(BOOL) followUser:(NSInteger)uid withMessage:(NSString*)msg withError:(PMError**)error;

-(void) asyncFollowUser:(NSInteger)uid withMessage:(NSString*)msg withCompletion:(void(^)(PMError*))completion onQueue:(dispatch_queue_t)queue;

-(BOOL) acceptUser:(NSInteger)uid;

-(BOOL) acceptUser:(NSInteger)uid withError:(PMError**)error;

-(BOOL) acceptUser:(NSInteger)uid withMessage:(NSString*)msg withError:(PMError**)error;

-(void) asyncAcceptUser:(NSInteger)uid withMessage:(NSString*)msg withCompletion:(void(^)(PMError*))completion onQueue:(dispatch_queue_t)queue;

-(BOOL) rejectUser:(NSInteger)uid;

-(BOOL) rejectUser:(NSInteger)uid withError:(PMError**)error;

-(BOOL) rejectUser:(NSInteger)uid withMessage:(NSString*)msg withError:(PMError**)error;

-(void) asyncRejectUser:(NSInteger)uid withMessage:(NSString*)msg withCompletion:(void(^)(PMError*))completion onQueue:(dispatch_queue_t)queue;

@end
