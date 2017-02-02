//
//  ViewController.h
//  mobApp
//
//  Created by MAG on 06/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "WishListDetail.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UICollectionView *outerCollectionView;
//@property(nonatomic,retain) NSString *localityAddress;
- (IBAction)landingPageMenu:(id)sender;
- (IBAction)selectCityButton:(id)sender;
//@property(weak, nonatomic)brandedPropertyList;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property(strong,nonatomic)NSString *selectedCity;
@property (nonatomic, strong)WishListDetail *propertyDetail;


// Ravi

@property (weak, nonatomic) IBOutlet UICollectionView *brandedRoomsCollectionView;


@property (weak, nonatomic) IBOutlet UICollectionView *popularApartmentCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *bigSavingCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *livinCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *createAlertButton;

@property (weak, nonatomic) IBOutlet MKMapView *locationsMapView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;



@end

