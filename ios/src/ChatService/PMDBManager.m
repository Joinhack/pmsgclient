#import "PMDBManager.h"
#import <sqlite3.h>

@implementation PMDBManager {
	sqlite3 *_database;
}

-(bool)createMsgTable:(NSInteger)type :(NSInteger)id {
	static NSString *tab = @"create table %@_%u(id text, fromId Integer, toId Integer, state Integer);";
	if(_database) {
		NSString *sql = [NSString stringWithFormat:tab, type==0?@"user":@"group", id];
		sqlite3_stmt *smt;
		if(sqlite3_prepare_v2(_database, sql.UTF8String, -1, &smt, NULL) == SQLITE_OK) {
			bool done = sqlite3_step(smt) == SQLITE_DONE;
			sqlite3_finalize(smt);
			return done;
		}
	}
	return false;
}

-(void)dealloc {
	if(_database) sqlite3_close(_database);
}

@end