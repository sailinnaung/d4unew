//
//  DetailViewController.h
//  DummyMasterView
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhatsAroundYouMasterController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/AddressBook.h>

@class Deal;

@interface DetailController : UIViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,MFMessageComposeViewControllerDelegate>{
    
    //UILabel * dealId;
    UILabel *dealTitle;
    UILabel *dealCategory;
    UITextView *dealDescr;
    UILabel *dealLocation;
    UILabel *dealMerchantName;
    UIImageView *dealImage;
    
    UIButton *likeButton;
    
    NSMutableArray *phoneNumbers;
    
    //CLGeocoder *geoCoder;
    //CLLocationManager *locationManager;
    
}

//@property (strong, nonatomic) IBOutlet UILabel* dealId;
@property (strong, nonatomic) IBOutlet UILabel* dealTitle;
@property (strong, nonatomic) IBOutlet UILabel* dealCategory;
@property (strong, nonatomic) IBOutlet UITextView* dealDescr;
@property (strong, nonatomic) IBOutlet UILabel* dealLocation;
@property (strong, nonatomic) IBOutlet UILabel* dealMerchantName;
@property (strong, nonatomic) IBOutlet UIImageView* dealImage;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) NSMutableArray* phoneNumbers;

@property (strong, nonatomic) Deal* dealItem;
@property (strong, nonatomic) WhatsAroundYouMasterController* masterController;
-(IBAction)likeDeal:(id)sender;
-(IBAction)showActionSheet:(id)sender;

-(void) performLiked;
-(void) setLikeButtonDisabled;
-(void) sendInAppSMS;

//@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
