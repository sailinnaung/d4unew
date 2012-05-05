//
//  DBManager.h
//  CountryListAgain
//
//  Created by Jakob Chong on 5/5/12.
//  Copyright (c) 2012 L&Rui Concept Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DBManager : NSObject {
    NSMutableString* categories;

}

@property sqlite3 *database;
-(BOOL) openDB;
-(BOOL) executeSql: (NSString*) sSql;
-(void) closeDB;
+(DBManager*) sharedDBManager;
@property (strong, nonatomic) NSMutableString* categories;

@end
