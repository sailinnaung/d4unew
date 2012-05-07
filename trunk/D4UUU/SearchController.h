//
//  SearchController.h
//  Deals4U
//
//  Created by Sai Lin Naung on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailController;
@class DealsServiceManager;

@interface SearchController : UITableViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchDisplayController *searchDisplayController;
    UISearchBar *searchBarObj;
    UITableView *resultTableView;
    
    NSMutableArray *deals;
    DealsServiceManager *dealsManager;
    DetailController *detailController;
}

@property (nonatomic, strong) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBarObj;
@property (nonatomic, strong) IBOutlet UITableView *resultTableView;
@property (nonatomic, strong) NSMutableArray *deals;
@property (strong, nonatomic) DetailController *detailViewController;

-(void)handleDealSearchbyText:(NSString *) SearchText;

@end
