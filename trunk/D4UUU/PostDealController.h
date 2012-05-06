//
//  PostDealController.h
//  Deals4U
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <CoreLocation/CoreLocation.h>

@interface PostDealController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtMerchant;
    IBOutlet UITextField *txtCategory;
    IBOutlet UITextField *txtDescription;
    IBOutlet UITextField *txtLocation;
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    IBOutlet UITextField *txtRemarks;
    IBOutlet UIPickerView *pvCategory;
    IBOutlet UISwitch *switchIsFeatured;
    IBOutlet CLLocationManager *locationManager;
    
    NSMutableArray *arrayCategory;
    UIDatePicker *pick;

}


- (IBAction)startDateEditDidBegin:(id)sender;
- (IBAction)endDateEditDidBegin:(id)sender;
- (IBAction)switchDidBegin:(id)sender;

- (IBAction) addDeal;
- (IBAction) emailDeal;
- (IBAction) smsDeal;
- (IBAction) getLocation;


@end
