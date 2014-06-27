//
//  ReportsTableViewController.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/24/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportsViewController.h"
#import "NewReport.h"

@interface ReportsViewController : UITableViewController

@property (strong) NSMutableArray *reports;
@property (strong) NSMutableArray *catetorgies;

@end
