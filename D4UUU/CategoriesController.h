//
//  ViewController.h
//  CountryListAgain
//
//  Created by Jakob Chong on 22/4/12.
//  Copyright (c) 2012 L&Rui Concept Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arrAvailable;
    NSMutableArray *arrSelected;
    UITableView *tblCountries;
}

@property (strong, nonatomic) NSMutableArray *arrAvailable;
@property (strong, nonatomic) NSMutableArray *arrSelected;
@property (nonatomic, retain) IBOutlet UITableView *tblCountries;

@end
