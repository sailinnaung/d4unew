//
//  LikedController.m
//  D4UUU
//
//  Created by Arun Manivannan on 9/5/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "LikedController.h"

//
//  MasterViewController.m
//  DummyMasterView
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "DetailController.h"
#import "DealsServiceManager.h"
#import "Deal.h"
#import "MBProgressHUD.h"


@implementation LikedController 

@synthesize deals;
@synthesize dealsTableView;
DealsServiceManager *likedDealsManager=nil;


@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Top Liked", @"Top Liked");
        self.tabBarItem.image = [UIImage imageNamed:@"aroundyou"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title =@"Top Liked";
    self.navigationItem.hidesBackButton = FALSE;
       
    [self updateCategory];
    
       
    NSLog(@"Last deal object is %@", self.deals.lastObject);
    
}

-(void) updateCategory{
    
    
    
    likedDealsManager=[DealsServiceManager sharedManager];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.labelText = @"Working";
    
           
    //MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Please wait... Refreshing data";
    
    [self updateData];  
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    /*
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        
        [self updateData];        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });*/
   
    
}


-(void) updateData{
    NSLog(@"Updatttting with Categories..... ");
    [self.deals removeAllObjects];
    
    self.deals=[NSMutableArray arrayWithArray:[likedDealsManager retrieveAllLiked]];
    
    NSLog(@"Deals %@",self.deals.description);
    
    [self.tableView reloadData];

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
   
    
    NSLog(@"ImageUrl after %@",imageUrl);
    
       
    UIImage *scaledImage=nil;
    
    if (imageUrl.length ==0){
        
        UIImage* tempImage=[UIImage imageNamed:@"noImage.jpg"];
        scaledImage=[self scale:tempImage];
        
    }
    else{
        
        
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        scaledImage=[self scale:image];
    }
    
    
    
    
    
    
    //cell.imageView.image= [imageView image];
    cell.textLabel.text = deal.dealTitle;
    //Should ideally be merchant name
    NSString* subtitle=[NSString stringWithString:deal.description];
    cell.detailTextLabel.text=subtitle;
    
    
    [self borderAndSmoothImageView:cell.imageView];
    
    
    
    
    
    cell.imageView.image=scaledImage;
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




-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.deals.count>0){
        [self performSegueWithIdentifier:@"LikedDetailIdentifer" sender:self];
        
        
    }else{
        NSLog(@"inside LikedController.didSelectRowAtIndexPath No Deals");
    }   
    
}


-(void) loadView{
    
    [super loadView];
    [self.tableView setRowHeight:81];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Invoking prepare for segue");
    if([[segue identifier] isEqualToString:@"LikedDetailIdentifer"]){
        
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
