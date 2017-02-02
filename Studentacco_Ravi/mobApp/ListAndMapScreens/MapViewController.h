//
//  MapViewController.h
//  mobApp
//
//  Created by MAG on 14/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "FilterSelectionDetail.h"

@interface MapViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Gender_select;

@property (strong, nonatomic) FilterSelectionDetail *filterData;

@end
