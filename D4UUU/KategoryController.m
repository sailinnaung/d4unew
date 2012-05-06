//
//  KategoryController.m
//  D4UUU
//
//  Created by Arun Manivannan on 5/5/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "KategoryController.h"
#import "DBManager.h"

@interface KategoryController (){
    
    DBManager *dbManager;
}
@end

@implementation KategoryController


@synthesize arrAvailable, arrSelected, uiTableView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    dbManager = [DBManager sharedDBManager];
    arrAvailable = [[NSMutableArray alloc] init];
    arrSelected = [[NSMutableArray alloc] init];
    [self loadAvailableFromDatabase];
    [self loadSelectedFromDatabase]; 
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    // [arrAvailable release];
    // [arrSelected release];
}


// CallBack method to load Available Categories into arrAvailable
static int CBAvailable (void *context, int count, char **values, char **columns)
{
    NSMutableArray *arrAvailable = (NSMutableArray *)context;
    for (int i=0; i < count; i++)
    {
        const char *nameCString = values[i];
        [arrAvailable addObject:[NSString stringWithUTF8String:nameCString]];
    }
    return SQLITE_OK;
}

// CallBack method to load Available Selected into arrSelected
static int CBSelected (void *context, int count, char **values, char **columns)
{
    KategoryController *self = (KategoryController *)context;
    
    NSString* tempString=[[[NSMutableString alloc] initWithString:@""]autorelease];
    for (int i=0; i < count; i++)
    {
        const char *nameCString = values[i];
        NSString *sCurr = [NSString stringWithUTF8String:nameCString];
        NSLog(@"About to print current %@", sCurr);
        
        for (int j=0; j < self.arrAvailable.count; j++)
        {
           
            
            NSString *sTemp = [self.arrAvailable objectAtIndex:j];
            
             NSLog(@"About to print available %@", sTemp);
            
            if ([sTemp isEqualToString:sCurr] == true)
            {                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:0];
                [self.uiTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                tempString=[[tempString stringByAppendingString:sTemp] stringByAppendingString:@","];
                [self.arrSelected addObject:sTemp];  
            }
        }
    }
    
    //id object=[constructCategoryString:self.arrAvailable];
    
    /*NSString* tempString=[[[NSMutableString alloc] initWithString:@""]autorelease];
    if (self.arrSelected){
        
        
        for (NSString* eachCategory in self.arrSelected){
            
            tempString=[[tempString stringByAppendingString:eachCategory] stringByAppendingString:@","];
            
        }
        
        tempString=[tempString substringToIndex:[tempString length]-1];
    }
     */
    NSLog(@"Temp Category String %@", tempString);
    
    [DBManager sharedDBManager].categories=[[NSMutableString alloc]initWithString:tempString];
    
    
    return SQLITE_OK;
}

/*
 + (NSString*) constructCategoryString:(NSMutableArray*)arrayAvailable {
 
 NSMutableString* tempString=[[NSMutableString alloc] initWithString:nil];
 if (arrayAvailable){
 
 
 for (NSString* eachCategory in arrayAvailable){
 
 [[tempString stringByAppendingString:eachCategory] stringByAppendingString:@","];
 
 }
 
 [tempString substringToIndex:[tempString length]-1];
 }
 NSLog(@"MUtable category string %@", tempString);
 
 return [[NSString stringWithString:tempString]autorelease];
 
 }*/

- (void) loadAvailableFromDatabase {
    if ([dbManager openDB] == true) {
        int iTemp = sqlite3_exec([dbManager database], "SELECT category_name FROM Category", CBAvailable, arrAvailable, NULL);
        if (iTemp != SQLITE_OK) {
            NSLog(@"Error executing SQL: %s", sqlite3_errmsg([dbManager database]));
        }
        [dbManager closeDB];
    } else {
        // alert failed to connect to database?
    }
}


- (void) loadSelectedFromDatabase {
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrAvailable count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier] autorelease];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [arrAvailable objectAtIndex:row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *sItem = [arrAvailable objectAtIndex:row];
    
    if ([dbManager openDB] == true) {
        NSString *sSql = [NSString stringWithFormat:@"INSERT INTO SelectedCategory (selected_category) VALUES ('%@')", sItem];
        BOOL bSuccess = [dbManager executeSql:sSql];
        NSLog(@"Inserting %@",sItem);
        if (bSuccess == true) {
            // alert user failed to update db?
        }
        
        // close the DB
        [dbManager closeDB];
    } else {
        // alert user failed to connect to db?
    }
    
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *sItem = [arrAvailable objectAtIndex:row];
    
    if ([dbManager openDB] == true) {
        NSString *sSql = [NSString stringWithFormat:@"DELETE FROM SelectedCategory WHERE selected_category = '%@'", sItem];
        BOOL bSuccess = [dbManager executeSql:sSql];
        if (bSuccess != true) {
            // alert user failed to update db?
        }
        
        // close the DB
        [dbManager closeDB];
    } else {
        // alert user failed to connect to db?
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end