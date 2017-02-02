//
//  CustomAnnotation.h
//  StudentAcco
//
//  Created by MAG  on 7/6/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WishListDetail.h"

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *image;
@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, copy, readonly) NSString *propertyImageView;
@property (nonatomic, strong)WishListDetail *propertyDetail;


-(id)initWithCoordinates:(CLLocationCoordinate2D) paramCoordinates
                   image:(NSString *) paramImage
               withTitle:(NSString *) titlevalue
            withProperty:(WishListDetail *)property
       withPropertyImage:(NSString *) propertyImage;

@end
