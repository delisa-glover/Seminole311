//
//  LocationAnnotation.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/8/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationAnnotation : NSObject <MKAnnotation>
    
    //CLLocationCoordinate2D coordinate;
    //NSString *title_;
    //NSString *subtitle_;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
//@property (strong) NSString *fullAddress;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
