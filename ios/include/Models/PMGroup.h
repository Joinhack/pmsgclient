#import <Foundation/Foundation.h>

@interface PMGroup : NSObject {
}

@property (nonatomic) BOOL isPublic;

@property (nonatomic) NSString* id;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) NSArray *members;

@property (nonatomic, strong) NSArray *admin;

@end
