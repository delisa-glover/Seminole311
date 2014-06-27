//
//  ReportDetailsViewController.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/26/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "ReportDetailsViewController.h"

@interface ReportDetailsViewController ()

@end

@implementation ReportDetailsViewController

UIImage *reportDetailImage;

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
    
    _subcategoryLabel.text = _report.subCategoryName;
    _descriptionTextView.text = _report.description;
    
    if (_report.reportImage != nil)
    {
        _reportImageView.image = _report.reportImage;
    }
    else
    {
        _reportImageView.image = [UIImage imageNamed:@"noPhoto.jpg"];
    }
    
    
    
    _statusTextView.text = _report.status;
    
    //Split Location on the comma
    NSArray *addressArray = [_report.location.subtitle componentsSeparatedByString: @", "];
    if (addressArray.count >=2)
        _locationLabel.text = [NSString stringWithFormat:@"%@, %@", addressArray[0], addressArray[1]];
    else
        _locationLabel.text = _report.location.subtitle;
   
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

@end
