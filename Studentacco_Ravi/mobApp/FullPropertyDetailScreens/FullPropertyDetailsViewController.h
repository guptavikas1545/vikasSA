//
//  PropertyDetailsViewController.h
//  mobApp
//
//  Created by MAG on 15/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "WishListDetail.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
@interface FullPropertyDetailsViewController : UIViewController<NSURLConnectionDelegate,MKMapViewDelegate,UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *propertyDetailTableView;

@property (nonatomic, strong)WishListDetail *propertyDetail;
@property (weak, nonatomic) IBOutlet UIButton *wishButton;
@property (strong, nonatomic) NSMutableArray *wishListArray;
@property (weak, nonatomic) IBOutlet UILabel *propertyName;
@property (weak, nonatomic) IBOutlet UIButton *rentButton;
@property (weak, nonatomic) IBOutlet UIView *imageGalleryView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageGalleryScrollView;
@end
