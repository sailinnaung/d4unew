//
//  LikedController.h
//  D4UUU
//
//  Created by Arun Manivannan on 9/5/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@class DetailController;

@interface LikedController : UITableViewController <UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    
    NSMutableArray* deals;
    UITableView *dealsTableView;
}

@property (strong, nonatomic) DetailController *detailViewController;
@property (strong, nonatomic) NSMutableArray* deals;
@property (strong, nonatomic) IBOutlet UITableView* dealsTableView;

-(void) updateCategory;
-(void) borderAndSmoothImageView:(UIImageView*) tempImageView;
- (UIImage *)scale:(UIImage *)image;
-(void) updateData;

@end
