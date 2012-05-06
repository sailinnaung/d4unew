//
//  DBManager.h
//  D4UUU
//
//  Created by Toh Chen Lim on 5/5/12.
//  Copyright (c) 2012 chenlim@ambracetech.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DBManager : NSObject {
    NSMutableString* categoriesAvailable;
    NSMutableString* categoriesSelected;
    NSMutableArray *arrAvailable;
}

@property sqlite3 *database;
-(BOOL) openDB;
-(BOOL) executeSql: (NSString*) sSql;
-(void) closeDB;
+(DBManager*) sharedDBManager;
-(NSString *)getDBFile;

@property (strong, nonatomic) NSMutableString* categoriesSelected;
@property (strong, nonatomic) NSMutableString* categoriesAvailable;
@property (strong, nonatomic) NSMutableArray *arrAvailable;

@end
