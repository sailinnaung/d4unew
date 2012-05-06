//
//  KategoryController.h
//  D4UUU
//
//  Created by Toh Chen Lim on 5/5/12.
//  Copyright (c) 2012 chenlim@ambracetech.com All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KategoryController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *uiTableView;
}

-(void)preselect;

@property (nonatomic, retain) IBOutlet UITableView *uiTableView;

@end
