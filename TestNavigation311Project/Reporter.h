//
//  Reporter.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 3/29/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reporter : NSObject

@property (strong) NSString *fullName;
@property (strong) NSString *address;
@property (strong) NSString *address2;
@property (strong) NSString *city;
@property (strong) NSString *state;
@property (strong) NSString *zipCode;
@property (strong) NSString *emailAddress;
@property (strong) NSString *phoneNumber;
@property (strong) NSString *deviceID;

- (id)initWithFullname:(NSString *)fullName address:(NSString *)address address2:(NSString *)address2 city:(NSString *)city state:(NSString *)state zipCode:(NSString *)zipCode emailAddress:(NSString *)emailAddress phoneNumber:(NSString *)phoneNumber deviceID:(NSString *)deviceID;

- (void)loadFromSandbox;
- (void)saveToSandbox;
@end
