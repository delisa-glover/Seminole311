//
//  Reporter.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 3/29/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "Reporter.h"

@implementation Reporter

- (id)initWithFullname:(NSString *)fullName address:(NSString *)address address2:(NSString *)address2 city:(NSString *)city state:(NSString *)state zipCode:(NSString *)zipCode emailAddress:(NSString *)emailAddress phoneNumber:(NSString *)phoneNumber deviceID:(NSString *)deviceID{
    if ((self = [super init])) {
        self.fullName = fullName;
        self.address = address;
        self.address2 = address2;
        self.city = city;
        self.state = state;
        self.zipCode = zipCode;
        self.emailAddress = emailAddress;
        self.phoneNumber = phoneNumber;
        self.deviceID = deviceID;    }
    return self;
}

- (NSString *)appDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)pListName
{
    //NSLog(@"reading file at path: %@", [self appDocumentsDirectory]);
    return [[self appDocumentsDirectory] stringByAppendingPathComponent:
            @"Semcty311Reporter.plist"];
}

- (void)loadFromSandbox
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[self pListName]];
    if (array != nil && [array count] > 3) //load base information if present
    {
        [self setFullName:[array objectAtIndex:0]];
        [self setEmailAddress:[array objectAtIndex:1]];
        [self setPhoneNumber:[array objectAtIndex:2]];
        [self setDeviceID:[array objectAtIndex:3]];
    }
    if (array != nil && [array count] > 8) //load address if present
    {
        [self setAddress:[array objectAtIndex:4]];
        [self setAddress2:[array objectAtIndex:5]];
        [self setCity:[array objectAtIndex:6]];
        [self setState:[array objectAtIndex:7]];
        [self setZipCode:[array objectAtIndex:8]];
        
    }
}

- (void)saveToSandbox
{
    NSArray *array = [NSArray arrayWithObjects:
                      [self fullName],
                      [self emailAddress],
                      [self phoneNumber],
                      [self deviceID],
                      [self address],
                      [self address2],
                      [self city],
                      [self state],
                      [self zipCode],
                      nil];
    [array writeToFile:[self pListName] atomically:YES];
    NSLog(@"Writing reporter to file: %@", [self pListName]);
}

@end
