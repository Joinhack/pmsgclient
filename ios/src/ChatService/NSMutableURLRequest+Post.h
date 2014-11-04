
@interface NSMutableURLRequest (Post)
-(id)initWithURL:(NSURL*)url withParams:(NSDictionary*)param;

-(id)initWithURL:(NSURL*)url withFileData:(NSData*)data withFileName:(NSString*)fileName withFieldName:(NSString*)fieldName withParams:(NSDictionary*)param;

@end