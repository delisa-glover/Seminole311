//
//  LocationViewController.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/7/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@interface LocationViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id delegate;
@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property NSString *locationValue;
@property NSString *subCategoryName;

- (IBAction)doneTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;

@end
