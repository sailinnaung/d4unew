//
//  DetailViewController.h
//  DummyMasterView
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhatsAroundYouMasterController.h"

@class Deal;

@interface WhatsAroundYouDetailController : UIViewController

@property (strong, nonatomic) Deal* dealItem;
@property (strong, nonatomic) WhatsAroundYouMasterController* masterController;

//@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
