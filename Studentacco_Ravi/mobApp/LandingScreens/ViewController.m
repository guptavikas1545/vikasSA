//
//  ViewController.m
//  mobApp
//
//  Created by MAG on 06/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//
//ravi
#import "ClTWebservice.h"
#import "ClTDeviceiInfoModel.h"
#import "HomeCollectionViewCell.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
//***//

#import "OuterCollectionViewCell.h"
#import "AboutUsCollectionViewCell.h"
#import "BannerCollectionViewCell.h"
#import "InnerCollectionViewCell.h"
#import "SelectCityViewController.h"
#import "ListAndMapViewController.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "PropertyDetail.h"
#import "AppDelegate.h"
#import "PropertyDetailAdaptor.h"
#import "FullPropertyDetailsViewController.h"
#import "ContactInfoViewController.h"
#import "ContactLandlordViewController.h"
@interface ViewController ()<OuterCollectionViewCellDelegate, UISearchBarDelegate, NSURLConnectionDelegate, SelectCityDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
{
    NSMutableArray *img;
    NSMutableArray *heading;
    NSMutableArray *filteredResult;
    NSMutableArray *tableData;
    NSMutableArray *autocompleteList;
    NSString *search;
    
    __weak IBOutlet UITableView *autocompleteTableView;
    __weak IBOutlet UIView *splashView;
    PropertyDetailAdaptor *property_List;
    NSMutableArray *brandedPropertyList;
    //__weak IBOutlet UILabel *cityLabel;
    
    ClTDeviceiInfoModel *tempDeviceModel;
    
    NSMutableArray *bigSavingModelsArray;
    NSMutableArray *brandedRoomsModelsArray;
    NSMutableArray *nearByPropertiesModelsArray;
    __weak IBOutlet NSLayoutConstraint *delhiLeadingConstraint;
    
    __weak IBOutlet NSLayoutConstraint *FaridabadLeadingConstaint;
    __weak IBOutlet NSLayoutConstraint *gurgoanLeadingConstraint;
    __weak IBOutlet NSLayoutConstraint *noidaLeadingCOnstraint;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     tempDeviceModel = [[ClTDeviceiInfoModel alloc]init];
       //     [self fetchPropertyListData];
    // Ravi
    bigSavingModelsArray = [[NSMutableArray alloc]init];
    brandedRoomsModelsArray = [[NSMutableArray alloc]init];
    nearByPropertiesModelsArray = [[NSMutableArray alloc]init];
    
        // Search Text Field
    _searchTextField.layer.cornerRadius = 22.0f;
    _searchTextField.placeholder = @"Search by Location";
    
    // ALert Button UI
    _createAlertButton.layer.cornerRadius = 15.0f;
    _createAlertButton.layer.borderWidth=1.0f;
    _createAlertButton.layer.borderColor=[UIColor blueColor].CGColor;
    
    [self getBigSavingDataFromAPI];
    [self getBrandedRoomsDataFromAPI];
    [self postNearByPropertyAPI];
    
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}


#pragma mark- All WebService Actions

- (void) fetchPropertyListData {
    
    PropertyDetailAdaptor *propertyDetailAdaptor = [[PropertyDetailAdaptor alloc]initWithFilterObject:nil withPageNumber:0 withRequestForURL:BrandedList_URL];
    [propertyDetailAdaptor fetchPropertyListData];
   }
#pragma mark - UIscrollView Delegate Method


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    autocompleteTableView.hidden=YES;
}

#pragma mark - NSNotification Callback




- (IBAction)showRightMenuPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

#pragma mark - UICollectionView Delegate and DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _brandedRoomsCollectionView) {
        return brandedRoomsModelsArray.count;
    }else if(collectionView == _bigSavingCollectionView){
        return bigSavingModelsArray.count;
    }else
        return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HomeCollectionViewCell";
    HomeCollectionViewCell *homeCell;
    homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (collectionView == _brandedRoomsCollectionView){
        homeCell.address1Label.text = [brandedRoomsModelsArray[indexPath.row] addressLocality];
        homeCell.address2Label.text = [brandedRoomsModelsArray[indexPath.row] addressCity];
        //homeCell.PropertyImage.image = [bigSavingModelsArray[indexPath.row] fullImagePath] ;
        homeCell.amountLabel.text = [NSString localizedStringWithFormat:@"₹%@",[brandedRoomsModelsArray[indexPath.row] rent]];
        
    }else if(collectionView == _bigSavingCollectionView){
        homeCell.address1Label.text = [bigSavingModelsArray[indexPath.row] addressLocality];
        homeCell.address2Label.text = [bigSavingModelsArray[indexPath.row] addressCity];
        //homeCell.PropertyImage.image = [bigSavingModelsArray[indexPath.row] fullImagePath] ;
        int discountedPrice = [[bigSavingModelsArray[indexPath.row] rent] doubleValue] - [[bigSavingModelsArray[indexPath.row] discountPrice] doubleValue];
        homeCell.amountLabel.text =   [NSString localizedStringWithFormat:@"₹%d", discountedPrice];
        homeCell.onwardsLabel.text = [NSString localizedStringWithFormat:@"₹%@",[bigSavingModelsArray[indexPath.row] rent]];
        [homeCell.onwardsLabel setFont:[UIFont systemFontOfSize:17]];
    }
    homeCell.layer.borderWidth=1.0f;
    [homeCell.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f].CGColor];
    return homeCell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 }



#pragma mark- UIColectionView header   and footer delegate method.

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return CGSizeZero;
    }else {
        CGSize headerViewSize = CGSizeMake(self.view.bounds.size.width, 30);
        return headerViewSize;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -  MapView delegate
-(void) addAnotationsOnMapView{
    
    MKCoordinateRegion region =  { {0.0, 0.0 }, { 0.0, 0.0 } };
    for (ClTDeviceiInfoModel *propertyDetail in nearByPropertiesModelsArray ) {
        CLLocationCoordinate2D coord;
        coord.latitude=[propertyDetail.gpsLattitude floatValue];
        coord.longitude=[propertyDetail.gpsLongitude floatValue];
        
        region.center=coord;
        region.center.latitude = [propertyDetail.gpsLattitude floatValue];
        region.center.longitude = [propertyDetail.gpsLongitude floatValue];
        region.span.longitudeDelta=0.03 ;
        region.span.latitudeDelta=0.03;
        NSString *titleStr = propertyDetail.addressLocality;
        MKPointAnnotation *mappin=[[MKPointAnnotation alloc]init];
        mappin.coordinate = coord;
        mappin.title = titleStr;
        [_locationsMapView addAnnotation:mappin];
    }
    [self.locationsMapView setRegion:region animated:YES];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"map-marker.png"];
//            pinView.calloutOffset = CGPointMake(0, 32);
//            
//            // Add a detail disclosure button to the callout.
//            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            pinView.rightCalloutAccessoryView = rightButton;
//            
//            // Add an image to the left callout.
//            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pizza_slice_32.png"]];
//            pinView.leftCalloutAccessoryView = iconView;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}


#pragma mark -  Web service calling API

-(void)getBrandedRoomsDataFromAPI{
    
    NSDictionary *infoParams=[[NSDictionary alloc]initWithObjectsAndKeys:@"xyz",@"device", nil];
    [[ClTWebservice sharedInstance] callWebserviceWithServiceIdentifier:kGetBrandedRooms params:[infoParams mutableCopy] requestType:kGet Oncompletion:^(NSMutableDictionary *response) {
        brandedRoomsModelsArray = (NSMutableArray *)[tempDeviceModel  fillDeviceInfoModel:response];
        [_brandedRoomsCollectionView reloadData];
    }OnFailure:^(NSError *error) {
    }nullResponse:^{
    }];
}



-(void)getBigSavingDataFromAPI{
    
    NSDictionary *infoParams=[[NSDictionary alloc]initWithObjectsAndKeys:@"xyz",@"device", nil];
    [[ClTWebservice sharedInstance] callWebserviceWithServiceIdentifier:kGetBigSaving params:[infoParams mutableCopy] requestType:kGet Oncompletion:^(NSMutableDictionary *response) {
        bigSavingModelsArray = (NSMutableArray *)[tempDeviceModel  fillPropertyModelForBigSaving:response];
        [_bigSavingCollectionView reloadData];
    }OnFailure:^(NSError *error) {
    }nullResponse:^{
    }];
}

-(void)postNearByPropertyAPI{
    NSDictionary *infoParams=[[NSDictionary alloc]initWithObjectsAndKeys:@"28.5297716",@"latitude", @"77.2784979",@"longitude", nil];
    [[ClTWebservice sharedInstance] callWebserviceWithServiceIdentifier:kPostNearByProperty params:[infoParams mutableCopy] requestType:kPost Oncompletion:^(NSMutableDictionary *response) {
        nearByPropertiesModelsArray = (NSMutableArray *)[tempDeviceModel  fillPropertyModelNearByProperty:response];
        [self addAnotationsOnMapView];
    }OnFailure:^(NSError *error) {
    }nullResponse:^{
    }];
}



@end
