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
#import "MBProgressHUD.h"


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
    
    if(deals.count<1){
        NSLog(@"Deal count is %d",deals.count);
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
        
        UIImage *scaledImage=nil;
        
        if (imageUrl.length ==0){
            
            UIImage* tempImage=[UIImage imageNamed:@"noImage.jpg"];
            //self.dealImage.image=tempImage;
            scaledImage=[self scale:tempImage];
            
        }
        else{
            
            url = [NSURL URLWithString:imageUrl];
            data = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:data];
            scaledImage=[self scale:image];
        }
        

         [self borderAndSmoothImageView:cell.imageView];
        
        NSLog(@"ImageUrl after %@",imageUrl);
        
       
        
        cell.textLabel.text = dealObj.dealTitle;
        cell.detailTextLabel.text=[NSString stringWithString:dealObj.description];
        cell.imageView.image=scaledImage;
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
    [self.resultTableView reloadData];
    return YES;
}

- (void) handleDealSearchbyText:(NSString *)SearchText
{
    NSLog(@"inside SearchController.handleDealSearchText");
    
    dealsManager=[DealsServiceManager sharedManager];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Please wait... Refreshing data";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        self.deals = [dealsManager retrieveSearchDeals:SearchText];    
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    [self.resultTableView reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"inside SearchController.searchBarSearchButtonClicked");
    [self handleDealSearchbyText:[searchBar text]];
    [self.resultTableView reloadData];    
    [searchBar resignFirstResponder];
    [searchBarObj setShowsCancelButton:FALSE animated:NO];
    
    [searchBarObj setText:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"inside SearchController.searchBarCancelButtonClicked");
    [self.resultTableView reloadData];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:FALSE animated:NO];
    [searchBar setText:nil];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    NSLog(@"inside SearchController.didLoadSearchResultTableView");
    [self.resultTableView reloadData];
    [searchBarObj resignFirstResponder];
    [searchBarObj setShowsCancelButton:FALSE animated:NO];
    [searchBarObj setText:nil];
}

-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    NSLog(@"inside SearchController.searchDisplayControllerDidBeginSearch");
    [self.resultTableView reloadData];
    [searchBarObj resignFirstResponder];
    [searchBarObj setShowsCancelButton:FALSE animated:NO];
    [searchBarObj setText:nil];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.resultTableView reloadData];
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


- (UIImage *)scale:(UIImage *)image
{
    CGSize size = (CGSize){.width = 75.0f, .height = 75.0f};
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}



-(void) borderAndSmoothImageView:(UIImageView*) tempImageView{
    
    [tempImageView setBounds:CGRectMake(0, 0, 50, 50)];
    [tempImageView setClipsToBounds:NO];
    [tempImageView setFrame:CGRectMake(0, 0, 50, 50)];
    [tempImageView setContentMode:UIViewContentModeScaleAspectFit];
    tempImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tempImageView.layer.borderWidth = 1.0;
    tempImageView.layer.cornerRadius = 5.0;
    tempImageView.layer.masksToBounds = YES;
    
}

@end
