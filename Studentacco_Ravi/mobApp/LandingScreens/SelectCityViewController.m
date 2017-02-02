//
//  SelectCityViewController.m
//  mobApp
//
//  Created by MAG  on 6/9/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "SelectCityViewController.h"
#import "SelectCityTableViewCell.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "ViewController.h"

@interface SelectCityViewController ()<CLLocationManagerDelegate>
{
    __weak IBOutlet UITableView *cityListTableView;
    NSMutableArray *popularCities, *allCities;
}
@end

@implementation SelectCityViewController
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSMutableString *longitude,*latitude;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    popularCities=[NSMutableArray arrayWithObjects:@"New Delhi",@"Gurgaon",@"Noida",@"Faridabad", nil];
    [cityListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    [cityListTableView registerNib:[UINib nibWithNibName:@"SelectCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"selectCityCustomCell"];
     locationManager = [[CLLocationManager alloc] init];
     geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate=self;
    
}

- (IBAction)dismissSelectCityView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    
    numberOfRows = popularCities.count;
    
    return numberOfRows;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewForHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    viewForHeader.backgroundColor = [UIColor colorWithRed:65/255.0 green:59/255.0 blue:60/255.0 alpha:1.0f];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font=[UIFont fontWithName:@"CircularStd-Book" size:15];
    titleLabel.text = @"ALL CITIES";
    
    [viewForHeader addSubview:titleLabel];
    
    return viewForHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier1 = @"cellIdentifier";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
    
    cell.textLabel.text=popularCities[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:93/255.0 green:87/255.0 blue:85/255.0 alpha:1.0f]];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    cityListTableView.separatorColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate fetchSelectedCity:popularCities[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)getCurrentLocation:(id)sender {
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    [self dismissViewControllerAnimated:YES completion:nil];
  
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error !" message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        longitude = [NSMutableString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        latitude = [NSMutableString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks firstObject];
            _address = [NSMutableString stringWithFormat:@"%@",placemark.locality];
           
            [self.delegate fetchSelectedCity:_address];
            [locationManager stopUpdatingLocation];
            [self dismissViewControllerAnimated:YES completion:nil];

            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
