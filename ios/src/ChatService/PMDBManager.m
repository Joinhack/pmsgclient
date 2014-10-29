#import "PMDBManager.h"
#import <sqlite3.h>
#import <pmsg.h>

@implementation PMDBManager {
	sqlite3 *_database;
}

-(bool)createMsgTable:(NSInteger)type :(NSInteger)id {
	static NSString *tab = @"create table %@_%u(id text, fromId Integer, toId Integer, state Integer);";
	if(_database) {
		NSString *sql = [NSString stringWithFormat:tab, type==0?@"user":@"group", id];
		if([self execute:sql error:nil] == 1)
			return true;
	}
	return false;
}

-(NSInteger)execute:(NSString*)sql withCallback:(int(^)(sqlite3_stmt*, NSError**))cb error:(NSError**)e {
	if(_database) {
		sqlite3_stmt *stmt = NULL;
		int rs;
		if((rs = sqlite3_prepare_v2(_database, sql.UTF8String, -1, &stmt, NULL)) == SQLITE_OK) {
			NSString *errmsg;
			rs = cb(stmt, e);
		}
		NSString *errmsg;
		if(rs == SQLITE_ERROR) {
			const char *err = sqlite3_errmsg(_database);
			if(stmt != NULL) sqlite3_finalize(stmt);
			errmsg = [NSString stringWithUTF8String:err];
			if(e)
				*e = [NSError errorWithDomain:@"PMDB" code:-1 userInfo:@{@"detail": errmsg}];
			return -1;
		}
		if(stmt != NULL) sqlite3_finalize(stmt);
		return 1;
	}
	return 0;
}

-(NSInteger)execute:(NSString*)sql error:(NSError**)e {
	return [self execute:sql withCallback:^(sqlite3_stmt *stmt, NSError** e){ return sqlite3_step(stmt);} error:e];
}
-(bool)isExists:(NSString*)name error:(NSError**)e {
	if(_database) {
		NSString *sql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@';", name];
		__block bool exists = false;
		[self execute:sql withCallback:^(sqlite3_stmt *stmt, NSError **e){
			int rs;
			do {
				rs = sqlite3_step(stmt);
				if(rs == SQLITE_ERROR)
					return rs;
				char *nameChars = (char *) sqlite3_column_text(stmt, 1);
				exists = true;
			} while(rs == SQLITE_ROW);
			return SQLITE_DONE;
		} error:e];
		return exists;
	}
	return false;
}

-(NSString*) tabName:(PMMsg*)msg {
	NSString *tabName;
	NSInteger whoami = PMChat.sharedInstance.whoami.intValue;
	tabName = [NSString stringWithFormat:@"%@_%ld", msg.type==1?@"user":@"group", msg.to == whoami?msg.from:msg.to];
	return tabName;
}

-(long)saveMsg:(PMMsg*)msg {
	if(_database) {
		NSError *err;
	}
	return 0;
}


-(void)dealloc {
	if(_database) sqlite3_close(_database);
}

@end