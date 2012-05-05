//
//  DetailViewController.m
//  DummyMasterView
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "WhatsAroundYouDetailController.h"
#import "Deal.h"

@interface WhatsAroundYouDetailController ()
- (void)configureView;
@end

@implementation WhatsAroundYouDetailController

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
    NSLog(@"Incoming deal item %@",dealItem.description);
    if (self.dealItem) {
        //self.detailDescriptionLabel.text = [self.detailItem description];
        NSLog(@"Incoming deal is %@", dealItem.dealTitle);
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
							
@end
