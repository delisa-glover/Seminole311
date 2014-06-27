//
//  UserAddressViewController.m
//  Seminole 311
//
//  Created by DeLisa Glover on 10/8/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "UserAddressViewController.h"
#import "LocationAnnotation.h"
#import "CreateAccountViewController.h"
#import "UpdateAccountViewController.h"
#import "SVProgressHUD.h"
#import "Reachability.h"



@interface UserAddressViewController ()

@end

@implementation UserAddressViewController

Reachability *networkReachability;
NetworkStatus networkStatus;
bool userLocated;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.locationMapView.delegate = self;
    self.locationTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    userLocated = NO;
    
    if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        
        if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            __block LocationAnnotation *annotation;
            __block NSString *defaultLocation = @"1101 E 1st St Sanford";
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:defaultLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                //Error checking
                
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                
                if (placemark != nil)
                {
                    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 800, 800);
                    [self.locationMapView setRegion:[self.locationMapView regionThatFits:region] animated:YES];
                    
                    if (!_locationMapView.annotations.count || _locationMapView.annotations.count == 0)
                    {
                        annotation = [[LocationAnnotation alloc] initWithCoordinate:placemark.location.coordinate];
                        [self.locationMapView addAnnotation:annotation];
                    }
                    else
                    {
                        annotation = (LocationAnnotation *)[_locationMapView.annotations objectAtIndex: 0];
                        if (annotation != nil)
                        {
                            if ([annotation isKindOfClass:[MKUserLocation class]])
                            {
                                annotation = [[LocationAnnotation alloc] initWithCoordinate:placemark.location.coordinate];
                                [self.locationMapView addAnnotation:annotation];
                            }
                            annotation.coordinate = placemark.location.coordinate;
                        }
                    }
                    
                    if (annotation != nil)
                    {
                        annotation.title = @"My Address";
                        
                        annotation.subtitle = [NSString stringWithFormat:@"%@ %@, %@, %@, %@", [placemark subThoroughfare], [placemark thoroughfare], [placemark locality], [placemark administrativeArea], [placemark postalCode]];
                        
                        [self.locationMapView selectAnnotation:annotation animated:YES];
                        
                        
                    }
                }
            }];
        }
    }
    
    
}

- (IBAction)doneTapped:(id)sender
{
    [self.locationTextField resignFirstResponder];
    
    //return the annotation that is not the user location annotation
    for(LocationAnnotation *annotation in _locationMapView.annotations)
    {
        if (![annotation isKindOfClass:[MKUserLocation class]])
        {
            [self.delegate setLocation:annotation];
            break;
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    LocationAnnotation *annotation;
    
    if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else if (userLocated == NO)
    {
        userLocated = YES;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
        [self.locationMapView setRegion:[self.locationMapView regionThatFits:region] animated:YES];
        
        // Add only one annotation, reuse this one for subsequent locations
        if (!_locationMapView.annotations.count || _locationMapView.annotations.count == 0)
        {
            annotation = [[LocationAnnotation alloc] initWithCoordinate:userLocation.coordinate];
            [self.locationMapView addAnnotation:annotation];
        }
        else
        {
            annotation = (LocationAnnotation *)[_locationMapView.annotations objectAtIndex: 0];
            
            if (annotation != nil)
            {
                //if current annotation is for current location, make another one for the draggable pin
                if ([annotation isKindOfClass:[MKUserLocation class]])
                {
                    annotation = [[LocationAnnotation alloc] initWithCoordinate:userLocation.coordinate];
                    [self.locationMapView addAnnotation:annotation];
                }
                annotation.coordinate = userLocation.coordinate;
            }
        }
        
        if (annotation != nil)
        {
            annotation.title = @"My Address";
            
            //initialize with latitude, longitude
            annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            
            __block NSString *address;
            
            //get address of the point, if possible
            [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 
                 if (placemark != nil)
                     address = [NSString stringWithFormat:@"%@ %@, %@, %@, %@", [placemark subThoroughfare], [placemark thoroughfare], [placemark locality], [placemark administrativeArea], [placemark postalCode]];
                 
                 annotation.subtitle = address;
                 
             }];
            
            [self.locationMapView selectAnnotation:annotation animated:YES];
        }
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"pin";
    MKPinAnnotationView *pav = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    
    if (pav == nil)
    {
        pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        
    }
    else
    {
        pav.annotation = annotation;
    }
    pav.draggable = YES;
    pav.animatesDrop = YES;
    pav.selected = YES;
    pav.canShowCallout = YES;
    pav.enabled = YES;
    
    return pav;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        if (newState == MKAnnotationViewDragStateEnding) {
            
            LocationAnnotation *annotation = (LocationAnnotation *)annotationView.annotation;
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            
            __block NSString *address;
            
            [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 
                 if (placemark != nil){
                     address = [NSString stringWithFormat:@"%@ %@, %@, %@, %@", [placemark subThoroughfare], [placemark thoroughfare], [placemark locality], [placemark administrativeArea], [placemark postalCode]];
                     
                     annotation.subtitle = address;
                     
                 }
                 
             }];
            
        }
    }
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"Map Failed to Load"];
    NSLog(@"%@", error.localizedDescription);
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    __block LocationAnnotation *annotation;
    if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        if (theTextField == self.locationTextField) {
            [theTextField resignFirstResponder];
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:self.locationTextField.text completionHandler:^(NSArray *placemarks, NSError *error) {
                //Error checking
                
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                
                if (placemark != nil)
                {
                    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 800, 800);
                    [self.locationMapView setRegion:[self.locationMapView regionThatFits:region] animated:YES];
                    
                    if (!_locationMapView.annotations.count || _locationMapView.annotations.count == 0)
                    {
                        annotation = [[LocationAnnotation alloc] initWithCoordinate:placemark.location.coordinate];
                        [self.locationMapView addAnnotation:annotation];
                    }
                    else
                    {
                        annotation = (LocationAnnotation *)[_locationMapView.annotations objectAtIndex: 0];
                        if (annotation != nil)
                        {
                            if ([annotation isKindOfClass:[MKUserLocation class]])
                            {
                                annotation = [[LocationAnnotation alloc] initWithCoordinate:placemark.location.coordinate];
                                [self.locationMapView addAnnotation:annotation];
                            }
                            annotation.coordinate = placemark.location.coordinate;
                        }
                    }
                    
                    if (annotation != nil)
                    {
                        annotation.title = @"My Address";
                        
                        annotation.subtitle = [NSString stringWithFormat:@"%@ %@, %@, %@, %@", [placemark subThoroughfare], [placemark thoroughfare], [placemark locality], [placemark administrativeArea], [placemark postalCode]];
                        
                        
                        [self.locationMapView selectAnnotation:annotation animated:YES];
                        
                        theTextField.text =@"";
                    }
                }
            }];
        }
        
    }
    return YES;
}


@end
