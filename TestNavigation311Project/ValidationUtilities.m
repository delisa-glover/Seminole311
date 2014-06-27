//
//  ValidationUtilities.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 4/23/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "ValidationUtilities.h"

@implementation ValidationUtilities

+ (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)passwordsMatch:(NSString*)password confirmPassword:(NSString*)confirmPassword
{
    return [password isEqualToString:confirmPassword];
}

@end
