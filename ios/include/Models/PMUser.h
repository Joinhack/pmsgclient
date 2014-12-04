#import <Foundation/Foundation.h>

typedef enum {
	UserState_Free = 0,
	UserState_Following,
	UserState_Followed,
	UserState_Friend,
} UserState;

@interface PMUser : NSObject {
}

@property (nonatomic) NSInteger id;

@property (nonatomic) NSString *name;

@property (nonatomic) UserState state;

@end