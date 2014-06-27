//
//  ResetPasswordViewController.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/6/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

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
    [self.emailAddressTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetTapped:(id)sender
{
    [self.emailAddressTextField resignFirstResponder];
    
    //todo: call web service to reset password
        
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//This method doesn't really exist; registered in ViewDidLoad
- (void)textFieldDidChange:(UITextField *)textField{
    
    _emailAddressTextField.text = [_emailAddressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //replaces all whitespace
    
    if (_emailAddressTextField.text.length > 0)
    {
        if ([self validateEmail:_emailAddressTextField.text])
        {
            UIImage *image = [UIImage imageNamed: @"valid.png"];
            _validEmailImageView.image = image;
            _resetBarButtonItem.enabled = YES;
        }
        else{
            UIImage *image = [UIImage imageNamed: @"invalid.png"];
            _validEmailImageView.image = image;
            _resetBarButtonItem.enabled = NO;
        }
    }
    else
    {
        _resetBarButtonItem.enabled = NO;
    }
}

- (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
