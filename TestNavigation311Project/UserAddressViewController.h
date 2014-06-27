//
//  UserAddressViewController.h
//  Seminole 311
//
//  Created by DeLisa Glover on 10/8/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@interface UserAddressViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id delegate;
@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property NSString *locationValue;

- (IBAction)doneTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;


@end
