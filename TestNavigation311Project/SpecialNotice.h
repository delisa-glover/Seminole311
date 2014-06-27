//
//  SpecialNotice.h
//  Seminole 311
//
//  Created by DeLisa Glover on 10/4/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialNotice : NSObject

@property (assign) int announcementID;
@property (strong) NSString *title;
@property (strong) NSString *announcement;

- (id)initWithTitle:(NSString *)title announcementID:(int)announcementID announcement:(NSString *)announcement;
@end
