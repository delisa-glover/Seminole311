//
//  Category.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 2/28/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property (assign) int categoryID;
@property (strong) NSString *title;
@property (strong) NSString *photoURL;
@property (strong) UIImage *categoryImage;
@property (strong) NSString *subCategoryMessage;

- (id)initWithTitle:(NSString *)title categoryID:(int)categoryID photoURL:(NSString *)photoURL categoryImage:(UIImage *)categoryImage subCategoryMessage:(NSString *)subCategoryMessage;

@end
