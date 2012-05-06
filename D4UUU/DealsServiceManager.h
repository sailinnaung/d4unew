//
//  DealsServiceManager.h
//  Deals4U
//
//  Created by Arun Manivannan on 4/5/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;

@interface DealsServiceManager : NSObject{

    //NSURLConnection *urlConnection;
    //NSMutableData *buffer;
    DBManager* dbManager;
}

-(NSArray*) retrieveWhatsAroundWithLatitude: (NSString*) latitude andLongitude: (NSString*) longitude;

-(NSArray*) retrieveAll ;

+(DealsServiceManager*) sharedManager;

-(NSMutableArray*) retrieveSearchDeals: (NSString *)searchText; 

//@property (strong) NSMutableData *buffer;

@end
