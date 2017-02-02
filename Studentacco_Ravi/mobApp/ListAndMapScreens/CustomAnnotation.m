//
//  CustomAnnotation.m
//  StudentAcco
//
//  Created by MAG  on 7/6/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

-(id)initWithCoordinates:(CLLocationCoordinate2D) paramCoordinates
                   image:(NSString *) paramImage
               withTitle:(NSString *) titlevalue
            withProperty:(WishListDetail *)property
       withPropertyImage:(NSString *) propertyImage
{
    self = [super init];
    if(self != nil)
    {
        _coordinate = paramCoordinates;
        _image = paramImage;
        _title = titlevalue;
        _propertyDetail = property;
        _propertyImageView = propertyImage;
    }
    return (self);
}

@end
