//
//  WebServiceUtilities.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 2/28/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "WebServiceUtilities.h"

@implementation WebServiceUtilities

/*+ (NSArray *)getCategories:(SearchCompletionBlock) completionBlock
{
   /NSString *searchURL = @"http://www.seminolecountyfl.gov/m/311WebService/MobileData.asmx/GetCategoriesList";
    NSLog(@"Search Categories URL: %@", searchURL);
    NSArray *objCategories;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                                encoding:NSUTF8StringEncoding
                                                                   error:&error];
        if (error != nil) {
            completionBlock(nil,error);
        }
        else
        {NSLog(@"Parsing JSON response! ");
            NSLog(@"JSON response: %@", searchResultString);
            // Parse the JSON Response
            NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                              options:kNilOptions
                                                                                error:&error];
            if(error != nil)
            {NSLog(@"Parse JASON error! ");
                completionBlock(nil,error);
            }
            else
            {
                NSString * status = searchResultsDict[@"stat"];
                if ([status isEqualToString:@"fail"]) {
                    NSError * error = [[NSError alloc] initWithDomain:@"CategorySearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: searchResultsDict[@"message"]}];
                    completionBlock(nil, error);
                } else {
                    
                    objCategories = searchResultsDict[@"Categories"];
                    
                    
                    completionBlock(objCategories,nil);
                    
                    
                }
            }
        }
    });
   return  new NSArray 
    
}
*/
@end
