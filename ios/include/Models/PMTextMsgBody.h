#import <Foundation/Foundation.h>
#import "PMMsgBody.h"

@interface PMTextMsgBody : PMMsgBody {
}

-(id)initWithContent:(NSString*)content;

+(id)msgBodyWithContent:(NSString*)content;

@property (nonatomic, strong) NSString *content;

@end

