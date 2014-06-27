//
//  SpecialNoticeViewController.h
//  Seminole 311
//
//  Created by DeLisa Glover on 10/4/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialNotice.h"

@interface SpecialNoticeViewController : UIViewController

@property (strong) SpecialNotice *notice;

@property (weak, nonatomic) IBOutlet UIWebView *specialNoticeWebView;

@end
