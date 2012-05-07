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

@interface DetailController : UIViewController{
    
    IBOutlet UILabel * dealId;
    UILabel *dealTitle;
    UILabel *category;
    UITextView *description;
    UILabel *location;
    UILabel *merchantName;
    UIImageView *imageUrl;
}

@property (strong, nonatomic) IBOutlet UILabel* dealId;
@property (strong, nonatomic) IBOutlet UILabel* dealTitle;
@property (strong, nonatomic) IBOutlet UILabel* category;
@property (strong, nonatomic) IBOutlet UITextView* description;
@property (strong, nonatomic) IBOutlet UILabel* location;
@property (strong, nonatomic) IBOutlet UILabel* merchantName;
@property (weak, nonatomic) IBOutlet UIImageView* image;

@property (strong, nonatomic) Deal* dealItem;
@property (strong, nonatomic) WhatsAroundYouMasterController* masterController;

//@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
