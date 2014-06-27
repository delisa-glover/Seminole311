//
//  SecondMenuViewController.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 3/13/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Reporter.h"
#import "SpecialNotice.h"

@interface MenuViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *specialNoticeButton;
@property (weak, nonatomic) IBOutlet UIView *specialNoticeView;
@property (weak, nonatomic) IBOutlet UIView *call911View;
@property (weak, nonatomic) IBOutlet UILabel *call911Label;
@property (weak, nonatomic) IBOutlet UIView *button1View;
@property (weak, nonatomic) IBOutlet UIView *button2View;
@property (weak, nonatomic) IBOutlet UIView *button3View;
@property (weak, nonatomic) IBOutlet UIView *button4View;
@property (weak, nonatomic) IBOutlet UIView *button5View;
@property (weak, nonatomic) IBOutlet UIView *button6View;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button1Label;
@property (weak, nonatomic) IBOutlet UIButton *button2Label;
@property (weak, nonatomic) IBOutlet UIButton *button3Label;
@property (weak, nonatomic) IBOutlet UIButton *button4Label;
@property (weak, nonatomic) IBOutlet UIButton *button5Label;
@property (weak, nonatomic) IBOutlet UIButton *button6Label;

//@property (strong) NSMutableArray *catetorgies;
//@property (strong) NSMutableArray *reports;
@property (strong, nonatomic) SpecialNotice *notice;
@property (strong, nonatomic) Reporter *itemReporter;

- (IBAction)myAccountTapped:(id)sender;
- (IBAction)myReportsTapped:(id)sender;
- (IBAction)newReportTapped:(id)sender;
- (IBAction)prepareSeminoleTapped:(id)sender;
- (IBAction)currentInfoTapped:(id)sender;
- (IBAction)socialMediaTapped:(id)sender;
- (IBAction)mobileSiteTapped:(id)sender;
- (IBAction)privacyPolicyTapped:(id)sender;
- (IBAction)supportTapped:(id)sender;

@end
    