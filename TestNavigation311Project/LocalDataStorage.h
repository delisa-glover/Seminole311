//
//  LoadData.h
//  Seminole 311
//
//  Created by DeLisa Glover on 6/3/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewReport.h"

@interface LocalDataStorage : NSObject

+ (void)loadCategories;
+ (void)loadSubCategories;
+ (void)loadReports:(NSString*)deviceID;
+ (void)loadSpecialNotice;
+ (void)saveReport:(NewReport*)report;

+ (NSString *)categoriesFileName;
+ (NSString *)subcategoriesFileName;
+ (NSString *)reportsFileName;
+ (NSString *)specialNoticeFileName;
@end
