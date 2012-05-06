//
//  AppDelegate.m
//  D4UUU
//
//  Created by Arun Manivannan on 5/5/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "AppDelegate.h"
#import "DBManager.h"
#import "Constants.h"
#import "WhatsAroundYouMasterController.h"

@implementation AppDelegate

@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Chen Lim: copy local database to Documents folder (on first run)
    [self createEditableCopyOfDatabaseIfNeeded];
    // Chen Lim: load available categories from DB
    [self loadAvailableFromDatabase];
    // Chen Lim: load selected categories from DB
    [self loadSelectedFromDatabase];
    
    UITabBarController* mainTabController = (UITabBarController*)self.window.rootViewController;
    
    //mainTabBarDelegate = [[TabBarDelegate alloc] init];
    //mainTabController.delegate = mainTabBarDelegate;
    mainTabController.delegate=self;
    //self.window.rootViewController.tabBarController.delegate=self;

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
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
    {
        return;
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}





// CallBack method to load Available Selected into arrSelected
static int CBSelected (void *context, int count, char **values, char **columns)
{    
    NSString* tempString=[[NSMutableString alloc]initWithString:@""];
    
    // chen lim: do we really need this? Seem like only 1 count per callback.
    for (int i=0; i < count; i++)
    {
        const char *nameCString = values[i];
        NSString *sCurr = [NSString stringWithUTF8String:nameCString];
     
        tempString=[[tempString stringByAppendingString:sCurr] stringByAppendingString:@","];
        tempString=[tempString substringToIndex:[tempString length]-1];
    }
    
    // chen lim: if is only 1 count per call back, then we need to append to DBManager's categories string.
    if ([DBManager sharedDBManager].categoriesSelected == nil)
    {
        [DBManager sharedDBManager].categoriesSelected = [[NSMutableString alloc]initWithString:tempString];
    }
    else
    {
        NSString *sFinal = [[[DBManager sharedDBManager].categoriesSelected stringByAppendingString:@","] stringByAppendingString:tempString];
        [DBManager sharedDBManager].categoriesSelected = [[NSMutableString alloc]initWithString:sFinal];
    }

    return SQLITE_OK;
}

- (void) loadSelectedFromDatabase {
    DBManager* dbManager=[DBManager sharedDBManager];
    if ([dbManager openDB] == true) {
        
        int iTemp = sqlite3_exec([dbManager database], "SELECT selected_category FROM SelectedCategory", CBSelected, self, NULL);
        if (iTemp != SQLITE_OK) {
            NSLog(@"Error executing SQL: %s", sqlite3_errmsg([dbManager database]));
        }
        [dbManager closeDB];
    } else {
        // alert failed to connect to database?
    }
}


// CallBack method to load Available Categories into arrAvailable
static int CBAvailable (void *context, int count, char **values, char **columns)
{
    NSString* tempString=[[NSMutableString alloc]initWithString:@""];
    
    // chen lim: do we really need this? Seem like only 1 count per callback.
    NSMutableArray *arrAvailable = (NSMutableArray *)context;
    for (int i=0; i < count; i++)
    {
        const char *nameCString = values[i];
        [arrAvailable addObject:[NSString stringWithUTF8String:nameCString]];
        NSString *sCurr = [NSString stringWithUTF8String:nameCString];
        
        tempString=[[tempString stringByAppendingString:sCurr] stringByAppendingString:@","];
        tempString=[tempString substringToIndex:[tempString length]-1];
    }
    
    // chen lim: if is only 1 count per call back, then we need to append to DBManager's categories string.
    if ([DBManager sharedDBManager].categoriesAvailable == nil)
    {
        [DBManager sharedDBManager].categoriesAvailable = [[NSMutableString alloc]initWithString:tempString];
    }
    else
    {
        NSString *sFinal = [[[DBManager sharedDBManager].categoriesAvailable stringByAppendingString:@","] stringByAppendingString:tempString];
        [DBManager sharedDBManager].categoriesAvailable = [[NSMutableString alloc]initWithString:sFinal];
    }

    return SQLITE_OK;
}

- (void) loadAvailableFromDatabase {
    DBManager* dbManager=[DBManager sharedDBManager];
    if (dbManager.arrAvailable == nil)
    {
        dbManager.arrAvailable = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if ([dbManager openDB] == true) {
        int iTemp = sqlite3_exec([dbManager database], "SELECT category_name FROM Category", CBAvailable, dbManager.arrAvailable, NULL);
        if (iTemp != SQLITE_OK) {
            NSLog(@"Error executing SQL: %s", sqlite3_errmsg([dbManager database]));
        }
        [dbManager closeDB];
    } else {
        // alert failed to connect to database?
    }
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

     NSLog(@"Selected now %@", viewController);   
        if ([viewController isKindOfClass:[UINavigationController class]]){
            UINavigationController *navController=(UINavigationController*) viewController;
            for (UIViewController *eachViewController in navController.viewControllers){ 
                if ([eachViewController isKindOfClass:[WhatsAroundYouMasterController class]]){                    
                    WhatsAroundYouMasterController* whatsAroundMasterController=(WhatsAroundYouMasterController*)eachViewController;
                    NSLog(@"Selected now %@", whatsAroundMasterController);    
        //[whatsAroundMasterController performSelector:@"updateLocationAndCategory"];
                    [whatsAroundMasterController updateLocationAndCategory];
                }
            }
        }
            

    
    }
    

    
    /*
    NSLog(@"tabBarController %@", tabBarController.description);
    //check to see if navbar "get" worked
    if (tabBarController.viewControllers) {
        
        
        //look for the nav controller in tab bar views 
        for (UINavigationController *view in tabBarController.viewControllers) {
            NSLog(@"navigationController %@", view.description);    
            //when found, do the same thing to find the MasterViewController under the nav controller
            if ([view isKindOfClass:[UINavigationController class]])
                for (UIViewController *view2 in view.viewControllers) 
                    if ([view2 isKindOfClass:[WhatsAroundYouMasterController class]])                    
                        result = (WhatsAroundYouMasterController *) view2;
            NSLog(@"result %@", result.description);   
            result. 
        }
    }*/
    
    


@end
