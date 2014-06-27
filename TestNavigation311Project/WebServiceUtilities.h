//
//  WebServiceUtilities.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 2/28/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Category;

typedef void (^SearchCompletionBlock)(NSArray *results, NSError *error);
typedef void (^CategoryPhotoCompletionBlock)(UIImage *photoImage, NSError *error);


@interface WebServiceUtilities : NSObject
/*
+ (NSArray *)getCategories: (SearchCompletionBlock) completionBlock;

+ (void)loadImageForURL:(NSString *)categoryPhotoURL completionBlock:(CategoryPhotoCompletionBlock) completionBlock;
*/
@end
