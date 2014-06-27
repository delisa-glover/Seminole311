//
//  LoadData.m
//  Seminole 311
//
//  Created by DeLisa Glover on 6/3/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "LocalDataStorage.h"

@implementation LocalDataStorage

#pragma mark - Return pList File Names
+ (NSString *)appDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)categoriesFileName
{
    //NSLog(@"reading file at path: %@", [self appDocumentsDirectory]);
    return [[self appDocumentsDirectory] stringByAppendingPathComponent:
            @"Semcty311Categories.plist"];
}

+ (NSString *)subcategoriesFileName
{
    //NSLog(@"reading file at path: %@", [self appDocumentsDirectory]);
    return [[self appDocumentsDirectory] stringByAppendingPathComponent:
            @"Semcty311SubCategories.plist"];
}

+ (NSString *)reportsFileName
{
    //NSLog(@"reading file at path: %@", [self appDocumentsDirectory]);
    return [[self appDocumentsDirectory] stringByAppendingPathComponent:
            @"Semcty311Reports.plist"];
}

+ (NSString *)specialNoticeFileName
{
    //NSLog(@"reading file at path: %@", [self appDocumentsDirectory]);
    return [[self appDocumentsDirectory] stringByAppendingPathComponent:
            @"Semcty311SpecialNotice.plist"];
}

#pragma mark - Load data from storage
+ (void)loadCategories
{
    if (![self fileRecent:[self categoriesFileName]]) //don't get data if it's recent
    {
        //Load Categories
        NSString *searchURL = @"http://mobilews.seminolecountyfl.gov/Service1.svc/GetCategories";
        NSLog(@"Load Data Search Categories URL: %@", searchURL);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // long-running code
            NSMutableArray *tempCategoryArray;
            NSError *error = nil;
            
            //Call the web service and get the results in string format
            NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                                    encoding:NSUTF8StringEncoding
                                                                       error:&error];
            //NSLog(@"%@", error.localizedDescription);
            if(error == nil)
            {
                //Convert results from string to data
                NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
                
                //convert results from data to dictionary
                NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                  options:kNilOptions
                                                                                    error:&error];
                if (error == nil)
                {
                    NSArray *objCategories = searchResultsDict[@"Categories"];
                    
                    UIImage *categoryImage;
                    NSData *categoryImageData;
                    NSString *categoryMessage;
                    
                    tempCategoryArray = [@[] mutableCopy];
                    
                    for(NSMutableDictionary *objCategory in objCategories)
                    {
                        //copy the category and add the image to it in data format for storing in plist
                        NSMutableDictionary *tempCategory = [NSMutableDictionary dictionaryWithDictionary:objCategory];
                        
                        categoryImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[objCategory[@"Icon"] stringByReplacingOccurrencesOfString:@"\\" withString:@""]]]];
                        categoryImageData = UIImageJPEGRepresentation(categoryImage, 0.5);
                        categoryMessage = objCategory[@"SubCategoryMessage"];
                        
                        if (categoryMessage == (id)[NSNull null])
                        {
                            [tempCategory setObject:@"" forKey:@"SubCategoryMessage"];
                        }
                        
                        if (categoryImageData != nil)
                            [tempCategory setObject:categoryImageData forKey:@"CategoryImageData"]; //add image in data format
                        [tempCategory setObject:[NSNumber numberWithInteger:0] forKey:@"ParentCategoryID"]; //set parent id to 0
                        
                        [tempCategoryArray addObject:tempCategory];
                        
                    }
                    if (![self fileRecent:[self categoriesFileName]]) //don't write data if it's recent
                    {
                        NSLog(@"writing to categories file");
                        
                        [tempCategoryArray writeToFile:[self categoriesFileName] atomically:YES]; //save categories in pList
                    }
                }
            }
            
        });
    }
    
}

+ (void)loadSubCategories
{
    if (![self fileRecent:[self subcategoriesFileName]]) //don't get data if it's recent
    {
        //Load Sub Categories
        NSString *searchURL = @"http://mobilews.seminolecountyfl.gov/Service1.svc/GetSubCategories";
        NSLog(@"Load Data Search Sub Categories URL: %@", searchURL);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // long-running code
            NSMutableArray *tempCategoryArray;
            NSError *error = nil;
            
            //Call the web service and get the results in string format
            NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                                    encoding:NSUTF8StringEncoding
                                                                       error:&error];
            //NSLog(@"%@", error.localizedDescription);
            if(error == nil)
            {
                //Convert results from string to data
                NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
                
                //convert results from data to dictionary
                NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                  options:kNilOptions
                                                                                    error:&error];
                if (error == nil)
                {
                    NSArray *objCategories = searchResultsDict[@"SubCategories"];
                    
                    UIImage *categoryImage;
                    NSData *categoryImageData;
                    NSString *categoryMessage;
                    
                    tempCategoryArray = [@[] mutableCopy];
                    
                    for(NSMutableDictionary *objCategory in objCategories)
                    {
                        //copy the category and add the image to it in data format for storing in plist
                        NSMutableDictionary *tempCategory = [NSMutableDictionary dictionaryWithDictionary:objCategory];
                        
                        categoryImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[objCategory[@"Icon"] stringByReplacingOccurrencesOfString:@"\\" withString:@""]]]];
                        categoryImageData = UIImageJPEGRepresentation(categoryImage, 0.5);
                        
                        if (categoryImageData != nil)
                            [tempCategory setObject:categoryImageData forKey:@"CategoryImageData"]; //add image in data format
                        
                        categoryMessage = objCategory[@"SubCategoryMessage"];
                        
                        if (categoryMessage == (id)[NSNull null])
                        {
                            [tempCategory setObject:@"" forKey:@"SubCategoryMessage"];
                        }
                        
                        [tempCategoryArray addObject:tempCategory];
                        
                    }
                    if (![self fileRecent:[self subcategoriesFileName]]) //don't write data if it's recent
                    {
                        NSLog(@"writing to subcategories file");
                        [tempCategoryArray writeToFile:[self subcategoriesFileName] atomically:YES]; //save subcategories in pList
                    }
                }
            }
            
        });
    }
    
}

+ (void)loadReports:(NSString*)deviceID
{
    if (![self fileRecent:[self reportsFileName]]) //don't get the data if it's recent
    {

        if (deviceID == nil)
            deviceID = @"00000000-0000-0000-0000-000000000000";
        //Load Reports
        NSString *searchURL = [NSString stringWithFormat:@"http://mobilews.seminolecountyfl.gov/Service1.svc/GetReports/%@", deviceID];
        NSLog(@"Search Reports URL: %@", searchURL);
        

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // long-running code
            NSMutableArray *tempReportsArray;
            NSError *error = nil;
            
            //Call the web service and get the results in string format
            NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                                    encoding:NSUTF8StringEncoding
                                                                       error:&error];
            //NSLog(@"%@", error.localizedDescription);
            if(error == nil)
            {
                //Convert results from string to data
                NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
                
                //convert results from data to dictionary
                NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                  options:kNilOptions
                                                                                    error:&error];
                if (error == nil)
                {
                    NSArray *objReports = searchResultsDict[@"Reports"];
                    
                    UIImage *reportImage;
                    NSData *reportImageData;
                    
                    tempReportsArray = [@[] mutableCopy];
                    
                    for(NSMutableDictionary *objReport in objReports)
                    {
                        //copy the report and add the image to it in data format for storing in plist
                        NSMutableDictionary *tempReport = [NSMutableDictionary dictionaryWithDictionary:objReport];
                        
                        reportImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[objReport[@"PhotoPath"] stringByReplacingOccurrencesOfString:@"\\" withString:@""]]]];
                        reportImageData = UIImageJPEGRepresentation(reportImage, 1.0);
                        
                        if (reportImageData != nil)
                            [tempReport setObject:reportImageData forKey:@"ReportImageData"]; //add image in data format
                        
                        [tempReportsArray addObject:tempReport];
                        
                    }
                    
                    if (![self fileRecent:[self reportsFileName]]) //don't write the data if it's recent
                    {
                        NSLog(@"writing to reports file");
                        [tempReportsArray writeToFile:[self reportsFileName] atomically:YES]; //save reports in pList
                    }
                }
            }
            
        });
    }
}

+ (void)loadSpecialNotice
{
    if (![self fileRecent:[self specialNoticeFileName]]) //don't get data if it's recent
    {
        //Load SpecialNotice
        NSString *searchURL = @"http://mobilews.seminolecountyfl.gov/Service1.svc/GetSpecialNotice";
        NSLog(@"Load Special Notice URL: %@", searchURL);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // long-running code
            NSError *error = nil;
            
            //Call the web service and get the results in string format
            NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                                    encoding:NSUTF8StringEncoding
                                                                       error:&error];
            //NSLog(@"%@", error.localizedDescription);
            if(error == nil)
            {
                //Convert results from string to data
                NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
                
                //convert results from data to dictionary
                NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                  options:kNilOptions
                                                                                    error:&error];
                if (error == nil)
                {
                    if (![self fileRecent:[self specialNoticeFileName]]) //don't write data if it's recent
                    {
                        NSLog(@"writing to special notice file");
                        [searchResultsDict writeToFile:[self specialNoticeFileName] atomically:YES]; //save special notice in pList
                    }
                }
            }
            
        });
    }
    
}

+ (void) saveReport:(NewReport*)report
{
    NSMutableArray *tempReportsArray;
    
    tempReportsArray = [@[] mutableCopy];
    
    NSMutableDictionary *tempReport = [[NSMutableDictionary alloc] init];
    
    [tempReport setObject:report.description forKey:@"Description"];
    [tempReport setObject:@"Submitted Successfully" forKey:@"Status"];
    [tempReport setObject:report.subCategoryName forKey:@"SubcategoryName"];
    
    if (report.location.subtitle.length == 0)
        [tempReport setObject:[NSString	stringWithFormat:@"%f, %f", report.location.coordinate.latitude, report.location.coordinate.longitude] forKey:@"Address"];
    else
        [tempReport setObject:report.location.subtitle forKey:@"Address"];
    
    NSData *reportImageData = UIImageJPEGRepresentation(report.reportImage, 0.5);
    if (reportImageData != nil)
        [tempReport setObject:reportImageData forKey:@"ReportImageData"]; //add image in data format
    
    [tempReportsArray addObject:tempReport];
    [tempReportsArray addObjectsFromArray:[NSMutableArray arrayWithContentsOfFile:[self reportsFileName]]];
    
    [tempReportsArray writeToFile:[self reportsFileName] atomically:YES]; //save reports in pList
    
}

+ (bool)fileRecent:(NSString*)fileName
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName ]) {
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:nil];
        
        NSDate *filedate = [attributes fileModificationDate];
        
        //calculate the difference between today's date and the date of the pList file
        //load from database if the pList file is too old
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSMinuteCalendarUnit;
        
        NSDateComponents *components = [gregorian components:unitFlags
                                                    fromDate:filedate
                                                      toDate:[NSDate date] options:0];
        NSInteger minutes = [components minute];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileName] && minutes < 5) {  //if file less than 5 minutes old
            return YES;
        }
    }
    return NO;
}

@end
