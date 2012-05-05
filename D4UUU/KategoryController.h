//
//  KategoryController.h
//  D4UUU
//
//  Created by Arun Manivannan on 5/5/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KategoryController : UITableViewController{

NSMutableArray *arrAvailable;
NSMutableArray *arrSelected;
    UITableView *uiTableView;

}

@property (strong, nonatomic) NSMutableArray *arrAvailable;
@property (strong, nonatomic) NSMutableArray *arrSelected;
@property (strong, nonatomic)IBOutlet UITableView *uiTableView;

@end
