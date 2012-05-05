//
//  DBManager.m
//  CountryListAgain
//
//  Created by Jakob Chong on 5/5/12.
//  Copyright (c) 2012 L&Rui Concept Group. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

static DBManager *dbManager = nil;
@synthesize database;
@synthesize categories;

+ (DBManager *)sharedDBManager{
    if (dbManager==nil){
        dbManager=[[super allocWithZone:NULL] init];
    }
    return dbManager;
}

-(BOOL)openDB
{
    NSString *writableDBFile = [self getDBFile];
    if (writableDBFile != nil)
    {
        if (sqlite3_open([writableDBFile UTF8String], &database) == SQLITE_OK)
        {
            return true;
        }
        else 
        {
            NSLog(@"Error in opening database");
            return false;
        }
    }
    else
    {
        NSLog(@"DB file not found.");
        return false;
    }
}

-(BOOL)executeSql:(NSString *)sSql
{
    int rc = SQLITE_OK;
    rc = sqlite3_exec(database, [sSql UTF8String], NULL, NULL, NULL);
    if (rc != SQLITE_OK)
    {
        NSLog(@"Error executing SQL: %s", sqlite3_errmsg(database));
        return false;
    }
    else
    {
        return true;
    }
}

-(void)closeDB
{
    sqlite3_close(database);
}

-(NSString *)getDBFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBFile = [documentsDirectory stringByAppendingPathComponent:@"CategoryList.db"];
    return writableDBFile;
}

@end
