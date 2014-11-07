#import <Foundation/Foundation.h>
#import "PMMsgBody.h"

@interface PMTextMsgBody : PMMsgBody {
}

-(instancetype)initWithContent:(NSString*)content;

+(instancetype)msgBodyWithContent:(NSString*)content;

@property (nonatomic, strong) NSString *content;

@end

