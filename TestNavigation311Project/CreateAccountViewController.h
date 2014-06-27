//
//  ReporterViewController.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 4/16/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reporter.h"
#import "LocationAnnotation.h"

@interface CreateAccountViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) id delegate;
@property (strong, nonatomic) Reporter *itemReporter;

//Form values
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UITextField *address2TextField;

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

//Validators
@property (weak, nonatomic) IBOutlet UIImageView *validEmailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordsMatchImageView;
@property (weak, nonatomic) IBOutlet UIImageView *validPhoneNumberImageView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButtonItem;

- (IBAction)saveTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;

- (void)setLocation:(LocationAnnotation *)annotation;
@end
