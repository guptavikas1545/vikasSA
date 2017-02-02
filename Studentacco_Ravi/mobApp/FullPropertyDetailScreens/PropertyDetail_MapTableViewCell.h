//
//  PropertyDetail_MapTableViewCell.h
//  StudentAcco
//
//  Created by MAG on 20/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
@interface PropertyDetail_MapTableViewCell : UITableViewCell<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *propertyDetailMapView;
@property (nonatomic, strong)NSString *imgName;
- (void)loadMapData:(CLLocationCoordinate2D) coordinate;
@end
