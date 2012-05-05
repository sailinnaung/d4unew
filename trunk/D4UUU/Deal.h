//
//  Deal.h
//  Deals4U
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deal : NSObject{

    NSString * dealId;
    NSString *dealTitle;
    NSString *category;
    NSString *description;
    NSString *latitude;
    NSString *longitude;
    NSString *merchantName;
    NSData *imageData;
    NSString *imageUrl;
    
}

@property (nonatomic, copy) NSString *dealId;
@property (nonatomic, copy) NSString *dealTitle;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSData *imageData;
@property (nonatomic, copy) NSString *imageUrl;

-(id) initWithTitle:(NSString *)title andCategory: (NSString*) cat;

@end
