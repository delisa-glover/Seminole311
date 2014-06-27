//
//  ValidationUtilities.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 4/23/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidationUtilities : NSObject

+ (BOOL)validateEmail:(NSString*)email;
+ (BOOL)passwordsMatch:(NSString*)password confirmPassword:(NSString*)confirmPassword;

@end
