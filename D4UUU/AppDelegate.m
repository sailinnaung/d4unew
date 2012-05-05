//
//  AppDelegate.m
//  D4UUU
//
//  Created by Arun Manivannan on 5/5/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "AppDelegate.h"
#import "DBManager.h"

@implementation AppDelegate

@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self createEditableCopyOfDatabaseIfNeeded];
    [self loadSelectedFromDatabase];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded 
{
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"CategoryList.db"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
    {
        return;
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CategoryList.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}



- (void) loadSelectedFromDatabase {
    DBManager* dbManager=[DBManager sharedDBManager];
    if ([dbManager openDB] == true) {
        int iTemp = sqlite3_exec([dbManager database], "SELECT selected_category FROM SelectedCategory", CBSelected, nil, NULL);
        if (iTemp != SQLITE_OK) {
            NSLog(@"Error executing SQL: %s", sqlite3_errmsg([dbManager database]));
        }
        [dbManager closeDB];
    } else {
        // alert failed to connect to database?
    }
}


// CallBack method to load Available Selected into arrSelected
static int CBSelected (void *context, int count, char **values, char **columns)
{    
    NSString* tempString=[[NSMutableString alloc]initWithString:@""];
    
    for (int i=0; i < count; i++)
    {
        const char *nameCString = values[i];
        NSString *sCurr = [NSString stringWithUTF8String:nameCString];
     
        NSLog(@"Current category string %@", sCurr);
        
        tempString=[[tempString stringByAppendingString:sCurr] stringByAppendingString:@","];
               

        tempString=[tempString substringToIndex:[tempString length]-1];
        
        NSLog(@"MUtable category string %@", tempString);

    }
    //NSLog(@"MUtable category string %@", tempString);
    
    [DBManager sharedDBManager].categories=[[NSMutableString alloc]initWithString:tempString];
    
    
    
    return SQLITE_OK;
}

@end
