//
//  PostDealController.h
//  Deals4U
//
//  Created by Vincent Choo on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "DBManager.h"

@interface PostDealController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate,MKReverseGeocoderDelegate, MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate>{
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtMerchant;
    IBOutlet UITextField *txtCategory;
    IBOutlet UITextField *txtDescription;
    IBOutlet UITextField *txtLocationLat;
    IBOutlet UITextField *txtLocationLong;
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    IBOutlet UITextField *txtRemarks;
    IBOutlet UISwitch *switchIsFeatured;
    IBOutlet CLLocationManager *locationManager;
    
    NSMutableArray *arrayCategory;
    UIDatePicker *pick;
    
    DBManager* dbManager;
    UIActionSheet *actPickerSheet;

    NSString *dateFormat;
    
    // Start added by Chen Lim for image upload
    NSData *imageData; 
    NSMutableString *sResponse;
    IBOutlet UIActivityIndicatorView *spinningWheel;
    // End added by Chen Lim for image upload

}


- (IBAction)startDateEditDidBegin:(id)sender;
- (IBAction)endDateEditDidBegin:(id)sender;
- (IBAction)switchDidBegin:(id)sender;

- (IBAction) addDeal;
- (IBAction) emailDeal;
- (IBAction) smsDeal;
- (IBAction) getLocation;

- (IBAction) presentCategoryPickerActionSheet;

// Sart added by Chen Lim for image upload
- (IBAction) imgSel;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSMutableString *sResponse;
@property (nonatomic, retain) UIActivityIndicatorView *spinningWheel;
// End added by Chen Lim for image upload

@end
