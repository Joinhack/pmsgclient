#import <pmsg.h>
#import "PMDBManager.h"
#import <sqlite3.h>

#import "../Models/PMMsg+Inner.h"

#define BCHECK(s) if(s != SQLITE_OK) return SQLITE_ERROR

@implementation PMDBManager {
	sqlite3 *_database;
	NSMutableSet *_tabExists;
}

-(NSInteger) whoami {
		return PMChat.sharedInstance.whoami.intValue;
}

-(instancetype)init:(NSString*)path {
	self = [super init];
	if(self) {
		_tabExists = [NSMutableSet setWithCapacity:5];
		sqlite3_threadsafe();
		if(sqlite3_open(path.UTF8String, &_database)) {
			NSString *msg = [NSString stringWithFormat:@"%s", sqlite3_errmsg(_database)];
			NSAssert(0, msg);
			sqlite3_close(_database);
			_database = NULL;
		}
	}
	return self;
}


-(NSInteger)execute:(NSString*)sql withCallback:(int(^)(sqlite3_stmt*, PMError**))cb error:(PMError**)e {
	if(_database) {
		NSLog(@"sql: %@", sql);
		@synchronized(self) {
			sqlite3_stmt *stmt = NULL;
			int rs;
			if((rs = sqlite3_prepare_v2(_database, sql.UTF8String, -1, &stmt, NULL)) == SQLITE_OK) {
				rs = cb(stmt, e);
				if(e && *e) return -1;
			}
			NSString *errmsg;
			if(rs != SQLITE_DONE && rs != SQLITE_ROW) {
				const char *err = sqlite3_errmsg(_database);
				if(stmt != NULL) sqlite3_finalize(stmt);
				errmsg = [NSString stringWithUTF8String:err];
				if(e)
					*e = [PMError errorWithCode:PMDBOperatorError withDescription:errmsg];
				return -1;
			}
			if(stmt != NULL) sqlite3_finalize(stmt);
		}
		return 1;
	}
	return 0;
}

-(NSInteger)execute:(NSString*)sql error:(PMError**)e {
	return [self execute:sql withCallback:^(sqlite3_stmt *stmt, PMError** e){ return sqlite3_step(stmt);} error:e];
}
-(bool)isExists:(NSString*)name error:(PMError**)e {
	if(_database) {
		NSString *sql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@';", name];
		__block bool exists = false;
		[self execute:sql withCallback:^(sqlite3_stmt *stmt, PMError **e){
			int rs;
			do {
				rs = sqlite3_step(stmt);
				if(rs != SQLITE_ROW)
					return rs;
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
	tabName = [NSString stringWithFormat:@"%@_%ld", msg.type==1?@"user":@"group", msg.from == self.whoami?msg.to:msg.from];
	return tabName;
}

-(PMError*) tableCheck:(NSString*)tabName :(NSString*(^)())tableSchema {
		PMError *err;
		if(![_tabExists containsObject:tabName]) {
			bool flags = [self isExists:tabName error:&err];
			if(err) return err;
			if(flags) {
				[_tabExists addObject:tabName];
			} else {
				[self execute:tableSchema() error:&err];
				if(err) return err;
				[_tabExists addObject:tabName];
			}
		}
		return nil;
}

-(NSInteger)seq:(NSInteger)inMem {
	if(_database) {
		PMError *err;
		err = [self tableCheck:@"seq" :^{return @"create table seq(seq Integer default 1, name text);";}];
		if(err) return ++inMem;
		__block NSInteger mval = inMem;
		[self execute:@"select seq from seq where name='seq';" withCallback:^(sqlite3_stmt* stmt, PMError** e) {
			if(sqlite3_step(stmt) == SQLITE_ROW) {
				NSInteger val = sqlite3_column_int(stmt, 0);
				if(val > inMem)
					mval = val;
				mval++;

				[self execute:[NSString stringWithFormat:@"update seq set seq=%ld where name='seq';", mval] error:nil];
			} else {
				[self execute:[NSString stringWithFormat:@"insert into seq values(%ld, 'seq')", ++mval] error:nil];
			}
			return SQLITE_DONE;
		} error:nil];
		return mval;
	} else {
		return ++inMem;
	}
}

static NSString *msgTableSchema = @"create table %@(id text, fromid int, toid int, state int, msg text);";

-(void)begin {
	[self execute:@"begin exclusive transaction" error:nil];
}

-(void)commit {
	[self execute:@"commit transaction" error:nil];
}

-(void)rollback {
	[self execute:@"rollback transaction" error:nil];
}

-(NSUInteger)saveMsg:(PMMsg*)msg error:(PMError**)error {
	if(_database) {
		PMError *err;
		NSString *tabName = [self tabName:msg];
		err = [self tableCheck:tabName :^{return [NSString stringWithFormat:msgTableSchema, tabName];}];
		if(err && error) {
			*error = err;
			return -1;
		}
		static NSString *sql = @"insert into %@ values(?, ?, ?, ?, ?);";
		[self execute:[NSString stringWithFormat:sql, tabName] withCallback:^(sqlite3_stmt *stmt, PMError** e){
			BCHECK(sqlite3_bind_text(stmt, 1, msg.id.UTF8String, -1, SQLITE_STATIC));
			BCHECK(sqlite3_bind_int(stmt, 2, msg.from));
			BCHECK(sqlite3_bind_int(stmt, 3, msg.to));
			BCHECK(sqlite3_bind_int(stmt, 4, msg.state));
			NSString *json = [msg toJson:nil];
			BCHECK(sqlite3_bind_text(stmt, 5, json.UTF8String, -1, SQLITE_STATIC));
			return sqlite3_step(stmt);
		} error:&err];
		if(err && error) {
			*error = err;
			return -1;
		}
		msg.rowid = sqlite3_last_insert_rowid(_database);
		return msg.rowid;
	}
	return 0;
}

-(NSInteger)updateMsg:(PMMsg*)msg withNewId:(NSString*)nid  error:(PMError**)error {
	if(_database) {
		PMError *err;
		NSString *tabName = [self tabName:msg];
		err = [self tableCheck:tabName :^{return [NSString stringWithFormat:msgTableSchema, tabName];}];
		if(err && error) {
			*error = err;
			return -1;
		}
		static NSString *sql = @"update %@ set state=?, id=? where id=?";
		[self execute:[NSString stringWithFormat:sql, tabName] withCallback:^(sqlite3_stmt *stmt, PMError** e){
			BCHECK(sqlite3_bind_int(stmt, 1, msg.state));
			BCHECK(sqlite3_bind_text(stmt, 2, nid.UTF8String, -1, SQLITE_STATIC));
			BCHECK(sqlite3_bind_text(stmt, 3, msg.id.UTF8String, -1, SQLITE_STATIC));
			return sqlite3_step(stmt);
		} error:&err];
		if(err && error) {
			*error = err;
			return -1;
		}
		return 1;
	}
	return 0;
}

-(void)dealloc {
	if(_database) sqlite3_close(_database);
}

@end