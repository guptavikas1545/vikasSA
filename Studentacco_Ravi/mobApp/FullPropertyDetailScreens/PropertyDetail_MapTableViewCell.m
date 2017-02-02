//
//  PropertyDetail_MapTableViewCell.m
//  StudentAcco
//
//  Created by MAG on 20/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "PropertyDetail_MapTableViewCell.h"
#import "CalloutMapAnnotation.h"

@implementation PropertyDetail_MapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    _propertyDetailMapView.delegate = self;
}

- (void)loadMapData:(CLLocationCoordinate2D) coordinate {
    CalloutMapAnnotation *pointAnnot = [[CalloutMapAnnotation alloc] initWithLatitude:coordinate.latitude andLongitude:coordinate.longitude withImage:[UIImage imageNamed:_imgName]];
    //Drop pin on map
    [_propertyDetailMapView addAnnotation:pointAnnot];
    
    MKCoordinateRegion adjustedRegion = [_propertyDetailMapView regionThatFits:MKCoordinateRegionMakeWithDistance(coordinate, 600 , 600)];
    [_propertyDetailMapView setRegion:adjustedRegion animated:YES];
}

#pragma mark - MKMapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    CalloutMapAnnotation *pointAnnot = (CalloutMapAnnotation*)annotation;
    MKAnnotationView *pinAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinIdentifier"];
    pinAnnotationView.image = pointAnnot.image;
    
    return pinAnnotationView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
