//
//  MasterViewController.m
//  DummyMasterView
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "WhatsAroundYouMasterController.h"

#import "DetailController.h"
#import "DealsServiceManager.h"
#import "Deal.h"
#import "MBProgressHUD.h"



@implementation WhatsAroundYouMasterController 

@synthesize deals;
@synthesize dealsTableView;
DealsServiceManager *dealsManager=nil;


@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Around you", @"Around you");
        self.tabBarItem.image = [UIImage imageNamed:@"whatsaroundyou"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.navigationItem.title =@"Around you";
    self.navigationItem.hidesBackButton = FALSE;
    
    /*UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
     NSLog(@"View did load called  in Whats around you controller");
    */
     
    [self updateLocationAndCategory];

    //self.deals=[NSMutableArray arrayWithArray:[dealsManager retrieveWhatsAroundWithLatitude:@"1.37" andLongitude:@"103.862454"]];

        
    NSLog(@"Last deal object is %@", self.deals.lastObject);
    
}

-(void) updateLocationAndCategory{
   
        
        
        dealsManager=[DealsServiceManager sharedManager];
        locationManager=[[CLLocationManager alloc] init];
        
        locationManager.delegate=self;
        [locationManager startUpdatingLocation];
       
    
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/*
- (void)insertNewObject:(id)sender
{
    if (!deals) {
        deals = [[NSMutableArray alloc] init];
    }
    self.deals=[NSMutableArray arrayWithArray:[dealsManager retrieveWhatsAroundWithLatitude:@"1.37" andLongitude:@"103.862454"]];
    //[deals insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deals.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    Deal *deal = [deals objectAtIndex:indexPath.row];
    cell.textLabel.text = [deal description];
    return cell;*/
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    Deal *deal = [deals objectAtIndex:indexPath.row];
   
    
    //deal.imageUrl=@"http://3.bp.blogspot.com/_R3XmXQJls5Y/Sd5ubFKOofI/AAAAAAAAABw/7GtS_AUgwSo/s400/4845_M_W_300.png";
    NSMutableString* imageUrl=[NSMutableString stringWithString:deal.imageUrl];
    // NSLog(@"ImageUrl Before %@",imageUrl);
   // [imageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    NSLog(@"ImageUrl after %@",imageUrl);
    
    /*
    UIImageView *imageView=[[UIImageView alloc]init ];
    [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:deal.imageUrl]] placeholderImage:[UIImage imageNamed:@"whatsaroundyou.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        NSLog(@"Success");
        cell.imageView.image=image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed with the error %@",error);
    }];
     */
    
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    //cell.imageView.image= [imageView image];
    cell.textLabel.text = deal.dealTitle;
    //Should ideally be merchant name
    NSString* subtitle=[NSString stringWithString:deal.description];
    cell.detailTextLabel.text=subtitle;
    
    [cell.imageView setBounds:CGRectMake(0, 0, 50, 50)];
    [cell.imageView setClipsToBounds:NO];
    [cell.imageView setFrame:CGRectMake(0, 0, 50, 50)];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];

    cell.imageView.image=image;
    NSLog(@"Cell image %@",cell.imageView.image.description );
    
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    /*
    
    UIColor *bgColor = [UIColor greenColor];
    cell.textLabel.backgroundColor = bgColor;
    
    cell.detailTextLabel.backgroundColor = bgColor;
    
   
    
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.backgroundColor = bgColor;
    */
    //cell.imageView.image = [UIImage imageNamed:@"whatsaroundyou.png"];
    
    return cell;
     
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [deals removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    NSLog(@"inside WhatsAroundMasterController.didSelectRowAtIndexPath at %@",indexPath);
    
    [self performSegueWithIdentifier:@"WhatsAroundDetailSegue" sender:self]; 
    NSLog(@"Segue performed");
    
   
    //NSArray *array=[NSArray arrayWithObject:deals];
    
   /* NSLog(@"Detail view controller %@",self.detailViewController.description);
    Deal* object = [deals objectAtIndex:indexPath.row];
     NSLog(@"Deal object %@", object.description);
    self.detailViewController.dealItem = object;
     NSLog(@"Deal object %@", self.detailViewController.dealItem.description);
    NSLog(@"Did select row at index path %d", indexPath.row);
    //[self.navigationController pushViewController:self.detailViewController animated:YES];
    //UINavigationController *navigationController=[[self.tabBarController.viewControllers objectAtIndex:0];
    //UITableView *tableView=self.tableView;
    //[navigationController pushViewController:self.detailViewController animated:YES];
    
    self.detailViewController.masterController = self; 

   // [self.view insertSubview:self.detailViewController.view belowSubview:self.view];
   */
    /*if (currentViewController != nil)
        [currentViewController.view removeFromSuperview];
    currentViewController = tab2ViewController; */
    
    //[self.view addSubview:self.detailViewController.view];
       
   // [self.navigationController pushViewController:self.detailViewController animated:YES];
    
    //[self.navigationController.tabBarController setSelectedViewController:self.detailViewController];
   // [self.navigationController presentModalViewController:self.detailViewController animated:YES];
    
    
        
}

-(void) loadView{
    
    [super loadView];
    [self.tableView setRowHeight:81];
}

-(void)updateLocationWithLatitude :(NSString*) latitude andLongitude:(NSString*) longitude{
    
    NSLog(@"Updatttting with Locationg..... %@%@", latitude, longitude);
    [self.deals removeAllObjects];
    self.deals=[NSMutableArray arrayWithArray:[dealsManager retrieveWhatsAroundWithLatitude:latitude andLongitude:longitude]];
    //self.deals=[NSMutableArray arrayWithArray:[dealsManager retrieveWhatsAroundWithLatitude:@"1.37" andLongitude:@"103.862454"]];
 
    NSLog(@"Deals %@",self.deals.description);
    
    [self.tableView reloadData];
        
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    
    NSLog(@"New location%@",newLocation);
   
    
    noUpdates++;
    
    /*if (noUpdates>=50){
        [locationManager stopUpdatingLocation];
    }*/
    
    [locationManager stopUpdatingLocation];
    //[[NSString stringWithFormat:@"%+.6f,%+.6f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude] isEqualToString:@"+0.000000,+0.000000"])
    
    
    
    NSString *latitude=[NSString stringWithFormat:@"%+.6f", newLocation.coordinate.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%+.6f", newLocation.coordinate.longitude];
    
    //(void)showWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType;

    
    //[SVProgressHUD showWithStatus:@"Please wait... Refreshing data" maskType:SVProgressHUDMaskTypeBlack];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Please wait... Refreshing data";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        [self updateLocationWithLatitude:latitude andLongitude:longitude];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    
   

    
    //[SVProgressHUD dismissWithSuccess:@"Cool. Refresh done."];
    
    
    
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Could not locate location %@", error);
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Invoking prepare for segue");
    if([[segue identifier] isEqualToString:@"WhatsAroundDetailSegue"]){
        
        NSLog(@"String from class %@", NSStringFromClass([[segue destinationViewController] class]));
        
        DetailController *passDeal = (DetailController *)[segue destinationViewController];
        
        Deal* object = [deals objectAtIndex:self.dealsTableView.indexPathForSelectedRow.row];
        NSLog(@"Deal object url %@", object.imageUrl);
        passDeal.dealItem = object;
        
        //[self.navigationController pushViewController:passDeal animated:YES];
        
        NSLog(@"Done setting deal item");
    }
}


@end
