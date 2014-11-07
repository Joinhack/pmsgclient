#import <Foundation/Foundation.h>
#import "PMMsgBody.h"

@interface PMImageMsgBody : PMMsgBody {
}

+(instancetype)localFile:(NSString*)path;

@property (nonatomic, strong) NSString *scaledUrl;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *name;

@end

