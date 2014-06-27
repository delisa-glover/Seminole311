//
//  Subcategory.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 3/5/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subcategory : NSObject

@property (assign) int subCategoryID;
@property (strong) NSString *title;
@property (strong) UIImage *subCategoryImage;

- (id)initWithTitle:(NSString *)title subCategoryID:(int)subCategoryID subCategoryImage:(UIImage *)subCategoryImage;


@end
