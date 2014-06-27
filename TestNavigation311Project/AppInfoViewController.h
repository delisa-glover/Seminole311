//
//  AppInfoViewController.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/28/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 

@interface AppInfoViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;

- (IBAction)mobileSiteTapped:(id)sender;
- (IBAction)privacyPolicyTapped:(id)sender;
- (IBAction)supportTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;
@end
