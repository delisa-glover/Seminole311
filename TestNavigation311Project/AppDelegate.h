//
//  AppDelegate.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 2/27/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reporter.h"
#import "LocalDataStorage.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Reporter *itemReporter;
@end
