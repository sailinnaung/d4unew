//
//  AppDelegate.h
//  D4UUU
//
//  Created by Arun Manivannan on 5/5/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

- (void) loadAvailableFromDatabase;
- (void) loadSelectedFromDatabase;
@property (strong, nonatomic) UIWindow *window;

@end
