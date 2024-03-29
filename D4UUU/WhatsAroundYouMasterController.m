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
	    self.navigationItem.title =@"Around you";
    self.navigationItem.hidesBackButton = FALSE;
  
     
    [self updateLocationAndCategory];
        
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
      
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    Deal *deal = [deals objectAtIndex:indexPath.row];
   
    
    NSMutableString* imageUrl=[NSMutableString stringWithString:deal.imageUrl];
    UIImage *scaledImage=nil;
    
    if (imageUrl.length ==0){
        
        UIImage* tempImage=[UIImage imageNamed:@"noImage.jpg"];
        //self.dealImage.image=tempImage;
        scaledImage=[self scale:tempImage];
        
    }
    else{
        
        
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        scaledImage=[self scale:image];
    }
    cell.textLabel.text = deal.dealTitle;
    //Should ideally be merchant name
    NSString* subtitle=[NSString stringWithString:deal.description];
    cell.detailTextLabel.text=subtitle;
    
    
    [self borderAndSmoothImageView:cell.imageView];
    
   
    
      
   
    cell.imageView.image=scaledImage;
    NSLog(@"Cell image %@",cell.imageView.image.description );
    
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      
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




-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.deals.count>0){
        NSLog(@"inside WhatsAroundController.didSelectRowAtIndexPath at %@",indexPath);
        
        [self performSegueWithIdentifier:@"WhatsAroundDetailIdentifer" sender:self]; 
        NSLog(@"Segue performed");
        
        
    }else{
        NSLog(@"inside WhatsAroundController.didSelectRowAtIndexPath No Deals");
    }   
    
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
  
    [locationManager stopUpdatingLocation];
       
    NSString *latitude=[NSString stringWithFormat:@"%+.6f", newLocation.coordinate.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%+.6f", newLocation.coordinate.longitude];
    
   
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
    if([[segue identifier] isEqualToString:@"WhatsAroundDetailIdentifer"]){
        
        NSLog(@"String from class %@", NSStringFromClass([[segue destinationViewController] class]));
        
        DetailController *passDeal = (DetailController *)[segue destinationViewController];
        
        Deal* object = [deals objectAtIndex:self.dealsTableView.indexPathForSelectedRow.row];
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
