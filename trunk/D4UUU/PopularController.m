//
//  SecondViewController.m
//  Deals4U
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "PopularController.h"

@implementation PopularController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Popular", @"Popular");
        self.tabBarItem.image = [UIImage imageNamed:@"popular"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

@end
