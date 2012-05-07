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
        NSLog(@"Incoming deal in Detail controller is %@", dealItem.dealTitle);
        
   
        //self.dealId.text=dealItem.dealId;
        self.dealTitle.text=dealItem.dealTitle;
        self.dealCategory.text=dealItem.category;
        //self.description.text=dealItem.description;
        //self.dealId=dealItem.; //TODO location
        self.dealMerchantName.text=dealItem.merchantName;
        
        NSURL *url = [NSURL URLWithString:dealItem.imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *tempImage = [UIImage imageWithData:data];
        
        self.dealImage.image=tempImage;
        
        
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


// Chen Lim to post into local DB and post to server for a liked deal
-(void) performLiked
{
    DBManager *dbManager = [DBManager sharedDBManager];
    if ([dbManager openDB] == true) 
    {
        NSString *sSql = [NSString stringWithFormat:@"INSERT INTO Liked (liked_prmo_id) VALUES ('%@')", @"prmo20120000069"]; // HARDCODED prmo20120000069 here. TODO: Change to refer to current dealId
        BOOL bSuccess = [dbManager executeSql:sSql];
        if (bSuccess == true) 
        {
            // post to server to +1 like
            NSString *post = @"action=liked&prmo_id=prmo20120000069";
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
@end
