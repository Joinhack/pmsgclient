#import <Foundation/Foundation.h>
#import "ILoginManager.h"
#import "IMsgManager.h"


@protocol IChatManager <ILoginManager, IMsgManager>
@end
