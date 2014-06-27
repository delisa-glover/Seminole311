//
//  ResetPasswordViewController.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/6/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UIImageView *validEmailImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetBarButtonItem;


- (IBAction)resetTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;

@end
