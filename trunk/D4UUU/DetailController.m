//
//  DetailViewController.m
//  DummyMasterView
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "DetailController.h"
#import "Deal.h"
#import "DBManager.h"
#import "Constants.h"

@interface DetailController ()
- (void)configureView;
@end

@implementation DetailController

@synthesize dealTitle, dealCategory, dealDescr, dealLocation, dealMerchantName, dealImage;
@synthesize dealItem;
@synthesize masterController;
//@synthesize detailDescriptionLabel = _detailDescriptionLabel;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDealItem
{
    if (dealItem != newDealItem) {
        dealItem = newDealItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    NSLog(@"Incoming deal in Detail controller item %@",dealItem.description);
    if (self.dealItem) {
        //self.detailDescriptionLabel.text = [self.detailItem description];
        NSLog(@"Incoming deal image url in Detail controller is %@", dealItem.imageUrl);
        NSLog(@"Incoming deal latitude in Detail controller is %@", dealItem.latitude);
        self.dealTitle.text=dealItem.dealTitle;
        self.dealCategory.text=dealItem.category;
        self.dealDescr.text=dealItem.description;
        //self.dealId=dealItem.; //TODO location
        self.dealMerchantName.text=dealItem.merchantName;
        
        if (dealItem.imageUrl.length ==0){
            
            UIImage* tempImage=[UIImage imageNamed:@"noImage.jpg"];
            self.dealImage.image=tempImage;

            
        }
        else{
            
            NSURL *url = [NSURL URLWithString:dealItem.imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *tempImage = [UIImage imageWithData:data];
            self.dealImage.image=tempImage;
        }
        
            
       
        
        
        
            
           /* CLLocation *location=[[CLLocation alloc]init];
            CLLocationCoordinate2D *location2d=[CLloca*/
        /*CLLocation *location=[locationManager location];
            
        CLLocationCoordinate2D location2d=location.coordinate;
            
        location2d.latitude=[dealItem.latitude floatValue];
        location2d.longitude=[dealItem.latitude floatValue];
            
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *firsPlaceMark=[placemarks objectAtIndex:0];
            NSString* currentLocation = [firsPlaceMark.locality stringByAppendingFormat:@", "];
            currentLocation = [currentLocation stringByAppendingString:firsPlaceMark.country];
                
            self.dealLocation.text=currentLocation;
                
            }];
        */
        
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"View did load dettaaaaaaailllllll");
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    self.navigationItem.title =@"Detail";
    self.navigationController.navigationBar.backItem.title = @"Custom text";
    
    //geoCoder=[[CLGeocoder alloc] init];
    
    
    //[self performLiked];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    //self.detailDescriptionLabel = nil;
    self.dealItem=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}


-(IBAction)likeDeal:(id)sender{
    
    [self performLiked];
    //NSLog(@"Yahooo. I liked the deal with ID %@", self.dealItem.dealId);
}

// Chen Lim to post into local DB and post to server for a liked deal
-(void) performLiked
{
    DBManager *dbManager = [DBManager sharedDBManager];
    if ([dbManager openDB] == true) 
    {
        NSString *sSql = [NSString stringWithFormat:@"INSERT INTO Liked (liked_prmo_id) VALUES ('%@')", self.dealItem.dealId]; // HARDCODED prmo20120000069 here. TODO: Change to refer to current dealId
        BOOL bSuccess = [dbManager executeSql:sSql];
        if (bSuccess == true) 
        {
            // post to server to +1 like
            NSString *post = @"action=liked&prmo_id=";
            post = [post stringByAppendingString:self.dealItem.dealId];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:SERVER_LIKE_URL]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            // sends to the server!
            [[NSURLConnection alloc] initWithRequest:request delegate:nil];
        }
        else 
        {
            // alert user failed to update db?
        }
	}
}


- (IBAction)showActionSheet:(id)sender {
	// Create the sheet without buttons
	UIActionSheet *sheet = [[UIActionSheet alloc] 
                            initWithTitle:@"Share your favourite deal"
                            delegate:self
                            cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    
    [sheet addButtonWithTitle:@"Tweet the awesome deal"];
	[sheet addButtonWithTitle:@"Email to your friends"];
	[sheet addButtonWithTitle:@"SMS that special someone"];
    //[sheet addButtonWithTitle:@"Post to facebook"];
    
	//[sheet addButtonWithTitle:@"Cancel"];
    
    /*
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Chuck it"] ];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    
    [sheet addSubview:closeButton];
     */
	//sheet.cancelButtonIndex = sheet.numberOfButtons-1;
    //[sheet dismissWithClickedButtonIndex:3 animated:YES];
    
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
	//[sheet showFromRect:self.view.bounds inView:self.view animated:YES];
	
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	//if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
	switch (buttonIndex) {
		case 1:
		{
			NSLog(@"Item 1 Selected");
			break;
		}
		case 2:
		{
			NSLog(@"Item Email Selected");
           
                MFMailComposeViewController *emailViewController = [[MFMailComposeViewController alloc] init] ;
                emailViewController. mailComposeDelegate = self;
                
                [emailViewController setSubject: @"Great Deal"] ;
                //  NSString *msg = @"Don't Miss It!\n";
                // *msg = msg + @"aaa";
                NSString *msg = [NSString stringWithFormat:@"Great Deal!\n\nTitle: %@ \nMerchant: %@ \nCategory: %@ \nDescription: %@ ", 
                                 dealItem.dealTitle, 
                                 dealItem.merchantName, 
                                 dealItem.category, 
                                  dealItem.description
                                  ];
                [emailViewController setMessageBody: msg isHTML: NO] ;    
                [self presentModalViewController: emailViewController animated: YES] ;    	

			break;
		}
		case 3:
		{
			NSLog(@"Item 3 Selected");
			break;
		}
        case 4:
		{
			NSLog(@"Item 4 Selected");
			break;
		}
	}
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    NSLog(@"Mail sent");
}


@end
