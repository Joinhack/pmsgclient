#import "PMDBManager.h"
#import <sqlite3.h>
#import <pmsg.h>
#import "../Models/PMMsg+Serial.h"

#define BCHECK(s) if(s != SQLITE_OK) return SQLITE_ERROR

@implementation PMDBManager {
	sqlite3 *_database;
	NSMutableSet *_tabExists;
}

-(id)init:(NSString*)path {
	self = [super init];
	if(self) {
		_tabExists = [NSMutableSet setWithCapacity:5];
		if(sqlite3_open(path.UTF8String, &_database)) {
			NSString *msg = [NSString stringWithFormat:@"%s", sqlite3_errmsg(_database)];
			NSAssert(0, msg);
			sqlite3_close(_database);
			_database = NULL;
		}
	}
	return self;
}


-(NSInteger)execute:(NSString*)sql withCallback:(int(^)(sqlite3_stmt*, NSError**))cb error:(NSError**)e {
	if(_database) {
		NSLog(@"sql: %@", sql);
		sqlite3_stmt *stmt = NULL;
		int rs;
		if((rs = sqlite3_prepare_v2(_database, sql.UTF8String, -1, &stmt, NULL)) == SQLITE_OK) {
			NSString *errmsg;
			rs = cb(stmt, e);
			if(e && *e) return -1;
		}
		NSString *errmsg;
		if(rs != SQLITE_DONE && rs != SQLITE_ROW) {
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
	NSInteger whoami = PMChat.sharedInstance.whoami.intValue;
	tabName = [NSString stringWithFormat:@"%@_%ld", msg.type==1?@"user":@"group", msg.to == whoami?msg.from:msg.to];
	return tabName;
}

-(NSError*) tableCheck:(NSString*)tabName :(NSString*)tableSchema {
		NSError *err;
		if(![_tabExists containsObject:tabName]) {
			bool flags = [self isExists:tabName error:&err];
			if(err) return err;
			if(flags) {
				[_tabExists addObject:tabName];
			} else {
				[self execute:tableSchema error:&err];
				if(err) return err;
				[_tabExists addObject:tabName];
			}
		}
		return nil;
}

-(NSInteger)seq:(NSInteger)inMem {
	if(_database) {
		NSError *err;
		static NSString *tab = @"create table seq(seq Integer default 1, name text);";
		err = [self tableCheck:@"seq" :tab];
		if(err) return ++inMem;
		__block NSInteger mval = inMem;
		__block id me = self;
		[self execute:@"select seq from seq where name='seq';" withCallback:^(sqlite3_stmt* stmt, NSError** e) {
			if(sqlite3_step(stmt) == SQLITE_ROW) {
				NSInteger val = sqlite3_column_int(stmt, 0);
				if(val > inMem)
					mval = val;
				mval++;

				[me execute:[NSString stringWithFormat:@"update seq set seq=%ld where name='seq';", mval] error:nil];
			} else {
				[me execute:[NSString stringWithFormat:@"insert into seq values(%ld, 'seq')", ++mval] error:nil];
			}
			return SQLITE_DONE;
		} error:nil];
		return mval;
	} else {
		return ++inMem;
	}
}



-(NSInteger)saveMsg:(PMMsg*)msg error:(NSError**)error {
	if(_database) {
		NSError *err;
		NSString *tabName = [self tabName:msg];
		static NSString *tab = @"create table %@(id text, fromid int, toid int, state int, msg text);";
		err = [self tableCheck:tabName :[NSString stringWithFormat:tab, tabName]];
		if(err && error) {
			*error = err;
			return -1;
		}
		PMMsg *m = msg;
		NSInteger whoami = PMChat.sharedInstance.whoami.intValue;
		int stat = whoami == m.from? 0: 2;

		[self execute:[NSString stringWithFormat:@"insert into %@ values(?, ?, ?, ?, ?);", tabName] withCallback:^(sqlite3_stmt *stmt, NSError** e){
			BCHECK(sqlite3_bind_text(stmt, 1, m.id.UTF8String, -1, SQLITE_STATIC));
			BCHECK(sqlite3_bind_int(stmt, 2, m.from));
			BCHECK(sqlite3_bind_int(stmt, 3, m.to));
			BCHECK(sqlite3_bind_int(stmt, 4, stat));
			NSString *json = [m toJson:nil];
			BCHECK(sqlite3_bind_text(stmt, 5, json.UTF8String, -1, SQLITE_STATIC));
			return sqlite3_step(stmt);
		} error:&err];
		NSLog(@"%@", err);
	}
	return 0;
}

-(void)dealloc {
	if(_database) sqlite3_close(_database);
}

@end