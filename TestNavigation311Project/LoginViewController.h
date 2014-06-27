//
//  LoginViewController.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 4/25/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reporter.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) id delegate;
@property (strong, nonatomic) Reporter *itemReporter;

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIImageView *validEmailImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginBarButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;

- (void)passbackReporter:(Reporter *) reporter;
@end
