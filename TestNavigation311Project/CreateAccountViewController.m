//
//  ReporterViewController.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 4/16/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "LoginViewController.h"
#import "UserAddressViewController.h"
#import "SVProgressHUD.h"
#import "Reachability.h"

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

Reachability *networkReachability;
NetworkStatus networkStatus;

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
    
    _fullNameTextField.text = self.itemReporter.fullName;
    _emailAddressTextField.text = self.itemReporter.emailAddress;
    _phoneNumberTextField.text = self.itemReporter.phoneNumber;
    
    self.fullNameTextField.delegate = self;
    self.emailAddressTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    self.address2TextField.delegate = self;
    
    [self.fullNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.emailAddressTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.confirmPasswordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.address2TextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scroller.contentSize=CGSizeMake(200.0, 400.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"GetUserAddress"]){
        
        UserAddressViewController *vc = segue.destinationViewController;
        [vc setDelegate:self];
        
    }
    
}


- (IBAction)saveTapped:(id)sender
{
    __block bool accountExists = NO;
    
    [self.fullNameTextField resignFirstResponder];
    [self.emailAddressTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
    [self.address2TextField resignFirstResponder];
    
    NSString *deviceGuid = @"";
    NSString *address = @"";
    NSString *city = @"";
    NSString *state = @"";
    NSString *zipCode = @"";
    
    if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Creating Account" maskType:SVProgressHUDMaskTypeBlack];
        
        if (_itemReporter.deviceID.length == 0) //keep same phone guid if set
            deviceGuid = [[NSUUID UUID] UUIDString];
        else
            deviceGuid = _itemReporter.deviceID;
        
        NSURL *url = [NSURL URLWithString:@"http://mobilews.seminolecountyfl.gov/Service1.svc/CreateAccount"];
        
        NSLog(@"Create Account Url %@", url);
        
        //parse Address
        NSArray *addressArray = [_addressButton.currentTitle componentsSeparatedByString:@", "];
        if ([addressArray count] > 3)
        {
            address = [addressArray objectAtIndex:0];
            city = [addressArray objectAtIndex:1];
            state = [addressArray objectAtIndex:2];
            zipCode = [addressArray objectAtIndex:3];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // long-running code
            
            NSArray *keys = [NSArray arrayWithObjects:@"Name", @"Email", @"Password", @"PhoneNumber", @"DeviceID", @"Address", @"Address2", @"City", @"State", @"ZipCode", nil];
            NSArray *objects = [NSArray arrayWithObjects:_fullNameTextField.text, _emailAddressTextField.text, _passwordTextField.text, _phoneNumberTextField.text, deviceGuid, address, _address2TextField.text, city, state, zipCode, nil];
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
            
            NSError *errorReturned = nil;
            NSURLResponse *theResponse =[[NSURLResponse alloc]init];
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned];
            
            
            if (!errorReturned)
            {
                NSString *responseString=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
                //NSLog(@"%@", responseString);
                
                if ([responseString boolValue]) //new account was created successfully
                {
                    //save the user data to pList
                    self.itemReporter.fullName = _fullNameTextField.text;
                    self.itemReporter.emailAddress = _emailAddressTextField.text;
                    self.itemReporter.phoneNumber = _phoneNumberTextField.text;
                    self.itemReporter.deviceID = deviceGuid;
                    self.itemReporter.address = address;
                    self.itemReporter.address2 = _address2TextField.text;
                    self.itemReporter.city = city;
                    self.itemReporter.state = state;
                    self.itemReporter.zipCode = zipCode;
                    
                    [_itemReporter saveToSandbox];
                    
                    [self.delegate passbackReporter:self.itemReporter];
                    
                }
                else
                {
                    accountExists = YES;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                if (accountExists)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Account Already Exists"
                                                                   message: @"You already have an account, please log in."
                                                                  delegate: self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                    
                    
                    [alert show];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else if (errorReturned)
                {
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Failed with error: %@", errorReturned.localizedDescription]];
                }

                else if (_itemReporter.fullName.length > 0)
                {
                    [SVProgressHUD showSuccessWithStatus:@"Account Created"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:@"Error Occurred...Try Again"];
                }
                
                
            });
        });
        
    }
    
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)accountExists
{
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.address2TextField) {
        [theTextField resignFirstResponder];
    } else if (theTextField == self.confirmPasswordTextField) {
        [self.address2TextField becomeFirstResponder];
    } else if (theTextField == self.passwordTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
    } else if (theTextField == self.phoneNumberTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (theTextField == self.emailAddressTextField) {
        [self.phoneNumberTextField becomeFirstResponder];
    } else if (theTextField == self.fullNameTextField) {
        [self.emailAddressTextField becomeFirstResponder];
    }

    return YES;
}

-(IBAction)backgroundTouched:(id)sender
{
    [_fullNameTextField resignFirstResponder];
    [_emailAddressTextField resignFirstResponder];
    [_phoneNumberTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_confirmPasswordTextField resignFirstResponder];
    [_address2TextField resignFirstResponder];
}

# pragma mark - Form Validation
//This method doesn't really exist; registered in ViewDidLoad
- (void)textFieldDidChange:(UITextField *)textField{
    _saveBarButtonItem.enabled = NO;
    
    _emailAddressTextField.text = [_emailAddressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //replaces all whitespace
    
    _passwordTextField.text = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //replaces all whitespace
    
    _confirmPasswordTextField.text = [_confirmPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //replaces all whitespace
    
    UIImage *validImage = [UIImage imageNamed: @"valid.png"];
    UIImage *invalidImage = [UIImage imageNamed: @"invalid.png"];
    
    if (_emailAddressTextField.text.length > 0)
    {
        if ([self validateEmail:_emailAddressTextField.text])
        {
            _validEmailImageView.image = validImage;
            
            if (_passwordTextField.text.length > 0 && _confirmPasswordTextField.text.length > 0)
            {
                if ([_passwordTextField.text isEqualToString:(_confirmPasswordTextField.text)])
                {
                    _passwordsMatchImageView.image = validImage;
                    
                    if (_fullNameTextField.text.length > 0)
                    {
                        if (_phoneNumberTextField.text.length > 13)
                        {
                            _validPhoneNumberImageView.image = validImage;
                            
                            if (![_addressButton.currentTitle isEqualToString:@" Find My Address"])
                            {
                                _saveBarButtonItem.enabled = YES;
                            }
                        }
                        else{
                            _validPhoneNumberImageView.image = invalidImage;
                        }
                    }                    
                }
                else
                {
                    _passwordsMatchImageView.image = invalidImage;
                }
            }
        }
        else{
            _validEmailImageView.image = invalidImage;
        }
    }
    
}

- (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
 - (BOOL)passwordsMatch
{
    return NO;
}

# pragma mark - Phone Number Formatting
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneNumberTextField)
    {
        int length = [self getLength:textField.text];
        //NSLog(@"Length  =  %d ",length);
        
        if(length == 10)
        {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:textField.text];
            //NSLog(@"%@",[num  substringToIndex:3]);
            //NSLog(@"%@",[num substringFromIndex:3]);
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
    }
    return YES;
}

-(NSString*)formatNumber:(NSString*)phoneNumber
{
    
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    //NSLog(@"%@", phoneNumber);
    
    int length = [phoneNumber length];
    if(length > 10)
    {
        phoneNumber = [phoneNumber substringFromIndex: length-10];
        //NSLog(@"%@", phoneNumber);
        
    }
    
    
    return phoneNumber;
}


-(int)getLength:(NSString*)phoneNumber
{
    
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [phoneNumber length];
    
    return length;
    
    
}

- (void)setLocation:(LocationAnnotation *)annotation{
    if (annotation.subtitle.length == 0)
        annotation.subtitle = @"";
    [self.addressButton setTitle: annotation.subtitle forState: UIControlStateNormal];
}

@end
