//
//  SecondMenuViewController.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 3/13/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "MenuViewController.h"
#import "Category.h"
#import "CategoryViewController.h"
#import "UpdateAccountViewController.h"
#import "LoginViewController.h"
#import "ReportsViewController.h"
#import "SpecialNoticeViewController.h"
#import "SVProgressHUD.h"
#import "SVWebViewController.h"
#import "Reachability.h"
#import "NewReport.h"
#import "LocalDataStorage.h"

@interface MenuViewController ()
    -(void)reachabilityChanged:(NSNotification*)note;
@end

@implementation MenuViewController

Reachability *networkReachability;
NetworkStatus networkStatus;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
        });
    };
    
    [reach startNotifier];
    
    version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    _itemReporter = [Reporter alloc];
    _notice = [SpecialNotice alloc];
    
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    
    if(![reach isReachable])
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Lost"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.scroller.contentSize=CGSizeMake(700.0, 1200.0);
        
    }
    else
    {
        self.scroller.contentSize=CGSizeMake(250.0, 700.0);
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    //Load data from local storage files
    [LocalDataStorage loadSpecialNotice];
    [LocalDataStorage loadCategories];
    [LocalDataStorage loadSubCategories];
    
    [_itemReporter loadFromSandbox]; //load reporter info

    [LocalDataStorage loadReports:_itemReporter.deviceID]; //get prior reports for reporter
    
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGSize screen_size = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _headerImageView.image = [UIImage imageNamed:@"Header2_2x.png"];
        _mapImageView.image = [UIImage imageNamed:@"MapOutlineBig.png"];
        
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight)
        {
            [self.scroller setFrame:CGRectMake(0, 10, screen_size.height, screen_size.width)];
            
            _headerImageView.frame = CGRectMake(200, 0, 646, 100);
            _mapImageView.frame = CGRectMake(150, 170, 740, 409);
            _call911View.frame = CGRectMake(25, 100, (screen_size.height-50), 35);
            _specialNoticeView.frame = CGRectMake(25, 125, (screen_size.height-50), 32);
            _call911Label.frame = CGRectMake(400, 90, 300, 25);
            _call911Label.font = [UIFont systemFontOfSize:16];
            
            _button1View.frame = CGRectMake(260, 280, 140, 128);
            _button1.frame = CGRectMake(0,0,90,90);
            [_button1 setBackgroundImage:[UIImage imageNamed:@"NewReport2x.png"] forState:UIControlStateNormal];
            _button1Label.frame = CGRectMake(0, 100, 100, 20);
            _button1Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button2View.frame = CGRectMake(490, 280, 70, 64);
            _button2.frame = CGRectMake(0,0,90,90);
            [_button2 setBackgroundImage:[UIImage imageNamed:@"MyReports2x.png"] forState:UIControlStateNormal];
            _button2Label.frame = CGRectMake(-3, 100, 85, 20);
            _button2Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button3View.frame = CGRectMake(690, 278, 50, 66);
            _button3.frame = CGRectMake(0,0,90,90);
            [_button3 setBackgroundImage:[UIImage imageNamed:@"MyInfo2x.png"] forState:UIControlStateNormal];
            _button3Label.frame = CGRectMake(10, 100, 70, 20);
            _button3Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button4View.frame = CGRectMake(260, 470, 50, 64);
            _button4.frame = CGRectMake(0,0,90,90);
            [_button4 setBackgroundImage:[UIImage imageNamed:@"Tweets2x.png"] forState:UIControlStateNormal];
            _button4Label.frame = CGRectMake(0, 90, 80, 20);
            _button4Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button5View.frame = CGRectMake(480, 470, 85, 64);
            _button5.frame = CGRectMake(0,0,90,90);
            [_button5 setBackgroundImage:[UIImage imageNamed:@"GetPrepared2x.png"] forState:UIControlStateNormal];
            _button5Label.frame = CGRectMake(-5, 90, 100, 20);
            _button5Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button6View.frame = CGRectMake(690, 470, 50, 64);
            _button6.frame = CGRectMake(0,0,90,90);
            [_button6 setBackgroundImage:[UIImage imageNamed:@"Events2x.png"] forState:UIControlStateNormal];
            _button6Label.frame = CGRectMake(5, 90, 80, 20);
            _button6Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
        }
        else
        {
            [self.scroller setFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            
            _headerImageView.frame = CGRectMake(75, 0, 646, 100);
            _mapImageView.frame = CGRectMake(70, 190, 640, 309);
            _call911View.frame = CGRectMake(10, 100, (screen_size.width-20), 35);
            _specialNoticeView.frame = CGRectMake(10, 125, (screen_size.width-20), 32);
            _call911Label.frame = CGRectMake(400, 90, 300, 25);
            _call911Label.font = [UIFont systemFontOfSize:16];
            
            _button1View.frame = CGRectMake(150, 260, 140, 128);
            _button1.frame = CGRectMake(0,0,90,90);
            [_button1 setBackgroundImage:[UIImage imageNamed:@"NewReport2x.png"] forState:UIControlStateNormal];
            _button1Label.frame = CGRectMake(0, 100, 100, 20);
            _button1Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button2View.frame = CGRectMake(350, 260, 70, 64);
            _button2.frame = CGRectMake(0,0,90,90);
            [_button2 setBackgroundImage:[UIImage imageNamed:@"MyReports2x.png"] forState:UIControlStateNormal];
            _button2Label.frame = CGRectMake(-3, 100, 85, 20);
            _button2Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button3View.frame = CGRectMake(520, 258, 50, 66);
            _button3.frame = CGRectMake(0,0,90,90);
            [_button3 setBackgroundImage:[UIImage imageNamed:@"MyInfo2x.png"] forState:UIControlStateNormal];
            _button3Label.frame = CGRectMake(10, 100, 70, 20);
            _button3Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button4View.frame = CGRectMake(150, 410, 50, 64);
            _button4.frame = CGRectMake(0,0,90,90);
            [_button4 setBackgroundImage:[UIImage imageNamed:@"Tweets2x.png"] forState:UIControlStateNormal];
            _button4Label.frame = CGRectMake(0, 90, 80, 20);
            _button4Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button5View.frame = CGRectMake(340, 410, 85, 64);
            _button5.frame = CGRectMake(0,0,90,90);
            [_button5 setBackgroundImage:[UIImage imageNamed:@"GetPrepared2x.png"] forState:UIControlStateNormal];
            _button5Label.frame = CGRectMake(-5, 90, 100, 20);
            _button5Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button6View.frame = CGRectMake(520, 410, 50, 64);
            _button6.frame = CGRectMake(0,0,90,90);
            [_button6 setBackgroundImage:[UIImage imageNamed:@"Events2x.png"] forState:UIControlStateNormal];
            _button6Label.frame = CGRectMake(5, 90, 80, 20);
            _button6Label.titleLabel.font = [UIFont systemFontOfSize:16];
        }
        
    }
    else
    {
        _mapImageView.image = [UIImage imageNamed:@"MapOutline.png"];
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight)
        {
            if (screen_size.height == 568) //iPhone 5
            {
                _mapImageView.frame = CGRectMake(120, 100, 350, 209);
                _button1View.frame = CGRectMake(160, 150, 70, 64);
                _button2View.frame = CGRectMake(265, 150, 70, 64);
                _button3View.frame = CGRectMake(370, 146, 50, 66);
                _button4View.frame = CGRectMake(160, 230, 50, 64);
                _button5View.frame = CGRectMake(265, 230, 85, 64);
                _button6View.frame = CGRectMake(370, 230, 50, 64);
            }
            else
            {
                _mapImageView.frame = CGRectMake(70, 100, 350, 209);
                _button1View.frame = CGRectMake(110, 150, 70, 64);
                _button2View.frame = CGRectMake(215, 150, 70, 64);
                _button3View.frame = CGRectMake(320, 146, 50, 66);
                _button4View.frame = CGRectMake(110, 230, 50, 64);
                _button5View.frame = CGRectMake(210, 230, 85, 64);
                _button6View.frame = CGRectMake(320, 230, 50, 64);
                
            }
        }
        else
        {
            _mapImageView.frame = CGRectMake(0, 90, 320, 209);
        }
    }
    
    [self setSpecialNotice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGSize screen_size = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _headerImageView.image = [UIImage imageNamed:@"Header2_2x.png"];
        _mapImageView.image = [UIImage imageNamed:@"MapOutlineBig.png"];
        
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            [self.scroller setFrame:CGRectMake(0, 10, screen_size.height, screen_size.width)];
            
            _headerImageView.frame = CGRectMake(200, 0, 646, 100);
            _mapImageView.frame = CGRectMake(150, 170, 740, 409);
            _call911View.frame = CGRectMake(25, 100, (screen_size.height-50), 35);
            _specialNoticeView.frame = CGRectMake(25, 125, (screen_size.height-50), 32);
            _call911Label.frame = CGRectMake(400, 90, 300, 25);
            _call911Label.font = [UIFont systemFontOfSize:16];
            
            _button1View.frame = CGRectMake(260, 280, 140, 128);
            _button1.frame = CGRectMake(0,0,90,90);
            [_button1 setBackgroundImage:[UIImage imageNamed:@"NewReport2x.png"] forState:UIControlStateNormal];
            _button1Label.frame = CGRectMake(0, 100, 100, 20);
            _button1Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button2View.frame = CGRectMake(490, 280, 70, 64);
            _button2.frame = CGRectMake(0,0,90,90);
            [_button2 setBackgroundImage:[UIImage imageNamed:@"MyReports2x.png"] forState:UIControlStateNormal];
            _button2Label.frame = CGRectMake(-3, 100, 85, 20);
            _button2Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button3View.frame = CGRectMake(690, 278, 50, 66);
            _button3.frame = CGRectMake(0,0,90,90);
            [_button3 setBackgroundImage:[UIImage imageNamed:@"MyInfo2x.png"] forState:UIControlStateNormal];
            _button3Label.frame = CGRectMake(10, 100, 70, 20);
            _button3Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button4View.frame = CGRectMake(260, 470, 50, 64);
            _button4.frame = CGRectMake(0,0,90,90);
            [_button4 setBackgroundImage:[UIImage imageNamed:@"Tweets2x.png"] forState:UIControlStateNormal];
            _button4Label.frame = CGRectMake(0, 90, 80, 20);
            _button4Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button5View.frame = CGRectMake(480, 470, 85, 64);
            _button5.frame = CGRectMake(0,0,90,90);
            [_button5 setBackgroundImage:[UIImage imageNamed:@"GetPrepared2x.png"] forState:UIControlStateNormal];
            _button5Label.frame = CGRectMake(-5, 90, 100, 20);
            _button5Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button6View.frame = CGRectMake(690, 470, 50, 64);
            _button6.frame = CGRectMake(0,0,90,90);
            [_button6 setBackgroundImage:[UIImage imageNamed:@"Events2x.png"] forState:UIControlStateNormal];
            _button6Label.frame = CGRectMake(5, 90, 80, 20);
            _button6Label.titleLabel.font = [UIFont systemFontOfSize:16];


            
        }
        else
        {
            [self.scroller setFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            
            _headerImageView.frame = CGRectMake(75, 0, 646, 100);
            _mapImageView.frame = CGRectMake(70, 190, 640, 309);
            _call911View.frame = CGRectMake(10, 100, (screen_size.width-20), 35);
            _specialNoticeView.frame = CGRectMake(10, 125, (screen_size.width-20), 32);
            _call911Label.frame = CGRectMake(400, 90, 300, 25);
            _call911Label.font = [UIFont systemFontOfSize:16];
            
            _button1View.frame = CGRectMake(150, 260, 140, 128);
            _button1.frame = CGRectMake(0,0,90,90);
            [_button1 setBackgroundImage:[UIImage imageNamed:@"NewReport2x.png"] forState:UIControlStateNormal];
            _button1Label.frame = CGRectMake(0, 100, 100, 20);
            _button1Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button2View.frame = CGRectMake(350, 260, 70, 64);
            _button2.frame = CGRectMake(0,0,90,90);
            [_button2 setBackgroundImage:[UIImage imageNamed:@"MyReports2x.png"] forState:UIControlStateNormal];
            _button2Label.frame = CGRectMake(-3, 100, 85, 20);
            _button2Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button3View.frame = CGRectMake(520, 258, 50, 66);
            _button3.frame = CGRectMake(0,0,90,90);
            [_button3 setBackgroundImage:[UIImage imageNamed:@"MyInfo2x.png"] forState:UIControlStateNormal];
            _button3Label.frame = CGRectMake(10, 100, 70, 20);
            _button3Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button4View.frame = CGRectMake(150, 410, 50, 64);
            _button4.frame = CGRectMake(0,0,90,90);
            [_button4 setBackgroundImage:[UIImage imageNamed:@"Tweets2x.png"] forState:UIControlStateNormal];
            _button4Label.frame = CGRectMake(0, 90, 80, 20);
            _button4Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button5View.frame = CGRectMake(340, 410, 85, 64);
            _button5.frame = CGRectMake(0,0,90,90);
            [_button5 setBackgroundImage:[UIImage imageNamed:@"GetPrepared2x.png"] forState:UIControlStateNormal];
            _button5Label.frame = CGRectMake(-5, 90, 100, 20);
            _button5Label.titleLabel.font = [UIFont systemFontOfSize:16];
            
            _button6View.frame = CGRectMake(520, 410, 50, 64);
            _button6.frame = CGRectMake(0,0,90,90);
            [_button6 setBackgroundImage:[UIImage imageNamed:@"Events2x.png"] forState:UIControlStateNormal];
            _button6Label.frame = CGRectMake(5, 90, 80, 20);
            _button6Label.titleLabel.font = [UIFont systemFontOfSize:16];

        }
    }
    else
    {
        _mapImageView.image = [UIImage imageNamed:@"MapOutline.png"];
        if (toInterfaceOrientation  == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            
            if (screen_size.height == 568) //iPhone 5
            {
                _mapImageView.frame = CGRectMake(120, 100, 350, 209);
                _button1View.frame = CGRectMake(160, 150, 70, 64);
                _button2View.frame = CGRectMake(265, 150, 70, 64);
                _button3View.frame = CGRectMake(370, 146, 50, 66);
                _button4View.frame = CGRectMake(160, 230, 50, 64);
                _button5View.frame = CGRectMake(265, 230, 85, 64);
                _button6View.frame = CGRectMake(370, 230, 50, 64);
            }
            else
            {
                _mapImageView.frame = CGRectMake(70, 100, 350, 209);
                _button1View.frame = CGRectMake(110, 150, 70, 64);
                _button2View.frame = CGRectMake(215, 150, 70, 64);
                _button3View.frame = CGRectMake(320, 146, 50, 66);
                _button4View.frame = CGRectMake(110, 230, 50, 64);
                _button5View.frame = CGRectMake(210, 230, 85, 64);
                _button6View.frame = CGRectMake(320, 230, 50, 64);

            }
            
        }
        else
        {
            _mapImageView.frame = CGRectMake(0, 90, 320, 209);
            _button1View.frame = CGRectMake(35, 145, 70, 64);
            _button2View.frame = CGRectMake(130, 145, 70, 64);
            _button3View.frame = CGRectMake(227, 141, 50, 66);
            _button4View.frame = CGRectMake(41, 230, 50, 64);
            _button5View.frame = CGRectMake(119, 230, 85, 64);
            _button6View.frame = CGRectMake(227, 230, 50, 64);
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"HelpPushed"])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage categoriesFileName] ]) {
            
            UIImage *categoryImage;
            NSMutableArray *categories;
            NSMutableArray *tempArray;

            categories = [@[] mutableCopy];
            tempArray = [@[] mutableCopy];
            tempArray = [NSMutableArray arrayWithContentsOfFile:[LocalDataStorage categoriesFileName]];
            
            for(NSMutableDictionary *objCategory in tempArray)
            {
                categoryImage = [UIImage imageWithData:objCategory[@"CategoryImageData"]];
                
                
                Category *category = [[Category alloc] initWithTitle:objCategory[@"Name"] categoryID:[objCategory[@"ID"] intValue] photoURL:[objCategory[@"Icon"] stringByReplacingOccurrencesOfString:@"\\" withString:@""] categoryImage:categoryImage subCategoryMessage:objCategory[@"SubCategoryMessage"]];
                
                [categories addObject:category];
            }
            CategoryViewController *categoryController = segue.destinationViewController;
            categoryController.categories = categories;
        }
        
        
    }
    else if ([[segue identifier] isEqualToString:@"MyReportsPushed"])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage reportsFileName] ]) {
            
            NSMutableArray *reports;
            NSMutableArray *tempArray;
            
            reports = [@[] mutableCopy];
            tempArray = [@[] mutableCopy];
            tempArray = [NSMutableArray arrayWithContentsOfFile:[LocalDataStorage reportsFileName]];
            
            for(NSMutableDictionary *objReport in tempArray)
            {
                NewReport *report = [NewReport alloc];
                
                if (objReport[@"ReportImageData"] != nil)
                    report.reportImage = [UIImage imageWithData:objReport[@"ReportImageData"]];
                
                report.reportImageURL = [objReport[@"PhotoPath"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                report.location = [LocationAnnotation alloc];
                report.location.subtitle = objReport[@"Address"];
                
                report.description = objReport[@"Description"];
                report.subCategoryName = objReport[@"SubcategoryName"];
                report.status = objReport[@"Status"];
                
                [reports addObject:report];
            }
          
            ReportsViewController *reportsController = segue.destinationViewController;
            reportsController.reports = reports;
        }
    
    }
    else if([[segue identifier] isEqualToString:@"SpecialNoticePushed"])
    {
        SpecialNoticeViewController *specialNoticeController = segue.destinationViewController;
        specialNoticeController.notice = self.notice;
    }

}

#pragma mark - Button Taps

- (IBAction)newReportTapped:(id)sender
{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage categoriesFileName] ]) {
        [self performSegueWithIdentifier:@"HelpPushed"
                                  sender:self];

    }
    else if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Loading Categories"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [LocalDataStorage loadCategories];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkCategoryFileExists) userInfo:nil repeats:NO];

            });
        });

    }
    
}
- (void)checkCategoryFileExists
{
    [SVProgressHUD dismiss];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage categoriesFileName] ]) {
        [self performSegueWithIdentifier:@"HelpPushed"
                                  sender:self];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"Slow Data Connection...Try Again"];
    }
}

- (IBAction)myReportsTapped:(id)sender
{
    if (_itemReporter == nil || _itemReporter.deviceID == nil || [_itemReporter.deviceID isEqual: @""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Account Not Found"
                                                       message: @"Tap 'My Info' to create an account."
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage reportsFileName] ]) {
        [self performSegueWithIdentifier:@"MyReportsPushed"
                                  sender:self];
        
    }
    else if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Loading Reports" maskType:SVProgressHUDMaskTypeBlack];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [LocalDataStorage loadReports:_itemReporter.deviceID];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkReportsFileExists) userInfo:nil repeats:NO];
                
            });
        });
    }
}
    
- (void)checkReportsFileExists
{
    [SVProgressHUD dismiss];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage reportsFileName] ]) {
        [self performSegueWithIdentifier:@"MyReportsPushed"
                                  sender:self];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"Slow Data Connection...Try Again"];
    }
}

- (IBAction)myAccountTapped:(id)sender{
    
    
    if (_itemReporter.fullName.length == 0)
    {
        NSString * storyboardName = @"MainStoryboard_iPhone";
        NSString * viewControllerID = @"LoginViewController";
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        LoginViewController * controller = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        NSString * storyboardName = @"MainStoryboard_iPhone";
        NSString * viewControllerID = @"UpdateAccountViewController";
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UpdateAccountViewController * controller = (UpdateAccountViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
        controller.itemReporter = _itemReporter;
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }

}

- (IBAction)prepareSeminoleTapped:(id)sender {
    if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        NSURL *URL = [NSURL URLWithString:@"http://www.prepareseminole.com"];
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (IBAction)currentInfoTapped:(id)sender {
    if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        NSURL *URL = [NSURL URLWithString:@"http://m.seminolecountyfl.gov/calendar.aspx"];
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (IBAction)socialMediaTapped:(id)sender {
    if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        NSURL *URL = [NSURL URLWithString:@"http://mobile.twitter.com/seminolecounty"];
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
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


#pragma mark Utility Methods
- (void) setSpecialNotice
{

    if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage specialNoticeFileName] ])
    {

        NSString *announcementTitle;
        NSDictionary *tempDictionary = [NSDictionary dictionaryWithContentsOfFile:[LocalDataStorage specialNoticeFileName]];
        NSDictionary *objSpecialNotice = [NSDictionary dictionaryWithDictionary:[tempDictionary objectForKey:@"SpecialNotice"]];
        
        announcementTitle = [objSpecialNotice valueForKey:@"AnnouncementTitle"];
        
        if (announcementTitle.length == 0)
        {
            [self.specialNoticeView setHidden:YES];
            [self.call911Label setHidden:YES];
            [self.call911View setHidden:NO];
        }
        else
        {
            [self.notice initWithTitle:announcementTitle announcementID:[[objSpecialNotice valueForKey:@"AnnouncementID"] intValue] announcement:[objSpecialNotice valueForKey:@"Announcement"]]; //this is used, ignore warning
            
            [self.specialNoticeButton setTitle:announcementTitle forState:UIControlStateNormal];
            [self.specialNoticeView setHidden:NO];
            [self.call911Label setHidden:NO];
            [self.call911View setHidden:YES];

        }
    }
    else
    {
        [self.specialNoticeView setHidden:YES];
        [self.call911Label setHidden:YES];
        [self.call911View setHidden:NO];

    }
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


//Needed for the Login and Update Account view controllers
//since this is the delegate, but doesn't need to do anything
- (void)setReporter:(Reporter *) reporter{
    _itemReporter = reporter;
}

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)unwindSegue
{
    
}


@end
