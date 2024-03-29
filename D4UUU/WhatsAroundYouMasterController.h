//
//  MasterViewController.h
//  DummyMasterView
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@class DetailController;

@interface WhatsAroundYouMasterController : UITableViewController <UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    
    NSMutableArray* deals;
    CLLocationManager *locationManager;
    UITableView *dealsTableView;
    NSUInteger noUpdates;

}

@property (strong, nonatomic) DetailController *detailViewController;
@property (strong, nonatomic) NSMutableArray* deals;
@property (strong, nonatomic) IBOutlet UITableView* dealsTableView;

-(void) updateLocationAndCategory;
-(void) borderAndSmoothImageView:(UIImageView*) tempImageView;
- (UIImage *)scale:(UIImage *)image;
    
@end
