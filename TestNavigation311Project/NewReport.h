//
//  NewReport.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 3/29/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationAnnotation.h"

@class Reporter;

@interface NewReport : NSObject

@property (strong) Reporter *reporterInfo;
@property (strong) NSString *description;
@property (strong) LocationAnnotation *location;
@property (strong) UIImage *reportImage;
@property (strong) NSString *reportImageURL;
@property (assign) int subCategoryID;
@property (strong) NSString *subCategoryName;
@property (strong) NSString *status;

@end
