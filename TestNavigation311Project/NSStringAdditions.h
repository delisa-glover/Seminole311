//
//  NSStringAdditions.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/24/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSString.h>

@interface NSString (NSStringAdditions)

+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

@end