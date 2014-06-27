//
//  ReportDetailsViewController.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/26/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewReport.h"

@interface ReportDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *subcategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIImageView *reportImageView;

@property (strong, nonatomic) NewReport *report;

@end
