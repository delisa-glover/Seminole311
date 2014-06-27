//
//  Category.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 2/28/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "Category.h"

@implementation Category

- (id)initWithTitle:(NSString *)title categoryID:(int)categoryID photoURL:(NSString *)photoURL categoryImage:(UIImage *)categoryImage subCategoryMessage:(NSString *)subCategoryMessage{
    if ((self = [super init])) {
        self.title = title;
        self.categoryID = categoryID;
        self.photoURL = photoURL;
        self.categoryImage = categoryImage;
        self.subCategoryMessage = subCategoryMessage;
    }
    return self;
}
@end
