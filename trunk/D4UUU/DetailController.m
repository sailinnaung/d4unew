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
#import <Twitter/Twitter.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>

@interface DetailController ()
- (void)configureView;
-(void) checkIfLiked;
@end

@implementation DetailController

@synthesize dealTitle, dealCategory, dealDescr, dealLocation, dealMerchantName, dealImage;
@synthesize dealItem;
@synthesize masterController;
@synthesize likeButton;
@synthesize phoneNumbers;

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
    
    self.navigationItem.title =self.dealItem.dealTitle;
    
    [self checkIfLiked];
    
    //geoCoder=[[CLGeocoder alloc] init];
    
    
    //[self performLiked];
    
    phoneNumbers = [[NSMutableArray alloc] init];
    
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
    
    NSLog(@"Like is called now");
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
        
        NSLog(@"Like performed");
        [self setLikeButtonDisabled];
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
			
            
            // Create the view controller
            TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
            
            
            NSURL *url = [NSURL URLWithString:dealItem.imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *tempImage = [UIImage imageWithData:data];
            
            
            [twitter addImage:tempImage];
            
           
            NSString *tweetText=[[[[NSString alloc] initWithString:dealItem.dealTitle] stringByAppendingString:@"-"] stringByAppendingString:dealItem.debugDescription];
            [twitter setInitialText:tweetText];
            
            // Show the controller
            [self presentModalViewController:twitter animated:YES];
            
            // Called when the tweet dialog has been closed
            twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
            {
                NSString *title = @"Tweet Status";
                NSString *msg; 
                
                if (result == TWTweetComposeViewControllerResultCancelled)
                    msg = @"Tweet compostion was canceled.";
                else if (result == TWTweetComposeViewControllerResultDone)
                    msg = @"Tweet composition completed.";
                
                // Show alert to see how things went...
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alertView show];
                
                // Dismiss the controller
                [self dismissModalViewControllerAnimated:YES];
            };
            
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
                
                //[sheet showInView:[UIApplication sharedApplication].keyWindow];

			break;
		}
		case 3:
		{
			NSLog(@"SMS people picker Selected");
            
            ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
            picker.peoplePickerDelegate = self;
            // Display only a person's phone, email, and birthdate
            NSArray *displayedItems = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
            picker.peoplePickerDelegate = self;
            
            picker.displayedProperties = displayedItems;
            // Show the picker 
            [self presentModalViewController:picker animated:YES];
            
            [self sendInAppSMS];
            
			break;
		}
       
	}
}

-(void) sendInAppSMS
{
    NSLog(@"inside sendInAppSMS");
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = [[NSString alloc] initWithFormat:@"Please check this deal\n %@\n %@\n %@",dealItem.dealTitle,dealItem.description, dealItem.dealId];
		controller.recipients = [NSArray arrayWithObjects:phoneNumbers, nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSLog(@"inside didFinishWithResult");
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    NSLog(@"inside peoplePickerNavigationController. shouldContinueAfterSelectingPerson");  
    
    return YES;    
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSLog(@"inside peoplePickerNavigationController. shouldContinueAfterSelectingPerson2");
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, property);
    CFStringRef phone = ABMultiValueCopyValueAtIndex(multi, identifier);
    NSString* phoneStr = (__bridge NSString *)phone;
    NSLog(@"phone %@", phoneStr);
//    CFRelease(phone);
    
    [phoneNumbers addObject:phoneStr];
    
    NSLog(@"phoneNumbers count: %d",phoneNumbers.count);
//    ABPeoplePickerNavigationController *peoplePicker = (ABPeoplePickerNavigationController *)personViewController.navigationController;
//    [peoplePicker dismissModalViewControllerAnimated:YES];
    [peoplePicker dismissModalViewControllerAnimated:YES];
    return NO;
    
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    NSLog(@"Dismiss the contacts UI.");
    [self dismissModalViewControllerAnimated:YES];
}


-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissModalViewControllerAnimated:YES];
   
}

-(void) checkIfLiked{
    
    if (dealItem.isLiked){
        
        [self setLikeButtonDisabled];
        
    }
    
}

-(void) setLikeButtonDisabled{
    
    UIImage *btnImage = [UIImage imageNamed:@"like.png"];
    [likeButton setImage:btnImage forState:UIControlStateNormal];
    [likeButton setEnabled:NO];
}


@end
