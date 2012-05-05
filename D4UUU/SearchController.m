//
//  SearchController.m
//  Deals4U
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "SearchController.h"
#import "DealsServiceManager.h"
#import "Constants.h"
#import "Deal.h"


@implementation SearchController

@synthesize searchBarObj, searchDisplayController, deals,resultTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { 
        self.title = NSLocalizedString(@"Search", @"Search");
        self.tabBarItem.image = [UIImage imageNamed:@"search"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.resultTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"inside SearchController.numberOfRowsInSection method");
    NSInteger rows;
    
    if(tableView == [[self searchDisplayController] searchResultsTableView])
        rows = [[self deals] count];
    else
        rows = 1;
    return rows;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"inside SearchController.cellForRowAtIndexPath");
    Deal *dealObj;
    NSURL *url;
    NSData *data;
    UIImage *image;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;        
        
    }
    
    if(deals == nil){
         
        cell.textLabel.text = DEFAULT_SEARCH_RESULT_STRING;
        
    }else{
        
        dealObj = [deals objectAtIndex:indexPath.row];
        NSMutableString* imageUrl=[NSMutableString stringWithString:dealObj.imageUrl];
        NSLog(@"ImageUrl Before %@",imageUrl);
        [imageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        NSLog(@"ImageUrl after %@",imageUrl);
        
        url = [NSURL URLWithString:imageUrl];
        data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        
        cell.textLabel.text = dealObj.dealTitle;
        cell.detailTextLabel.text=[NSString stringWithString:dealObj.description];
        cell.imageView.image=image;
        NSLog(@"Cell image %@",cell.imageView.image.description );
    }
        
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    
    return cell;    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"inside SearchController.didSelectRowAtIndexPath");
    
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"inside SearchController.shouldReloadTableForSearchString");
    [self handleDealSearchbyText:searchString];
    
    return YES;
}

- (void) handleDealSearchbyText:(NSString *)SearchText
{
    NSLog(@"inside SearchController.handleDealSearchText");
    dealsManager=[DealsServiceManager sharedManager];
    self.deals = [dealsManager retrieveSearchDeals:SearchText];    
    
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"inside SearchController.searchBarSearchButtonClicked");
    [self handleDealSearchbyText:[searchBar text]];
}


@end
