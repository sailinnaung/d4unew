//
//  SearchController.m
//  Deals4U
//
//  Created by Sai Lin Naung on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "SearchController.h"
#import "DealsServiceManager.h"
#import "Constants.h"
#import "Deal.h"
#import "DetailController.h"


@implementation SearchController

@synthesize searchBarObj, searchDisplayController, deals,resultTableView, detailViewController;


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
    [searchBarObj resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"inside SearchController.numberOfRowsInSection method");
    NSInteger rows;
    
    if(self.deals.count>0){        
        rows = [[self deals] count];
        NSLog(@"rows is %d",rows);
    }        
    else{
        rows = 1;
    }
        
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
        NSLog(@"cell is nill");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;        
        
    }
    
    if(self.deals == nil){
        NSLog(@"Deal is nill");
        cell.textLabel.text = DEFAULT_SEARCH_RESULT_STRING;
        NSLog(@"cell text label is %@",cell.textLabel.text);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"cell selection style: %@",cell.selectionStyle);
        cell.accessoryType = UITableViewCellAccessoryNone;
        

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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
        [searchBarObj setText:nil];
    }
            
    return cell;    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.deals.count>0){
        [searchBarObj resignFirstResponder];
        [searchBarObj setShowsCancelButton:FALSE animated:NO];
        NSLog(@"inside SearchController.didSelectRowAtIndexPath at %@",indexPath);
                
        [self performSegueWithIdentifier:@"SearchDetailIdentifer" sender:self]; 
        NSLog(@"Segue performed");
        
        
    }else{
         NSLog(@"inside SearchController.didSelectRowAtIndexPath No Deals");
    }   
    
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
        
    [searchBar resignFirstResponder];
    [searchBarObj setShowsCancelButton:FALSE animated:NO];
    [self.resultTableView reloadData];
    [searchBarObj setText:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"inside SearchController.searchBarCancelButtonClicked");
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:FALSE animated:NO];
    [searchBar setText:nil];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    NSLog(@"inside SearchController.didLoadSearchResultTableView");
    [searchBarObj resignFirstResponder];
    [searchBarObj setShowsCancelButton:FALSE animated:NO];
    [searchBarObj setText:nil];
}

-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    NSLog(@"inside SearchController.searchDisplayControllerDidBeginSearch");
    [searchBarObj resignFirstResponder];
    [searchBarObj setShowsCancelButton:FALSE animated:NO];
    [searchBarObj setText:nil];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    [searchBar setShowsCancelButton:TRUE animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Invoking prepare for segue");
    if([[segue identifier] isEqualToString:@"SearchDetailIdentifer"]){
        
        NSLog(@"String from class %@", NSStringFromClass([[segue destinationViewController] class]));
        
        DetailController *passDeal = (DetailController *)[segue destinationViewController];
        
        Deal* object = [deals objectAtIndex:self.resultTableView.indexPathForSelectedRow.row];
        NSLog(@"Deal object %@", object.description);
        passDeal.dealItem = object;
        
        //[self.navigationController pushViewController:passDeal animated:YES];
            
        NSLog(@"Done setting deal item");
    }
}

@end
