//
//  MapViewController.m
//  mobApp
//
//  Created by MAG on 14/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "MapViewController.h"
#import "FilterViewController.h"
#import "AppConstants.h"
#import "WishListDetail.h"
#import "CustomAnnotation.h"
#import "FullPropertyDetailsViewController.h"
#import "AppDelegate.h"
#import "PropertyDetailAdaptor.h"

extern NSInteger totalPropertyCount;
extern NSString *requestURLFrom;

@interface MapViewController ()
{
    NSInteger totalResult;
    __weak IBOutlet UILabel *totalCountLabel;
    __weak IBOutlet UISegmentedControl *genderSelectionSegment;
    
    NSMutableArray *arrayAfterGenderSelection;
    
    WishListDetail *selectedProperty;
    
    NSMutableArray *filteredPropertyList;
    __weak IBOutlet NSLayoutConstraint *ratioLayoutConstraint;
}
@end

@implementation MapViewController
@synthesize mapView,Gender_select;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ratioLayoutConstraint.constant = [UIScreen mainScreen].bounds.size.width == 320.0f ? 22.0f : 0.0f;
    
    self.mapView.delegate = self;
    CGRect frame= Gender_select.frame;
    
    totalResult = totalPropertyCount;
    
    requestURLFrom = MapProperty_URL;
    
    [Gender_select setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 100.0)];
    
//    genderSelectionSegment.selectedSegmentIndex = 1;
    filteredPropertyList = [[NSMutableArray alloc]init];
    arrayAfterGenderSelection = [NSMutableArray array];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    [self fetchPropertyListData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateMapView:)
                                                name:FilterNotificationForMap
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(failureResponseHandle:)
                                                name:FailureNotificationForMap
                                              object:nil];
       arrayAfterGenderSelection = filteredPropertyList;
   
    for (int i=0; i<_filterData.genderSelectionArray.count; i++) {
        if ([_filterData.genderSelectionArray[i] isEqualToString:@"Male"]) {
            Gender_select.selectedSegmentIndex = 0;
        }
        else if ([_filterData.genderSelectionArray[i] isEqualToString:@"Female"])
        {
            Gender_select.selectedSegmentIndex = 2;
        }
        else
        {
            Gender_select.selectedSegmentIndex = 1;
        }
            
    }
    
    [self dropPins];

}

#pragma mark- All WebService Actions

- (void) fetchPropertyListData {
    PropertyDetailAdaptor *propertyDetailAdaptor = [[PropertyDetailAdaptor alloc]initWithFilterObject:_filterData withPageNumber:0 withRequestForURL:MapProperty_URL];
    [propertyDetailAdaptor fetchPropertyListData];
}


#pragma mark - NSNotification Callback

- (void)updateMapView:(NSNotification*) notification {
    
    NSArray *tempArray = (NSArray*) notification.object;
    
    [filteredPropertyList removeAllObjects];
    [arrayAfterGenderSelection removeAllObjects];
    
       [filteredPropertyList addObjectsFromArray:tempArray[0]];
    arrayAfterGenderSelection = filteredPropertyList;

    totalResult = [tempArray[1] integerValue];
    
    [self dropPins];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
}

- (void)failureResponseHandle:(NSNotification*) notification {
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    
    NSError *error =  (NSError *)notification.object;
    NSString *strErrorMsg = [error localizedDescription];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error !" message:strErrorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dropPins {
    
    if ([_filterData.search_key length]==0) {
         totalCountLabel.text = [NSString stringWithFormat:@"%ld places found in %@",(long)arrayAfterGenderSelection.count, _filterData.search_city];
    }
    else{
    totalCountLabel.text = [NSString stringWithFormat:@"%ld places found in %@",(long)arrayAfterGenderSelection.count, _filterData.search_key];
    }
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayAfterGenderSelection.count; i++) {
        WishListDetail *propertyDetail = arrayAfterGenderSelection[i];
        NSString *img;
        if ([propertyDetail.mark_as_branded isEqualToString:@"1"]) {
            
            img = @"map-view-branded";
        }
        else
        {
           
            img =@"map-pin.png";
        }
                CLLocationCoordinate2D location1 = CLLocationCoordinate2DMake([propertyDetail.gps_lattitude floatValue], [propertyDetail.gps_longitude floatValue]);
        NSMutableString *price = [NSMutableString string];
        [price appendString:[NSString stringWithFormat:@"%@",propertyDetail.property_name]];
        [price appendString:[NSString stringWithFormat:@" %@ onwards",propertyDetail.rent]];
        CustomAnnotation *annotation1 = [[CustomAnnotation alloc] initWithCoordinates:location1 image: img withTitle:price
                                                                         withProperty:propertyDetail withPropertyImage:propertyDetail.imagename];
    
        [annotationArray addObject:annotation1];
    }
    [self.mapView addAnnotations:annotationArray];
    
    if (arrayAfterGenderSelection.count) {
        WishListDetail *propertyDetail = arrayAfterGenderSelection[0];
        MKCoordinateRegion region =  { {0.0, 0.0 }, { 0.0, 0.0 } };
        region.center.latitude = [propertyDetail.gps_lattitude floatValue];
        region.center.longitude = [propertyDetail.gps_longitude floatValue];
        region.span.longitudeDelta = 0.03;
        region.span.latitudeDelta = 0.03;
        [self.mapView setRegion:region animated:YES];
        
        [self.mapView setZoomEnabled:YES];
    }
}

#pragma mark - MKMapView Delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 900, 900);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"My Location";
    
    [self.mapView addAnnotation:point];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    
    if ([annotation isKindOfClass:[CustomAnnotation class]])
    {
        MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else
        {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        CustomAnnotation *customAnnot = (CustomAnnotation*)annotation;
        annotationView.image = [UIImage imageNamed:customAnnot.image];
        
        // Because this is an iOS app, add the detail disclosure button to display details about the annotation in another view.
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [rightButton addTarget:self action:@selector(moveToFullProperty:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = rightButton;
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",customAnnot.propertyImageView]];
        // Add a custom image to the left side of the callout.
        UIImageView *myCustomImage = [[UIImageView alloc] init];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        myCustomImage.image = image;
                    });
                }
            }
        }];
        [task resume];
        
        annotationView.leftCalloutAccessoryView = myCustomImage;
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    CustomAnnotation *customAnnot = (CustomAnnotation*)view.annotation;
    
    FullPropertyDetailsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"FullPropertyDetailsViewControllerID"];
    obj.propertyDetail = customAnnot.propertyDetail;
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)moveToFullProperty:(WishListDetail*)property {
    FullPropertyDetailsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"FullPropertyDetailsViewControllerID"];
    obj.propertyDetail = property;
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)genderSelection:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            //"facility_available_for" = "For Boys Only"
        {
            NSArray *filtered1 = [filteredPropertyList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(facility_available_for == %@)", @"For Boys Only"]];
            arrayAfterGenderSelection = filtered1.mutableCopy;
        }
            break;
        case 1:
            //
            arrayAfterGenderSelection = filteredPropertyList;
            break;
        case 2:
            //"facility_available_for" = "For Girls Only"
        {
            NSArray *filtered1 = [filteredPropertyList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(facility_available_for == %@)", @"For Girls Only"]];
            arrayAfterGenderSelection = filtered1.mutableCopy;
        }            break;
            
        default:
            break;
    }
    [self dropPins];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
