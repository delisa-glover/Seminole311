//
//  SpecialNotice.m
//  Seminole 311
//
//  Created by DeLisa Glover on 10/4/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "SpecialNotice.h"

@implementation SpecialNotice

- (id)initWithTitle:(NSString *)title announcementID:(int)announcementID announcement:(NSString *)announcement{
    if ((self = [super init])) {
        self.title = title;
        self.announcementID = announcementID;
        self.announcement = announcement;
    }
    return self;
}

@end
