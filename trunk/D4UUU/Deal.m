//
//  Deal.m
//  Deals4U
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "Deal.h"

@implementation Deal

@synthesize dealId,dealTitle, category,description,latitude, longitude, merchantName, imageUrl, imageData;

-(id) initWithTitle:(NSString *)title andCategory:(NSString *)cat{

    self=[super init];
    
    if (self){
        self.dealTitle=title;
        self.category=cat;
    }
    
    return self;
}

@end
