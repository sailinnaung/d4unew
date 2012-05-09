//
//  DealsServiceManager.m
//  Deals4U
//
//  Created by Arun Manivannan on 4/5/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "DealsServiceManager.h"
#import "Constants.h"
#import "Deal.h"
#import "DBManager.h"

@interface DealsServiceManager ()

-(NSArray*) convertResponseToDeals:(NSData*) jsonString;


@end

@implementation DealsServiceManager

//@synthesize buffer;

static DealsServiceManager *serviceManager =nil;

+ (DealsServiceManager *)sharedManager{
    
    if (serviceManager==nil){
        
        serviceManager=[[super allocWithZone:NULL] init];
    }
    return serviceManager;
}



// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init {
    
    self = [super init]; 
    if (self) {
        // Work your initialising magic here as you normally would
    }
    
    return self;
}



-(NSArray*) retrieveWhatsAroundWithLatitude: (NSString*) latitude andLongitude: (NSString*) longitude{
    
    
    dbManager=[DBManager sharedDBManager];
    NSString* categories=[dbManager categoriesSelected];
    //__block NSArray* returnArray=nil;
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",SERVER_BASE_URL, SEARCH_GET_NEAREST_KEYWORD, SEARCH_LATITUDE_KEYWORD,latitude,SEARCH_LONGITUDE_KEYWORD,longitude, SEARCH_CATEGORY_KEYWORD,categories];
    
    //NSString *urlString=[NSString stringWithFormat:@"%@%@",SERVER_BASE_URL, @"get_all"];

                                                 
    NSLog(@"Calling url %@",urlString);
     
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
       
    /*
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"Name: %@ %@", [JSON valueForKeyPath:@"first_name"], [JSON valueForKeyPath:@"last_name"]);
        NSLog(@"Json %@",[JSON description]);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure Response is %@",[response description]);
        NSLog(@"Failure Error is %d", [response statusCode ])  ;
        NSLog(@"JSON %@", [JSON description]);
    }];
       
    [operation start]; // start your operation directly, unless you really need to use a queue
    */
    
    /*
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success: %@", operation.responseString);
        
        //[SVProgressHUD dismissWithSuccess:@"Sucess!" afterDelay:2];
        returnArray=[self convertResponseToDeals:operation.responseString];
        
        
        
    } 
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  operation.responseString);
                                          
    }
    ];
    
    [operation start];
    [operation waitUntilFinished];
    */
    
    //urlConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self] ;
    
   // if (urlConnection){
        //[self convertResponseToDeals:[NSMutableData data]];
    //}
    
    NSURLResponse *response;
    NSError* error;
    
    NSData* result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return [self convertResponseToDeals:result];
}



-(NSArray*) retrieveAll {
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",SERVER_BASE_URL, @"get_all"];
    
      NSLog(@"Calling url %@",urlString);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
   
    
    NSURLResponse *response;
    NSError* error;
    
    NSData* result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return [self convertResponseToDeals:result];
}


-(NSArray*) retrieveAllLiked {
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",SERVER_BASE_URL, @"get_by_top_likes&number=5"];
    
    NSLog(@"Calling url %@",urlString);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    
    NSURLResponse *response;
    NSError* error;
    
    NSData* result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return [self convertResponseToDeals:result];
}




-(NSArray*)  convertResponseToDeals:(NSData*) jsonData{
    
    NSMutableArray *array=[NSMutableArray array];
    Deal* deal=nil;
    
    NSError* e; 
    NSArray* jsonArray= [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    
    if (!jsonArray){
        NSLog(@"Error.  The result is not an array");
    }
    else{
        for (NSDictionary *item in jsonArray){
            
            //NSLog(@"Item is %@",item);
            
            deal=[[Deal alloc]init];
            
            //dealTitle, category,description,latitude, longitude, merchantName, imageUrl, imageData
            deal.dealId=[item valueForKey:@"prmo_id"];
            deal.dealTitle=[item valueForKey:@"prmo_title"];
            deal.category=[item valueForKey:@"prmo_category"];
            deal.description=[item valueForKey:@"prmo_description"];
            deal.latitude=[item valueForKey:@"prmo_lat"];
            deal.longitude=[item valueForKey:@"prmo_long"];
            deal.merchantName=[item valueForKey:@"prmo_merchant"];
            deal.imageUrl=[item valueForKey:@"prmo_img"];

            NSLog(@"Deal is %@", [deal description]);
                   
            [array addObject:deal];
        }
        
        //NSLog(@"Array is %@", [array lastObject]);
        
        return array;
    }
    
    return array;
}

-(NSMutableArray*) retrieveSearchDeals: (NSString *)searchText 
{
    
    
    dbManager=[DBManager sharedDBManager];
    NSString* categories=[dbManager categoriesSelected];
      
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@%@%@%@",SERVER_BASE_URL,SEARCH_TITLE_ACTION,CATEGORY_LIST,categories,SEARCH_TEXT_KEYWORD,searchText];
    NSLog(@"Calling url %@",urlString);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    
    NSURLResponse *response;
    NSError* error;
    
    NSData* result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return [NSMutableArray arrayWithArray:[self convertResponseToDeals:result]];
}



@end
