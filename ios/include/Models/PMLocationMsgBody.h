#import <Foundation/Foundation.h>
#import "PMMsgBody.h"

@interface PMLocationMsgBody : PMMsgBody {
}

@property (nonatomic, strong) NSNumber *lat;

@property (nonatomic, strong) NSNumber *lng;

@property (nonatomic, strong) NSString *address;

@end

