//
//  LoginViewController.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 4/25/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "LoginViewController.h"
#import "NewReportTableViewController.h"
#import "CreateAccountViewController.h"
#import "SVProgressHUD.h"
#import "SVWebViewController.h"
#import "Reachability.h"
#import "LocalDataStorage.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (Reporter *)itemReporter
{
    if (_itemReporter != nil) {
        return _itemReporter;
    }
    _itemReporter = [[Reporter alloc] init];
    [_itemReporter loadFromSandbox];
    return _itemReporter;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.emailAddressTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    [self.emailAddressTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    NSLog(@"%@", _itemReporter.deviceID);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scroller.contentSize=CGSizeMake(200.0, 500.0);
    
    if (_itemReporter.fullName.length != 0)
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"CreateAccount"]){
        
        CreateAccountViewController *vc = segue.destinationViewController;
        
        [vc setDelegate:self];
        
    }
}
- (IBAction)loginTapped:(id)sender
{
    
    [self.emailAddressTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    NSString *deviceGuid;
    
    if (self.itemReporter.deviceID.length == 0) //keep same phone guid if set
        deviceGuid = [[NSUUID UUID] UUIDString];
    else
        deviceGuid = self.itemReporter.deviceID;
    
    NSURL *url = [NSURL URLWithString:@"http://mobilews.seminolecountyfl.gov/Service1.svc/ProcessLogin"];
    
    NSLog(@"Process Login Url %@", url);
    
    __block NSString *loginStatus;
    __block NSError *errorReturned;
    
    [SVProgressHUD showWithStatus:@"Logging In" maskType:SVProgressHUDMaskTypeBlack];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // long-running code
        
        
        NSArray *keys = [NSArray arrayWithObjects:@"Email", @"Password", @"DeviceID", nil];
        NSArray *objects = [NSArray arrayWithObjects:_emailAddressTextField.text, _passwordTextField.text, deviceGuid, nil];
        NSData *__jsonData = nil;
        NSString *__jsonString = nil;
        
        
        NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        if([NSJSONSerialization isValidJSONObject:jsonDictionary])
        {
            __jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
            __jsonString = [[NSString alloc]initWithData:__jsonData encoding:NSUTF8StringEncoding];
        }
        
        // Be sure to properly escape your url string.
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: __jsonData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [__jsonData length]] forHTTPHeaderField:@"Content-Length"];
        
        errorReturned = nil;
        NSURLResponse *theResponse =[[NSURLResponse alloc]init];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned];
        
        if (!errorReturned)
        {
            NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
            
            // NSLog(@"%@", searchResultsDict[@"Name"]);
            
            loginStatus = searchResultsDict[@"AccountStatus"];
            
            if (searchResultsDict[@"AccountStatus"] == [NSNull null])  //Login Successful
            {
                loginStatus = @""; //set to empty string so we can compare to strings below
                
                //Set pList data with data from successful login
                self.itemReporter.fullName = searchResultsDict[@"Name"];
                self.itemReporter.emailAddress = searchResultsDict[@"Email"];
                self.itemReporter.phoneNumber = (searchResultsDict[@"PhoneNumber"] != [NSNull null]) ? searchResultsDict[@"PhoneNumber"] : @"";
                
                if (self.itemReporter.deviceID.length == 0)
                    self.itemReporter.deviceID = searchResultsDict[@"DeviceID"];
                self.itemReporter.address = (searchResultsDict[@"Address"] != [NSNull null]) ? searchResultsDict[@"Address"] : @"";

                self.itemReporter.address2 = (searchResultsDict[@"Address2"] != [NSNull null]) ? searchResultsDict[@"Address2"] : @"";

                self.itemReporter.city = (searchResultsDict[@"City"] != [NSNull null]) ? searchResultsDict[@"City"] : @"";

                self.itemReporter.state = (searchResultsDict[@"State"] != [NSNull null]) ? searchResultsDict[@"State"] : @"";

                self.itemReporter.zipCode = (searchResultsDict[@"ZipCode"] != [NSNull null]) ? searchResultsDict[@"ZipCode"] : @"";

                
                [self.itemReporter saveToSandbox];  //save pList data
                
                [self.delegate setReporter:self.itemReporter]; //set data on report
            }
            
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if ([loginStatus isEqualToString:@"Inactive"])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Account Inactive"
                                                               message: @"Your account is inactive. Please call (407) 665-0000 to report the problem."
                                                              delegate: self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                
                
                [alert show];
            }
            else if([loginStatus isEqualToString:@"Failed"])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Login Failed"
                                                               message: @"Invalid email or password. Try Again or Create Account."
                                                              delegate: self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                
                
                [alert show];
                
            }
            else if (errorReturned)
            { 
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Failed with error: %@", errorReturned.localizedDescription]];
            }
            else if (self.itemReporter.fullName.length > 0)
            {
                [SVProgressHUD showSuccessWithStatus:@"Logged In"];
                //load reports in the background
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [LocalDataStorage loadReports:_itemReporter.deviceID];
                });
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"Error Occurred...Try Again"];
            }
            
        });
    });
    
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetPasswordTapped:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Redirecting to Website"
                                                   message: @"Select 'Forgot Password' to reset the password."
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    
    [alert show];
    
    NSURL *URL = [NSURL URLWithString:@"http://www.seminolecountyfl.gov/cms_application_placeholder.aspx?page=CMSForm&formid=82"];
	SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
	[self presentViewController:webViewController animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.passwordTextField) {
        [theTextField resignFirstResponder];
    } else if (theTextField == self.emailAddressTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    return YES;
}

-(IBAction)backgroundTouched:(id)sender
{
    [_emailAddressTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

//This method doesn't really exist; registered in ViewDidLoad
- (void)textFieldDidChange:(UITextField *)textField{
    
    _emailAddressTextField.text = [_emailAddressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //replaces all whitespace
    
    _passwordTextField.text = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //replaces all whitespace
    
    if (_emailAddressTextField.text.length > 0 && _passwordTextField.text.length > 0)
    {
        if ([self validateEmail:_emailAddressTextField.text])
        {
            UIImage *image = [UIImage imageNamed: @"valid.png"];
            _validEmailImageView.image = image;
            _loginBarButtonItem.enabled = YES;
            _loginButton.enabled = YES;
            _loginButton.alpha = 1.0;
        }
        else{
            UIImage *image = [UIImage imageNamed: @"invalid.png"];
            _validEmailImageView.image = image;
            _loginBarButtonItem.enabled = NO;
            _loginButton.enabled = NO;
            _loginButton.alpha = 0.5;
        }
    }
    else
    {
        _loginBarButtonItem.enabled = NO;
        _loginButton.enabled = NO;
        _loginButton.alpha = 0.5;
    }
}

- (void)passbackReporter:(Reporter *) reporter{
    [self.delegate setReporter:reporter];
    
    self.itemReporter = reporter;
}
/*
- (void)textFieldDidBeginEditing:(UITextView *)textField {
    //Scrolls up when keyboard appears, only works in portrait view
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y += -75;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextView *)textField {
    //Scrolls down when keyboard disappears, only works in portrait view
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y += 75;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}
*/

- (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


@end
