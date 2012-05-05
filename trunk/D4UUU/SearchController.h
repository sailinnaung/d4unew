//
//  SearchController.h
//  Deals4U
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DealsServiceManager;

@interface SearchController : UITableViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchDisplayController *searchDisplayController;
    UISearchBar *searchBarObj;
    UITableView *resultTableView;
    
    NSMutableArray *deals;
    DealsServiceManager *dealsManager;
}

@property (nonatomic, strong) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBarObj;
@property (nonatomic, strong) IBOutlet UITableView *resultTableView;
@property (nonatomic, strong) NSMutableArray *deals;

-(void)handleDealSearchbyText:(NSString *) SearchText;

@end
