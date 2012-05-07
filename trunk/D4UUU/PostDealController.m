//
//  PostDealController.m
//  Deals4U
//
//  Created by Arun Manivannan on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "PostDealController.h"


@interface PostDealController ()

@end

@implementation PostDealController 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Post Deal", @"Post Deal");
        self.tabBarItem.image = [UIImage imageNamed:@"postdeal"];
    }
    return self;
       
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [pvCategory setHidden:YES];
    arrayCategory =[[NSMutableArray alloc] init];
	[arrayCategory addObject:@"Food"];
	[arrayCategory addObject:@"Fashion"];
	[arrayCategory addObject:@"Entertainment"];
	[arrayCategory addObject:@"Lifestyle"];
    switchIsFeatured.on = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   // return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

/*-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [arrayCategory count];    
}*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}
-(NSInteger) pickerView:(UIPickerView *) thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [arrayCategory count];
}

-(NSString *) pickerView:(UIPickerView *) thePickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
	
	return [arrayCategory objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{ 
    txtCategory.text = [arrayCategory objectAtIndex:row];
    [pickerView setHidden:YES];
	NSLog(@"%@ selected",[arrayCategory objectAtIndex:row]);
}	

- (IBAction) addDeal {    
/*    NSString *urlString = [NSString stringWithFormat:@"http://www.ambracetech.com/projects/sch_iphone/_backend/prmo_group/prmo_post.php?prmo_title=%@&prmo_merchant=%@&prmo_category=%@&prmo_is_featured=%@&prmo_description=%@&prmo_lat=%@&prmo_long=%@&prmo_datetime_start=%@&prmo_datetime_end=%@&prmo_remarks=%@", */
 /*   NSString *urlString = [NSString stringWithFormat:@"http://www.ambracetech.com/projects/sch_iphone/_backend/prmo_group/prmo_post.php?prmo_title=%@&prmo_merchant=%@&prmo_category=%@&prmo_is_featured=0&prmo_description=%@&prmo_lat=%@&prmo_long=%@",                            [txtTitle.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [txtMerchant.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [txtCategory.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                       //    [(NSString*)switchIsFeatured.isOn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [txtDescription.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [@"1" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [@"0" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];//,
                         //  [@"" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           //[@"" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                         //  [txtRemarks.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  */ 

/*  escape($_POST["prmo_title"]), escape($_POST["prmo_merchant"]), escape($_POST["prmo_category"]), escape($_POST["prmo_is_featured"]), escape($_POST["prmo_description"]), escape($_POST["prmo_lat"]), escape($_POST["prmo_long"]), 0, escape($_POST["prmo_datetime_start"]), escape($_POST["prmo_datetime_end"]), 
  */  
 //   NSString *myRequestString = @"action=create&prmo_title=a&prmo_merchant=b&prmo_category=c&prmo_is_featured=0&prmo_description=d&prmo_lat=1&prmo_long=2";
    
    
    NSString *myRequestString = [NSString stringWithFormat: @"action=create&prmo_title=%@&prmo_merchant=%@&prmo_category=%@&prmo_is_featured=%@&prmo_description=%@&prmo_lat=%@&prmo_long=%@",
    txtTitle.text,
    txtMerchant.text,
    txtCategory.text,
    switchIsFeatured.on ? @"1" : @"0",
    txtDescription.text,
    txtLocationLat.text,
    txtLocationLong.text];//,
    //  [@"" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
    //[@"" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
    //  [txtRemarks.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];";
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.ambracetech.com/projects/sch_iphone/_backend/prmo_group/prmo_post.php?"]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: myRequestData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];

    NSError *error;
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];
  //  txtTitle.text = returnData.description;
    
    if(![returnData.description isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Post Deal Result"
                          message: @"Deal Posted Sucessfully!"
                          delegate: self cancelButtonTitle:
                          @"Close" otherButtonTitles: nil];
    
    [alert show];
    }

}

- (IBAction) emailDeal {
	MFMailComposeViewController *emailViewController = 
	[[MFMailComposeViewController alloc] init] ;
    emailViewController. mailComposeDelegate = self;
    
    [emailViewController setSubject: @"Great Deal"] ;
  //  NSString *msg = @"Don't Miss It!\n";
   // *msg = msg + @"aaa";
    NSString *msg = [NSString stringWithFormat:@"Great Deal!\n\nTitle: %@ \nMerchant: %@ \nCategory: %@ \nIs_Featured: %@ \nDescription: %@ \nLocation: %@, %@ \nStart: %@ \nEnd: %@ \nRemarks: %@", 
                     txtTitle.text, 
                     txtMerchant.text, 
                     txtCategory.text, 
                     switchIsFeatured.on ? @"YES" : @"NO", 
                     txtDescription.text, 
                     txtLocationLat.text, txtLocationLong.text, 
                     txtStartDate.text, 
                     txtEndDate.text, 
                     txtRemarks.text];
    [emailViewController setMessageBody: msg isHTML: NO] ;    
    [self presentModalViewController: emailViewController animated: YES] ;    	
}

- (void)mailComposeController: ( MFMailComposeViewController*) controller 
          didFinishWithResult: ( MFMailComposeResult)result 
                        error: ( NSError*) error {
    [controller dismissModalViewControllerAnimated:YES] ;
}

- (IBAction) smsDeal{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:8"]];
}

- (IBAction)switchDidBegin:(id)sender {
    for (UIView *subview in [self.view subviews]) {
        if ([subview class] == [UITextField class]) {
            [subview resignFirstResponder];
        }
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextView *)textView
{
    if (textView.text == txtCategory.text) {
        for (UIView *subview in [self.view subviews]) {
            if ([subview class] == [UITextField class]) {
                [subview resignFirstResponder];
            }
        }
        [txtCategory resignFirstResponder];
        txtCategory.inputView = pvCategory;
        [pvCategory setHidden:NO];
        [pvCategory setFrame:CGRectMake(0,200,0,0)];
        return NO;
    }
    else {
        return YES;
    }    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    return YES;
}
- (IBAction) getLocation{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    txtLocationLat.text  = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    txtLocationLong.text  = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
    
  /*  MKReverseGeocoder *reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:locationManager.location.coordinate];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
    */
    
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    txtLocationLat.text  = [NSString stringWithFormat:@"%@", placemark.description ]; 
    
}

- (IBAction)startDateEditDidBegin:(id)sender{
    [txtStartDate resignFirstResponder];
    pick = [[UIDatePicker alloc] init];
    [pick setFrame:CGRectMake(0,200,0,0)];
    [pick addTarget:self action:@selector(getStartDateDone) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pick];
}

- (IBAction)endDateEditDidBegin:(id)sender {
    [txtEndDate resignFirstResponder];
    pick = [[UIDatePicker alloc] init];
    [pick setFrame:CGRectMake(0,200,0,0)];
    [pick addTarget:self action:@selector(getEndDateDone) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pick];
}



-(void)getStartDateDone
{
    NSDate *choice = [pick date];
    txtStartDate.text = [[NSString alloc] initWithFormat:@"%@", choice];
    [pick removeFromSuperview];
    
}

-(void)getEndDateDone
{
    NSDate *choice = [pick date];
    txtEndDate.text = [[NSString alloc] initWithFormat:@"%@", choice];
    [pick removeFromSuperview];
    
}


@end
