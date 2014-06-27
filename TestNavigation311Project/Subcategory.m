//
//  Subcategory.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 3/5/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "Subcategory.h"

@implementation Subcategory

- (id)initWithTitle:(NSString *)title subCategoryID:(int)subCategoryID subCategoryImage:(UIImage *)subCategoryImage{
    if ((self = [super init])) {
        self.title = title;
        self.subCategoryID = subCategoryID;
        self.subCategoryImage = subCategoryImage;
    }
    return self;
}

@end
