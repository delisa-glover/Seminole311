//
//  AppInfoViewController.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/28/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "AppInfoViewController.h"
#import "SVWebViewController.h"

@interface AppInfoViewController ()

@end

@implementation AppInfoViewController

NSString* version;

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
    version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    _appVersionLabel.text = [_appVersionLabel.text stringByAppendingFormat:@"%@", version];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scroller.contentSize=CGSizeMake(200.0, 800.0);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mobileSiteTapped:(id)sender;
{
    NSURL *URL = [NSURL URLWithString:@"http://m.seminolecountyfl.gov"];
	SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
	[self presentViewController:webViewController animated:YES completion:nil];
}
- (IBAction)privacyPolicyTapped:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"http://www.seminolecountyfl.gov/guide/privacy.aspx"];
	SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
	[self presentViewController:webViewController animated:YES completion:nil];
    
}
- (IBAction)supportTapped:(id)sender
{
    // Email Subject
    NSString *emailTitle = @"Question from Seminole 311";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"\n\n\nSeminole 311 Apple App\nApp Version: %@\nDevice Type: %@\nDevice iOS Version: %@", version, [UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"is_web@seminolecountyfl.gov"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
