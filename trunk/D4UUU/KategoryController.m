//
//  KategoryController.m
//  D4UUU
//
//  Created by Toh Chen Lim on 5/5/12.
//  Copyright (c) 2012 chenlim@ambracetech.com. All rights reserved.
//

#import "KategoryController.h"
#import "DBManager.h"
#import "AppDelegate.h"

@interface KategoryController (){    
    DBManager *dbManager;
    AppDelegate *appDelegate;
}
@end

@implementation KategoryController

@synthesize uiTableView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Preferred Categories";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    dbManager = [DBManager sharedDBManager];
    appDelegate  = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self preselect];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)preselect
{
    // preselect the table row
    NSArray *selectedCats = [[dbManager categoriesSelected] componentsSeparatedByString:@","];
    
    for (int i=0; i < selectedCats.count; i++)
    {
        NSString *sCurrSelected = [selectedCats objectAtIndex:i];
        for (int j=0; j < dbManager.arrAvailable.count; j++)
        {
            NSString *sCurrAvailable = [dbManager.arrAvailable objectAtIndex:j];
            
            if ([sCurrAvailable isEqualToString:sCurrSelected] == true)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:0];
                [self.uiTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dbManager.arrAvailable count];
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
    cell.textLabel.text = [dbManager.arrAvailable objectAtIndex:row];
    
    return cell;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath 
{
    
    NSUInteger row = [indexPath row];
    NSString *sItem = [dbManager.arrAvailable objectAtIndex:row];
    NSRange range = [[dbManager categoriesSelected] rangeOfString:sItem];
    if (range.length > 0)
    {
        return UITableViewCellAccessoryCheckmark;
    }
    else 
    {
        return UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([dbManager openDB] == true) 
    {
        NSUInteger row = [indexPath row];
        NSString *sItem = [dbManager.arrAvailable objectAtIndex:row];
    
        UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
        if (thisCell.accessoryType == UITableViewCellAccessoryNone) 
        {
            NSString *sSql = [NSString stringWithFormat:@"INSERT INTO SelectedCategory (selected_category) VALUES ('%@')", sItem];
            BOOL bSuccess = [dbManager executeSql:sSql];
            if (bSuccess == true) 
            {
                thisCell.accessoryType = UITableViewCellAccessoryCheckmark;            
            }
            else 
            {
                // alert user failed to update db?
            }
        } 
        else 
        {
            NSString *sSql = [NSString stringWithFormat:@"DELETE FROM SelectedCategory WHERE selected_category = '%@'", sItem];
            BOOL bSuccess = [dbManager executeSql:sSql];
            if (bSuccess == true) 
            {
                thisCell.accessoryType = UITableViewCellAccessoryNone;
            } 
            else 
            {
                // alert user failed to update db?
            }
        }
        
        [dbManager closeDB];
        
        // reset categories to blank
        dbManager.categoriesSelected = nil;
        
        // repopulate categories
        [appDelegate loadSelectedFromDatabase];
    } 
    else 
    {
        // alert user failed to connect to db?
    }
}

@end
