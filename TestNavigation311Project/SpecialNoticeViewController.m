//
//  SpecialNoticeViewController.m
//  Seminole 311
//
//  Created by DeLisa Glover on 10/4/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "SpecialNoticeViewController.h"
#import "LocalDataStorage.h"

@interface SpecialNoticeViewController ()

@end

@implementation SpecialNoticeViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *htmlString;
   
    htmlString = [NSString stringWithFormat:@"<center><h3>%@</h3></center><br />%@",
                  [self.notice title ], [self.notice announcement]];
    
    [self.specialNoticeWebView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
