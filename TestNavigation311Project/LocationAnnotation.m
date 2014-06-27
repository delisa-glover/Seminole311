//
//  LocationAnnotation.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/8/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "LocationAnnotation.h"

@implementation LocationAnnotation

//@synthesize coordinate;
//@synthesize title = title_;
//@synthesize subtitle = subtitle_;
//@synthesize fullAddress = fullAddress_;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    _coordinate=coord;
    return self;
}


-(CLLocationCoordinate2D)coord
{
    return _coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate= newCoordinate;
}

@end
