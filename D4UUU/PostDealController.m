//
//  PostDealController.m
//  Deals4U
//
//  Created by Vincent Choo on 29/4/12.
//  Copyright (c) 2012 tech@arunma.com. All rights reserved.
//

#import "PostDealController.h"
#import "DBManager.h"

@interface PostDealController ()

@end

@implementation PostDealController 
@synthesize imageData, sResponse, spinningWheel;

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
    
    /** Getting available categories from SQLite DB **/
    dbManager = [DBManager sharedDBManager];
    arrayCategory =dbManager.arrAvailable;
	
    switchIsFeatured.on = NO;
    txtLocationLong.enabled = NO;
    txtLocationLat.enabled = NO;
    
    dateFormat=@"yyyy-MM-dd HH:mm";
     
    
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
//    [pickerView setHidden:YES];
	NSLog(@"%@ selected",[arrayCategory objectAtIndex:row]);
}	

- (BOOL) inputTextValidation
{
    NSString *errMessage = [[NSString alloc] init];
    errMessage = [errMessage stringByAppendingString:@"Please key in "];
    
    if([txtTitle.text length]==0){
        
        errMessage = [errMessage stringByAppendingString:@"\n the promotion title name "];
        NSLog(@"errMessage: %@",errMessage);
    }
    if([txtMerchant.text length]==0){
        
        errMessage = [errMessage stringByAppendingString:@"\n the Merchant name"];
        NSLog(@"errMessage: %@",errMessage);
    }
    if([txtCategory.text length]==0){
        
        errMessage = [errMessage stringByAppendingString:@"\n the promotion category"];
        NSLog(@"errMessage: %@",errMessage);
    }
    if([txtDescription.text length]==0){
        
        errMessage = [errMessage stringByAppendingString:@"\n the promotion description"];
        NSLog(@"errMessage: %@",errMessage);
    }
    if(([txtLocationLat.text length]==0) || ([txtLocationLong.text length]==0)){
        
        errMessage = [errMessage stringByAppendingString:@"\n and Please click for location selector."];
        NSLog(@"errMessage: %@",errMessage);
    }
    
    NSLog(@"errMessage: %@",errMessage);
    
    if(([txtTitle.text length]==0) || 
       ([txtMerchant.text length]==0) ||
       ([txtCategory.text length]==0) ||
       ([txtDescription.text length]==0) ||
       ([txtLocationLat.text length]==0) ||
       ([txtLocationLong.text length]==0)){
        NSLog(@"inside Error Flag");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Invalid Value!!"
                              message: errMessage
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }else{
        return YES;
    }

}

- (IBAction) addDeal {
    if ([self inputTextValidation])
    {
    // Chen Lim : Start posting with Image Upload
    NSString *urlString = @"http://www.ambracetech.com/projects/sch_iphone/_backend/prmo_group/prmo_post.php";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSMutableData *body = [NSMutableData data];
    
    
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: attachment; name=\"prmo_image_main\"; filename=\"fromiPhoneApp.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Text parameter1
    NSString *param1 = @"create";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[param1 dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

    // Another text parameter
    NSString *param2 = txtTitle.text;
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[param2 dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

        // Another text parameter
        NSString *param3 = txtMerchant.text;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_merchant\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param3 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param4 = txtCategory.text;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_category\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param4 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param5 = switchIsFeatured.on ? @"1" : @"0";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_is_featured\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param5 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param6 = txtDescription.text;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param6 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param7 = txtLocationLat.text;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_lat\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param7 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param8 = txtLocationLong.text;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_long\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param8 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
        // Another text parameter - start date
        NSString *startText=txtStartDate.text;
        NSUInteger len = [startText length];
        NSString *start_date=[startText substringToIndex:(len-6)];
        NSString *start_hh=[startText substringWithRange:NSMakeRange((len-5), 2)];
        NSString *start_mm=[startText substringFromIndex:(len-2)];
        NSString *param9 = start_date;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_datetime_start\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param9 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *param10 = start_hh;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_datetime_start_hh\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param10 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *param11 = start_mm;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_datetime_start_mm\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param11 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter - end date
        NSString *endText=txtEndDate.text;
        NSUInteger end_len = [endText length];
        NSString *end_date=[endText substringToIndex:(end_len-6)];
        NSString *end_hh=[endText substringWithRange:NSMakeRange((end_len-5), 2)];
        NSString *end_mm=[endText substringFromIndex:(end_len-2)];
        NSString *param12 = end_date;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_datetime_end\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param12 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *param13 = end_hh;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_datetime_end_hh\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param13 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *param14 = end_mm;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_datetime_end_mm\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param14 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param15 = txtRemarks.text;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"prmo_remarks\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[param15 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        //call the url Asynchronously
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [spinningWheel startAnimating];   
  /*
        
        NSString *myRequestString = [NSString stringWithFormat: @"action=create&prmo_title=%@&prmo_merchant=%@&prmo_category=%@&prmo_is_featured=%@&prmo_description=%@&prmo_lat=%@&prmo_long=%@&prmo_datetime_start=%@&prmo_datetime_start_hh=%@&prmo_datetime_start_mm=%@",
                                     txtTitle.text,
                                     txtMerchant.text,
                                     txtCategory.text,
                                     switchIsFeatured.on ? @"1" : @"0",
                                     txtDescription.text,
                                     txtLocationLat.text,
                                     txtLocationLong.text,
                                     dateDate,
                                     start_hh,
                                     start_mm];//,    
        
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.ambracetech.com/projects/sch_iphone/_backend/prmo_group/prmo_post.php?"]];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: myRequestData];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        
        
        
        
        NSError *error;
        NSURLResponse *response;
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];
     */   
        /*if(![returnData.description isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Post Deal Result"
                                                            message: @"Deal Posted Sucessfully!"
                                                           delegate: self cancelButtonTitle:
                                  @"Close" otherButtonTitles: nil];
            
            [alert show];
        }*/
    }

   

   
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	//NSLog(@"Did receive response");
    // cast the response to NSHTTPURLResponse so we can look for 404 etc
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] >= 400) 
    {
        [spinningWheel stopAnimating];
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle: @"Problem with Server-Side."
                                           message: @"Deal Not Posted."
                                          delegate: self cancelButtonTitle:
                 @"Close" otherButtonTitles: nil];
    }
    else 
    {
        sResponse = [[NSMutableString alloc] initWithString:@""];
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData{
    //NSLog(@"String sent from server %@",[[NSString alloc] initWithData:theData encoding: NSUTF8StringEncoding]);
    NSString *sTemp = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    [sResponse appendString:sTemp];
}
- (void)connectionDidFail:(NSURLConnection *)connection {
	//NSLog(@"Connection Failed");
    [spinningWheel stopAnimating];
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: @"Failed To Connect To Server"
                                       message: @"Deal Not Posted."
                                      delegate: self cancelButtonTitle:
             @"Close" otherButtonTitles: nil];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//NSLog(@"Connection Did Finish Loading!");
    [spinningWheel stopAnimating];
    
    NSRange range = [sResponse rangeOfString:@"Promotion Successfully Created"];
    UIAlertView *alert;
    if (range.location != NSNotFound)
    {
        alert = [[UIAlertView alloc] initWithTitle: @"Post Deal Result"
                                           message: @"Deal Posted Sucessfully!"
                                          delegate: self cancelButtonTitle:
                 @"Close" otherButtonTitles: nil];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle: @"Post Deal Result"
                                           message: @"Deal Not Posted."
                                          delegate: self cancelButtonTitle:
                 @"Close" otherButtonTitles: nil];
    }
    [alert show];
}

- (IBAction) emailDeal {
    if([self inputTextValidation])
    {
        MFMailComposeViewController *emailViewController = 
        [[MFMailComposeViewController alloc] init] ;
        emailViewController. mailComposeDelegate = self;
        
        [emailViewController setSubject: @"Great Deal"] ;

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
	   	
}

- (void)mailComposeController: ( MFMailComposeViewController*) controller 
          didFinishWithResult: ( MFMailComposeResult)result 
                        error: ( NSError*) error {
    [controller dismissModalViewControllerAnimated:YES] ;
}

- (IBAction) smsDeal
{
    if([self inputTextValidation])
    {
        NSLog(@"inside smsDeal");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:12345678"]];
    }
	
}

- (IBAction)switchDidBegin:(id)sender {
    for (UIView *subview in [self.view subviews]) {
        if ([subview class] == [UITextField class]) {
            [subview resignFirstResponder];
        }
    }
}

-(IBAction)presentCategoryPickerActionSheet
{
    [txtCategory resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtEndDate resignFirstResponder];
    [txtLocationLat resignFirstResponder];
    [txtLocationLong resignFirstResponder];
    [txtMerchant resignFirstResponder];
    [txtRemarks resignFirstResponder];
    [txtStartDate resignFirstResponder];
    [txtTitle resignFirstResponder];
    
    actPickerSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:nil];
    
    [actPickerSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 0, 0, 0);
    
    UIPickerView *pvCategory=[[UIPickerView alloc] initWithFrame:pickerFrame];
    pvCategory.delegate = self;
    pvCategory.dataSource = self;
    pvCategory.showsSelectionIndicator=YES;
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"] ];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    
    [actPickerSheet addSubview:pvCategory];
    [actPickerSheet addSubview:closeButton];
    
    [actPickerSheet showInView: self.view ];
    [actPickerSheet setBounds:CGRectMake(0, 0, 320, 485)];  
    
    txtCategory.inputView = pvCategory;
}
/*
- (BOOL) textFieldShouldBeginEditing:(UITextView *)textView
{
    if (textView == txtCategory) {
        for (UIView *subview in [self.view subviews]) {
            if ([subview class] == [UITextField class] && textView != txtCategory) {
                [subview resignFirstResponder];
            }
        
        
    }   
    return YES;
}
*/

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self animateTextField:textField up:NO];
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        animatedDistance = 216-(460-moveUpValue-5);
    }
    else
    {
        animatedDistance = 162-(320-moveUpValue-5);
    }
    
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f; 
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);       
        [UIView commitAnimations];
    }
}

- (void)dismissActionSheet:(id)sender{
    NSLog(@"inside dismissActionSheet");
    
    /** If no selection has done, set the default category **/
    if([txtCategory.text length]==0){
        txtCategory.text = [arrayCategory objectAtIndex:0];
    }
    
    [actPickerSheet dismissWithClickedButtonIndex:0 animated:YES];
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

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
    NSLog(@"Inside PostDealController.didFailWithError for geocoder");
}

- (IBAction)startDateEditDidBegin:(id)sender{
    [txtStartDate resignFirstResponder];
    
    actPickerSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:nil];
    
    UIDatePicker *dPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 40, 0.0, 0.0)];
    
    dPicker.datePickerMode = UIDatePickerModeDateAndTime;
    dPicker.maximumDate=[NSDate date];  
    
    pick = dPicker;
    [pick addTarget:self action:@selector(getStartDateDone) forControlEvents:UIControlEventValueChanged];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"] ];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    
    NSString *dateText=((UITextField *)sender).text;
    if([dateText length] >0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:dateFormat];
        NSDate *date = [dateFormatter dateFromString:dateText];
        pick.date = date;
    }
    
    [actPickerSheet addSubview:pick];
    [actPickerSheet addSubview:closeButton];
    
    [actPickerSheet showInView: self.view ];
    [actPickerSheet setBounds:CGRectMake(0, 0, 320, 485)]; 
}


- (IBAction)endDateEditDidBegin:(id)sender {
    [txtEndDate resignFirstResponder];
    
    actPickerSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:nil];
    
    UIDatePicker *dPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 40, 0.0, 0.0)];
    
    dPicker.datePickerMode = UIDatePickerModeDateAndTime;
 //   dPicker.maximumDate=[NSDate date]; 
    
    pick = dPicker;
    [pick addTarget:self action:@selector(getEndDateDone) forControlEvents:UIControlEventValueChanged ];
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"] ];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    
    NSString *dateText=((UITextField *)sender).text;
    if([dateText length] >0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:dateFormat];
        NSDate *date = [dateFormatter dateFromString:dateText];
        pick.date = date;
    }
    [actPickerSheet addSubview:pick];
    [actPickerSheet addSubview:closeButton];
    
    [actPickerSheet showInView: self.view ];
    [actPickerSheet setBounds:CGRectMake(0, 0, 320, 485)]; 
    
}

-(void)getStartDateDone
{
    NSLog(@"inside getStartDateDone");
    NSDate *choice;
    
    /** If no selection has done, set the default today's date **/
    if([txtStartDate.text length]==0){
        choice = [NSDate date];
    }else{
        choice = [pick date];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:dateFormat];
    txtStartDate.text = [dateFormatter stringFromDate:choice];    
    
 //   [actPickerSheet dismissWithClickedButtonIndex:0 animated:YES];
    
}

-(void)getEndDateDone
{
    NSLog(@"inside getStartDateDone");
    NSDate *choice;
    
    /** If no selection has done, set the default today's date **/
    if([txtEndDate.text length]==0){
        choice = [NSDate date];
    }else{
        choice = [pick date];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:dateFormat];
    txtEndDate.text = [dateFormatter stringFromDate:choice];
    
//    [actPickerSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)imgSel
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
           
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else{
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        

        [self presentModalViewController:picker animated:YES];
        //[picker release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"errore accesso photo library" 
                                                        message:@"il device non supporta la photo library" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
    }

}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    imageData = UIImageJPEGRepresentation(newImage, 0.5);
    
    [picker dismissModalViewControllerAnimated:YES];
}

@end
