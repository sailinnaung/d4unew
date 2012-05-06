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
	[arrayCategory addObject:@"OOAD"];
	[arrayCategory addObject:@"CSCRUM"];
	[arrayCategory addObject:@"Java EE"];
	[arrayCategory addObject:@"PMIS"];
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
}

- (IBAction) emailDeal {
	MFMailComposeViewController *emailViewController = 
	[[MFMailComposeViewController alloc] init] ;
    emailViewController. mailComposeDelegate = self;
    
    [emailViewController setSubject: @"Great Deal"] ;
  //  NSString *msg = @"Don't Miss It!\n";
   // *msg = msg + @"aaa";
    NSString *msg = [NSString stringWithFormat:@"Great Deal!\n\nTitle: %@ \nMerchant: %@ \nCategory: %@ \nIs_Featured: %@ \nDescription: %@ \nLocation: %@ \nStart: %@ \nEnd: %@ \nRemarks: %@", 
                     txtTitle.text, 
                     txtMerchant.text, 
                     txtCategory.text, 
                     switchIsFeatured.on ? @"YES" : @"NO", 
                     txtDescription.text, 
                     txtLocation.text, 
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
    if (textView == txtCategory) {
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
    txtLocation.text  = [NSString stringWithFormat:@"%f", locationManager.location.coordinate];
    
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
