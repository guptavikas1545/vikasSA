//
//  WishListViewController.m
//  StudentAcco
//
//  Created by MAG on 12/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "WishListViewController.h"
#import "PropertyDetailCollectionViewCell.h"
#import "FullPropertyDetailsViewController.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "WishListDetail.h"
#import "UserDetail.h"
#import "PropertyDetailAdaptor.h"
#import "ContactInfoViewController.h"
#import "ContactLandlordViewController.h"
#import "AppDelegate.h"
#import "WishListDetail.h"
#import "PropertyDetail.h"
#import "OuterCollectionViewCell.h"
@interface WishListViewController ()
{
    //  NSMutableArray *globalWishListArray;
    UserDetail *userDetail;
    WishListDetail *wishListDetail;
    NSInteger pageNumber;
    PropertyDetail *p_detail;
    NSString *requestFor;
    NSInteger totalResult;
    NSString *isRemoved;
    
    NSIndexPath *deletedIndexPath;
    
    NSArray *amenitiesImageArray;
    NSArray *amenitiesArray;
    
    NSMutableArray *wishData;
    
}
@end

@implementation WishListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_wishListCollectionView registerNib:[UINib nibWithNibName:@"PropertyDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"propertyDetailCollectionCell"];
    
    amenitiesArray = @[@"Attached toilet", @"AC", @"Cupboard", @"Fridge", @"Bedding", @"Table/Chair", @"Geyser", @"TV"];
    amenitiesImageArray = @[@"toilet-icon", @"ac-icon", @"cupboard-icon", @"fridge-icon", @"bedding-icon", @"chair-icon", @"geyser-icon", @"tv-icon"];
    
    _globalWishListArray = [[NSMutableArray alloc]init];
    wishData = [[NSMutableArray alloc]init];
    isRemoved = @"NO";
    pageNumber = 0;
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
        userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
         [self fetchWishListData];
        
        
  }
   else
   {
       if([[NSUserDefaults standardUserDefaults]objectForKey:@"PropertyDetail"]) {
           NSData *wishListData = [[NSUserDefaults standardUserDefaults] dataForKey:@"PropertyDetail"];
           wishData  = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:wishListData];
           [_globalWishListArray addObjectsFromArray:wishData];
           for (int i=0; i<_globalWishListArray.count; i++) {
               p_detail=_globalWishListArray[i];
           }
           
       }
      

   }

}
-(void)addData
{
if([[NSUserDefaults standardUserDefaults]objectForKey:@"PropertyDetail"]) {
    NSData *wishListData = [[NSUserDefaults standardUserDefaults] dataForKey:@"PropertyDetail"];
    wishData  = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:wishListData];
    BOOL select;
    for (int i=0; i<wishData.count; i++)
    {
        select=YES;
        WishListDetail *wish = wishData[i];
        
        for(int j= 0; j< _globalWishListArray.count; j++)
        {
        WishListDetail *propertyDetail= _globalWishListArray[j];
            
            if ([wish.propertyid isEqualToString:propertyDetail.propertyid])
            {
                select=YES;
            break;
                
            }
            else
            {
                select= NO;
            }
           
        }
        if (select==NO)
        {
            [_globalWishListArray addObject:wish];
            NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,Add_To_WishList_URL];
            NSString *jsonRequest = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"property_id\":\"%@\"}",userDetail.userid,wish.propertyid];
            NSLog(@"%@",jsonRequest);
            requestFor = Add_To_WishList_URL;
            URLConnection *connection=[[URLConnection alloc] init];
            connection.delegate=self;
            [connection getDataFromUrl:jsonRequest webService:urlString];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PropertyDetail"];
        }
       
    }
    
    }
    [_wishListCollectionView reloadData];
//[self fetchWishListData];

}



#pragma mark- All WebService Actions

- (void) fetchWishListData {

    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,WishList_URL];
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"user_id\":\"%@\"}",userDetail.userid];
     NSLog(@"%@",jsonRequest);
    requestFor = WishList_URL;
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];

}

- (void)removeFromWishList:(id)sender {

    UIButton *wishButton = (UIButton *)sender;
    PropertyDetailCollectionViewCell *cell = (PropertyDetailCollectionViewCell *) wishButton.superview.superview;
    NSIndexPath *indexPath = [_wishListCollectionView indexPathForCell:cell];

    deletedIndexPath = indexPath;
    WishListDetail *propertyDetail = _globalWishListArray[indexPath.item];
//
//    if ([propertyDetail.shortlist_property_id isEqualToString:@""]) {
//        propertyDetail.shortlist_property_id = propertyDetail.propertyid;
//    }
//    else {
//        propertyDetail.shortlist_property_id = @"";
//    }
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"])
    {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];

    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,Add_To_WishList_URL];

    NSString *jsonRequest = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"property_id\":\"%@\"}",userDetail.userid, propertyDetail.propertyid];

    requestFor = Add_To_WishList_URL;
    isRemoved = @"YES";
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];
    }
    else
    {
        [_globalWishListArray removeObjectAtIndex:deletedIndexPath.item];
        NSData *propertyEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:_globalWishListArray];
        [[NSUserDefaults standardUserDefaults] setObject:propertyEncodedObject forKey:@"PropertyDetail"];
        [_wishListCollectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UIColectionView header   and footer delegate method.

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(self.view.bounds.size.width, 373);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerViewSize = CGSizeMake(self.view.bounds.size.width, 50);
    return headerViewSize;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [_wishListCollectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"headerID" forIndexPath: indexPath];
        
        [[header subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;

        UIImageView *starImage = [[UIImageView alloc] initWithFrame: CGRectMake(width/2-70, 15, 19, 19)];
        starImage.image=[UIImage imageNamed:@"map-marker.png"];
        [header addSubview: starImage];
        
        UIFont *labFont = [UIFont fontWithName: @"CircularStd-Medium" size: 16.0];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake((width/2-70)+22, 11, 260, 25)];
        headerLabel.textColor=[UIColor darkGrayColor];
        [headerLabel setFont: labFont];
        
        headerLabel.text = [NSString stringWithFormat:@"%lu places found",(unsigned long)_globalWishListArray.count ];
        [header addSubview: headerLabel];
        return header;
    }
    else {
        
        UICollectionReusableView *footer = [_wishListCollectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionFooter withReuseIdentifier: @"footerID" forIndexPath: indexPath];
        return footer;
    }
}

#pragma mark - UICollectionView Delegate and DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _globalWishListArray.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"propertyDetailCollectionCell";
    
    PropertyDetailCollectionViewCell *cell = (PropertyDetailCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    WishListDetail *propertyDetail = _globalWishListArray[indexPath.item];
     
    NSMutableString *propertyAddress = [NSMutableString string];
    if (propertyDetail.address_locality.length > 0) {
        [propertyAddress appendString:[NSString stringWithFormat:@"%@,",propertyDetail.address_locality]];
    }
    if (propertyDetail.address_street.length > 0) {
        [propertyAddress appendString:[NSString stringWithFormat:@" %@,",propertyDetail.address_street]];
    }
    if (propertyDetail.address_city.length > 0) {
        [propertyAddress appendString:[NSString stringWithFormat:@" %@,",propertyDetail.address_city]];
    }
    if (propertyDetail.address_state.length > 0) {
        [propertyAddress appendString:[NSString stringWithFormat:@" %@,",propertyDetail.address_state]];
    }
    if (propertyDetail.address_country.length > 0) {
        [propertyAddress appendString:[NSString stringWithFormat:@" %@",propertyDetail.address_country]];
    }
    
    cell.propertyAddress.text=propertyAddress;
    cell.propertyName.text = propertyDetail.property_name;
    cell.rentLabel.text=propertyDetail.rent;
    cell.wishButton.selected = YES;
//    if ([propertyDetail.shortlist_property_id isEqualToString:propertyDetail.propertyid]) {
//        cell.wishButton.selected = YES;
//    }
    [cell.wishButton addTarget:self
                        action:@selector(removeFromWishList:)
              forControlEvents:UIControlEventTouchUpInside];
    // Color type
    UIColor *lightColor = [UIColor lightGrayColor];
    UIColor *darkColor = [UIColor blackColor];
    // for breakfast lunch dinner
    cell.breakfastLabel.textColor = [propertyDetail.breakfast boolValue] ? darkColor: lightColor;
    cell.lunchLabel.textColor = [propertyDetail.lunch boolValue] ? darkColor: lightColor;
    cell.dinnerLabel.textColor = [propertyDetail.dinner boolValue] ? darkColor: lightColor;
    
    // for occupancy
    cell.singleOccupancy.textColor = [propertyDetail.occupancy containsObject:@"1"] ? darkColor: lightColor;
    cell.doubleOccupancy.textColor = [propertyDetail.occupancy containsObject:@"2"] ? darkColor: lightColor;
    cell.tripleOccupancy.textColor = [propertyDetail.occupancy containsObject:@"3"] ? darkColor: lightColor;
    cell.dormOccupancy.textColor = [propertyDetail.occupancy containsObject:@"4"] ? darkColor: lightColor;
    
    //for Amenities
    cell.firstAmenities.hidden = (propertyDetail.facility.count > 0)? NO: YES;
    cell.secondAmenities.hidden = (propertyDetail.facility.count > 1)? NO: YES;
    cell.thirdAmenities.hidden = (propertyDetail.facility.count > 2)? NO: YES;
    
    cell.firstAmenitiesImage.hidden = (propertyDetail.facility.count > 0)? NO: YES;
    cell.secondAmenitiesImage.hidden = (propertyDetail.facility.count > 1)? NO: YES;
    cell.thirdAmenitiesImage.hidden = (propertyDetail.facility.count > 2)? NO: YES;
    
    if ((propertyDetail.facility.count > 0)) {
        cell.firstAmenities.text = propertyDetail.facility[0];
        NSInteger indexValue = [amenitiesArray indexOfObject:propertyDetail.facility[0]];
        cell.firstAmenitiesImage.image = [UIImage imageNamed:amenitiesImageArray[indexValue]];
    }
    if (propertyDetail.facility.count > 1) {
        cell.secondAmenities.text = propertyDetail.facility[1];
        NSInteger indexValue = [amenitiesArray indexOfObject:propertyDetail.facility[1]];
        cell.secondAmenitiesImage.image = [UIImage imageNamed:amenitiesImageArray[indexValue]];
    }
    if (propertyDetail.facility.count > 2) {
        cell.thirdAmenities.text = propertyDetail.facility[2];
        NSInteger indexValue = [amenitiesArray indexOfObject:propertyDetail.facility[2]];
        cell.thirdAmenitiesImage.image = [UIImage imageNamed:amenitiesImageArray[indexValue]];
    }
    
    //for Breakfast lunch dinner
    cell.breakfastLabel.textColor = [propertyDetail.breakfast isEqualToString:@"1"] ? darkColor: lightColor;
    cell.lunchLabel.textColor = [propertyDetail.lunch isEqualToString:@"1"] ? darkColor: lightColor;
    cell.dinnerLabel.textColor = [propertyDetail.dinner isEqualToString:@"1"] ? darkColor: lightColor;
    
    
    // for async image loading
    cell.activityLoader.hidden=NO;
    cell.propertyImageView.image = nil;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",propertyDetail.imagename]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    PropertyDetailCollectionViewCell *updateCell = (id)[_wishListCollectionView cellForItemAtIndexPath:indexPath];
                    updateCell.activityLoader.hidden=YES;
                    if (updateCell)
                        updateCell.propertyImageView.image = image;
                    
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
                    
                });
            }
        }
    }];
    [task resume];
    
    // call to manager
    [cell.callOwnerButton addTarget:self
                             action:@selector(callOwner:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    // load more functionality
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    return cell;
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WishListDetail *propertyDetail = _globalWishListArray[indexPath.item];
    FullPropertyDetailsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"FullPropertyDetailsViewControllerID"];
    obj.propertyDetail = propertyDetail;
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)showRightSideMenu:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

#pragma mark connectionDelegates .. .. .. .. .. ..

- (void)connectionFinishLoading:(NSMutableData *)receiveData
{
    NSError* error;
    NSMutableDictionary* json;
    json = [NSJSONSerialization JSONObjectWithData:receiveData
                                           options:kNilOptions
                                             error:&error];
    NSLog(@"%@",json);
    if (json==nil)
    {
        NSLog(@"not found data");
    }
    else
    {
        if([[json valueForKey:@"code"]isEqualToString:@"200"])
        {
            if ([isRemoved isEqualToString:@"YES"]) {
                // reload cell after removing from wishlist
                [_globalWishListArray removeObjectAtIndex:deletedIndexPath.item];
                totalResult=_globalWishListArray.count;
                NSData *propertyEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:_globalWishListArray];
                [[NSUserDefaults standardUserDefaults] setObject:propertyEncodedObject forKey:@"PropertyDetail"];
                [_wishListCollectionView reloadData];
            }
            else {
                if ([requestFor isEqualToString: WishList_URL]) {
                    NSArray *propertyListArray=[json valueForKey:@"property_list"];
                    
                    for (int index = 0; index < propertyListArray.count; index++) {
                        
                        NSDictionary *dict = propertyListArray[index];
                        
                        WishListDetail *propertyDetail = [[WishListDetail alloc]init];
                        
                        propertyDetail.shortlist_property_id = dict[@"shortlist_property_id"];
                        if ([propertyDetail.shortlist_property_id isEqual:[NSNull null]] || [propertyDetail.shortlist_property_id isEqualToString:@" "]) {
                            propertyDetail.shortlist_property_id = @"";
                        }
                        propertyDetail.propertyid = dict[@"propertyid"];
                        if ([propertyDetail.propertyid isEqual:[NSNull null]] || [propertyDetail.propertyid isEqualToString:@" "]) {
                            propertyDetail.propertyid = @"";
                        }
                        propertyDetail.userid = dict[@"userid"];
                        if ([propertyDetail.userid isEqual:[NSNull null]] || [propertyDetail.userid isEqualToString:@" "]) {
                            propertyDetail.userid = @"";
                        }
                        propertyDetail.property_code = dict[@"property_code"];
                        if ([propertyDetail.property_code isEqual:[NSNull null]] || [propertyDetail.property_code isEqualToString:@" "]) {
                            propertyDetail.property_code = @"";
                        }
                        propertyDetail.property_name = [dict[@"property_name"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                        if ([propertyDetail.property_name isEqual:[NSNull null]] || [propertyDetail.property_name isEqualToString:@" "]) {
                            propertyDetail.property_name = @"";
                        }
                        propertyDetail.address_houseno = dict[@"address_houseno"];
                        if ([propertyDetail.address_houseno isEqual:[NSNull null]] || [propertyDetail.address_houseno isEqualToString:@" "]) {
                            propertyDetail.address_houseno = @"";
                        }
                        propertyDetail.address_galino = dict[@"address_galino"];
                        if ([propertyDetail.address_galino isEqual:[NSNull null]] || [propertyDetail.address_galino isEqualToString:@" "]) {
                            propertyDetail.address_galino = @"";
                        }
                        propertyDetail.address_locality = dict[@"address_locality"];
                        if ([propertyDetail.address_locality isEqual:[NSNull null]] || [propertyDetail.address_locality isEqualToString:@" "]) {
                            propertyDetail.address_locality = @"";
                        }
                        propertyDetail.address_street = dict[@"address_street"];
                        if ([propertyDetail.address_street isEqual:[NSNull null]]|| [propertyDetail.address_street isEqualToString:@" "]) {
                            propertyDetail.address_street = @"";
                        }
                        propertyDetail.address_sector = dict[@"address_sector"];
                        if ([propertyDetail.address_sector isEqual:[NSNull null]] || [propertyDetail.address_sector isEqualToString:@" "]) {
                            propertyDetail.address_sector = @"";
                        }
                        propertyDetail.address_landmark = dict[@"address_landmark"];
                        if ([propertyDetail.address_landmark isEqual:[NSNull null]]|| [propertyDetail.address_landmark isEqualToString:@" "]) {
                            propertyDetail.address_landmark = @"";
                        }
                        propertyDetail.address_city = dict[@"address_city"];
                        if ([propertyDetail.address_city isEqual:[NSNull null]]|| [propertyDetail.address_city isEqualToString:@" "]) {
                            propertyDetail.address_city = @"";
                        }
                        propertyDetail.address_state = dict[@"address_state"];
                        if ([propertyDetail.address_state isEqual:[NSNull null]]|| [propertyDetail.address_state isEqualToString:@" "]) {
                            propertyDetail.address_state = @"";
                        }
                        propertyDetail.address_country = dict[@"address_country"];
                        if ([propertyDetail.address_country isEqual:[NSNull null]]|| [propertyDetail.address_country isEqualToString:@" "]) {
                            propertyDetail.address_country = @"";
                        }
                        propertyDetail.address_pin = dict[@"address_pin"];
                        if ([propertyDetail.address_pin isEqual:[NSNull null]] || [propertyDetail.address_pin isEqualToString:@" "]) {
                            propertyDetail.address_pin = @"";
                        }
                        propertyDetail.gps_lattitude = dict[@"gps_lattitude"];
                        if ([propertyDetail.gps_lattitude isEqual:[NSNull null]] || [propertyDetail.gps_lattitude isEqualToString:@" "]) {
                            propertyDetail.gps_lattitude = @"";
                        }
                        propertyDetail.gps_longitude = dict[@"gps_longitude"];
                        if ([propertyDetail.gps_longitude isEqual:[NSNull null]] || [propertyDetail.gps_longitude isEqualToString:@" "]) {
                            propertyDetail.gps_longitude = @"";
                        }
                        propertyDetail.accommodation_type = dict[@"accommodation_type"];
                        if ([propertyDetail.accommodation_type isEqual:[NSNull null]] || [propertyDetail.accommodation_type isEqualToString:@" "]) {
                            propertyDetail.accommodation_type = @"";
                        }
                        propertyDetail.manager_firstname = dict[@"manager_firstname"];
                        if ([propertyDetail.manager_firstname isEqual:[NSNull null]] || [propertyDetail.manager_firstname isEqualToString:@" "]) {
                            propertyDetail.manager_firstname = @"";
                        }
                        propertyDetail.manager_lastname = dict[@"manager_lastname"];
                        if ([propertyDetail.manager_lastname isEqual:[NSNull null]] || [propertyDetail.manager_lastname isEqualToString:@" "]) {
                            propertyDetail.manager_lastname = @"";
                        }
                        propertyDetail.manager_gender = dict[@"manager_gender"];
                        if ([propertyDetail.manager_gender isEqual:[NSNull null]] || [propertyDetail.manager_gender isEqualToString:@" "]) {
                            propertyDetail.manager_gender = @"";
                        }
                        propertyDetail.manager_mobile = dict[@"manager_mobile"];
                        if ([propertyDetail.manager_mobile isEqual:[NSNull null]] || [propertyDetail.manager_mobile isEqualToString:@" "]) {
                            propertyDetail.manager_mobile = @"";
                        }
                        propertyDetail.phone = dict[@"phone"];
                        if ([propertyDetail.phone isEqual:[NSNull null]] || [propertyDetail.phone isEqualToString:@" "]) {
                            propertyDetail.phone = @"";
                        }
                        propertyDetail.website_url = dict[@"website_url"];
                        if ([propertyDetail.website_url isEqual:[NSNull null]] || [propertyDetail.website_url isEqualToString:@" "]) {
                            propertyDetail.website_url = @"";
                        }
                        propertyDetail.property_type = dict[@"property_type"];
                        if ([propertyDetail.property_type isEqual:[NSNull null]] || [propertyDetail.property_type isEqualToString:@" "]) {
                            propertyDetail.property_type = @"";
                        }
                        propertyDetail.property_type_other = dict[@"property_type_other"];
                        if ([propertyDetail.property_type_other isEqual:[NSNull null]] || [propertyDetail.property_type_other isEqualToString:@" "]) {
                            propertyDetail.property_type_other = @"";
                        }
                        propertyDetail.facility_available_for = dict[@"facility_available_for"];
                        if ([propertyDetail.facility_available_for isEqual:[NSNull null]] || [propertyDetail.facility_available_for isEqualToString:@" "]) {
                            propertyDetail.facility_available_for = @"";
                        }
                        
                        
                        
                        propertyDetail.food_served = dict[@"food_served"];
                        if ([propertyDetail.food_served isEqual:[NSNull null]] || [propertyDetail.food_served isEqualToString:@" "]) {
                            propertyDetail.food_served = @"";
                        }
                        propertyDetail.food_included = dict[@"food_included"];
                        if ([propertyDetail.food_included isEqual:[NSNull null]] || [propertyDetail.food_included isEqualToString:@" "]) {
                            propertyDetail.food_included = @"";
                        }
                        propertyDetail.breakfast = dict[@"breakfast"];
                        if ([propertyDetail.breakfast isEqual:[NSNull null]] || [propertyDetail.breakfast isEqualToString:@" "]) {
                            propertyDetail.breakfast = @"0";
                        }
                        propertyDetail.lunch = dict[@"lunch"];
                        if ([propertyDetail.lunch isEqual:[NSNull null]] || [propertyDetail.lunch isEqualToString:@" "]) {
                            propertyDetail.lunch = @"0";
                        }
                        propertyDetail.dinner = dict[@"dinner"];
                        if ([propertyDetail.dinner isEqual:[NSNull null]] || [propertyDetail.dinner isEqualToString:@" "]) {
                            propertyDetail.dinner = @"0";
                        }
                        propertyDetail.breakfast_amount = dict[@"breakfast_amount"];
                        if ([propertyDetail.breakfast_amount isEqual:[NSNull null]] || [propertyDetail.breakfast_amount isEqualToString:@" "]) {
                            propertyDetail.breakfast_amount = @"";
                        }
                        propertyDetail.lunch_amount = dict[@"lunch_amount"];
                        if ([propertyDetail.lunch_amount isEqual:[NSNull null]] || [propertyDetail.lunch_amount isEqualToString:@" "]) {
                            propertyDetail.lunch_amount = @"";
                        }
                        propertyDetail.dinner_amount = dict[@"dinner_amount"];
                        if ([propertyDetail.dinner_amount isEqual:[NSNull null]] || [propertyDetail.dinner_amount isEqualToString:@" "]) {
                            propertyDetail.dinner_amount = @"";
                        }
                        propertyDetail.property_verified = dict[@"property_verified"];
                        if ([propertyDetail.property_verified isEqual:[NSNull null]] || [propertyDetail.property_verified isEqualToString:@" "]) {
                            propertyDetail.property_verified = @"";
                        }
                        propertyDetail.date_verified = dict[@"date_verified"];
                        if ([propertyDetail.date_verified isEqual:[NSNull null]] || [propertyDetail.date_verified isEqualToString:@" "]) {
                            propertyDetail.date_verified = @"";
                        }
                        propertyDetail.proprety_by = dict[@"proprety_by"];
                        if ([propertyDetail.proprety_by isEqual:[NSNull null]] || [propertyDetail.proprety_by isEqualToString:@" "]) {
                            propertyDetail.proprety_by = @"";
                        }
                        propertyDetail.draft = dict[@"draft"];
                        if ([propertyDetail.draft isEqual:[NSNull null]] || [propertyDetail.draft isEqualToString:@" "]) {
                            propertyDetail.draft = @"";
                        }
                        propertyDetail.active = dict[@"active"];
                        if ([propertyDetail.active isEqual:[NSNull null]] || [propertyDetail.active isEqualToString:@" "]) {
                            propertyDetail.active = @"";
                        }
                        propertyDetail.archive = dict[@"archive"];
                        if ([propertyDetail.archive isEqual:[NSNull null]] || [propertyDetail.archive isEqualToString:@" "]) {
                            propertyDetail.archive = @"";
                        }
                        propertyDetail.deleted = dict[@"deleted"];
                        if ([propertyDetail.deleted isEqual:[NSNull null]]  || [propertyDetail.deleted isEqualToString:@" "]) {
                            propertyDetail.deleted = @"";
                        }
                        propertyDetail.created_by = dict[@"created_by"];
                        if ([propertyDetail.created_by isEqual:[NSNull null]] || [propertyDetail.created_by isEqualToString:@" "]) {
                            propertyDetail.created_by = @"";
                        }
                        propertyDetail.created_date = dict[@"created_date"];
                        if ([propertyDetail.created_date isEqual:[NSNull null]]  || [propertyDetail.created_date isEqualToString:@" "]) {
                            propertyDetail.created_date = @"";
                        }
                        propertyDetail.updated_by = dict[@"updated_by"];
                        if ([propertyDetail.updated_by isEqual:[NSNull null]]  || [propertyDetail.updated_by isEqualToString:@" "]) {
                            propertyDetail.updated_by = @"";
                        }
                        propertyDetail.updated_date = dict[@"updated_date"];
                        if ([propertyDetail.updated_date isEqual:[NSNull null]] || [propertyDetail.updated_date isEqualToString:@" "]) {
                            propertyDetail.updated_date = @"";
                        }
                        propertyDetail.verified = dict[@"verified"];
                        if ([propertyDetail.verified isEqual:[NSNull null]] || [propertyDetail.verified isEqualToString:@" "]) {
                            propertyDetail.verified = @"";
                        }
                        propertyDetail.enquiryno = dict[@"enquiryno"];
                        if ([propertyDetail.enquiryno isEqual:[NSNull null]] || [propertyDetail.enquiryno isEqualToString:@" "] ) {
                            propertyDetail.enquiryno = @"";
                        }
                        propertyDetail.title = dict[@"title"];
                        if ([propertyDetail.title isEqual:[NSNull null]]  || [propertyDetail.title isEqualToString:@" "]) {
                            propertyDetail.title = @"";
                        }
                        propertyDetail.keyword = dict[@"keyword"];
                        if ([propertyDetail.keyword isEqual:[NSNull null]]  || [propertyDetail.keyword isEqualToString:@" "]) {
                            propertyDetail.keyword = @"";
                        }
                        propertyDetail.property_description = dict[@"property_description"]; // de
                        if ([propertyDetail.property_description isEqual:[NSNull null]] || [propertyDetail.property_description isEqualToString:@" "]) {
                            propertyDetail.property_description = @"";
                        }
                        propertyDetail.studentacco_id = dict[@"studentacco_id"];
                        if ([propertyDetail.studentacco_id isEqual:[NSNull null]] || [propertyDetail.studentacco_id isEqualToString:@" "]) {
                            propertyDetail.studentacco_id = @"";
                        }
                        propertyDetail.total_student_for_college = dict[@"total_student_for_college"];
                        if ([propertyDetail.total_student_for_college isEqual:[NSNull null]] || [propertyDetail.total_student_for_college isEqualToString:@" "]) {
                            propertyDetail.total_student_for_college = @"";
                        }
                        propertyDetail.total_boys_for_college = dict[@"total_boys_for_college"];
                        if ([propertyDetail.total_boys_for_college isEqual:[NSNull null]] || [propertyDetail.total_boys_for_college isEqualToString:@" "]) {
                            propertyDetail.total_boys_for_college = @"";
                        }
                        propertyDetail.total_girls_for_college = dict[@"total_girls_for_college"];
                        if ([propertyDetail.total_girls_for_college isEqual:[NSNull null]] || [propertyDetail.total_girls_for_college isEqualToString:@" "]) {
                            propertyDetail.total_girls_for_college = @"";
                        }
                        propertyDetail.total_seats_for_hostel = dict[@"total_seats_for_hostel"];
                        if ([propertyDetail.total_seats_for_hostel isEqual:[NSNull null]] || [propertyDetail.total_seats_for_hostel isEqualToString:@" "]) {
                            propertyDetail.total_seats_for_hostel = @"";
                        }
                        propertyDetail.total_boys_for_hostel = dict[@"total_boys_for_hostel"];
                        if ([propertyDetail.total_boys_for_hostel isEqual:[NSNull null]] || [propertyDetail.total_boys_for_hostel isEqualToString:@" "]) {
                            propertyDetail.total_boys_for_hostel = @"";
                        }
                        propertyDetail.total_girls_for_hostel = dict[@"total_girls_for_hostel"];
                        if ([propertyDetail.total_girls_for_hostel isEqual:[NSNull null]] || [propertyDetail.total_girls_for_hostel isEqualToString:@" "]) {
                            propertyDetail.total_girls_for_hostel = @"";
                        }
                        propertyDetail.pg_entrytime = dict[@"pg_entrytime"];
                        if ([propertyDetail.pg_entrytime isEqual:[NSNull null]] || [propertyDetail.pg_entrytime isEqualToString:@" "]) {
                            propertyDetail.pg_entrytime = @"";
                        }
                        propertyDetail.noof_beds = dict[@"noof_beds"];
                        if ([propertyDetail.noof_beds isEqual:[NSNull null]] || [propertyDetail.noof_beds isEqualToString:@" "]) {
                            propertyDetail.noof_beds = @"";
                        }
                        propertyDetail.mark_as_branded = dict[@"mark_as_branded"];
                        if ([propertyDetail.mark_as_branded isEqual:[NSNull null]] || [propertyDetail.mark_as_branded isEqualToString:@" "]) {
                            propertyDetail.mark_as_branded = @"";
                        }
                        propertyDetail.show_on_home = dict[@"show_on_home"];
                        if ([propertyDetail.show_on_home isEqual:[NSNull null]] || [propertyDetail.show_on_home isEqualToString:@" "]) {
                            propertyDetail.show_on_home = @"";
                        }
                        propertyDetail.form_date = dict[@"form_date"];
                        if ([propertyDetail.form_date isEqual:[NSNull null]] || [propertyDetail.form_date isEqualToString:@" "]) {
                            propertyDetail.form_date = @"";
                        }
                        propertyDetail.to_date = dict[@"to_date"];
                        if ([propertyDetail.to_date isEqual:[NSNull null]] || [propertyDetail.to_date isEqualToString:@" "]) {
                            propertyDetail.to_date = @"";
                        }
                        propertyDetail.total_view = dict[@"total_view"];
                        if ([propertyDetail.total_view isEqual:[NSNull null]] || [propertyDetail.total_view isEqualToString:@" "]) {
                            propertyDetail.total_view = @"";
                        }
                        propertyDetail.sold_out = dict[@"sold_out"];
                        if ([propertyDetail.sold_out isEqual:[NSNull null]] || [propertyDetail.sold_out isEqualToString:@" "]) {
                            propertyDetail.sold_out = @"";
                        }
                        propertyDetail.sold_out = dict[@"rooms_available"];
                        if ([propertyDetail.sold_out isEqual:[NSNull null]] || [propertyDetail.sold_out isEqualToString:@" "]) {
                            propertyDetail.sold_out = @"";
                        }
                        propertyDetail.imagename = dict[@"full_image_path"];
                        if ([propertyDetail.imagename isEqual:[NSNull null]] || [propertyDetail.imagename isEqualToString:@" "]) {
                            propertyDetail.imagename = @"";
                        }
                        propertyDetail.facility_typeid = dict[@"facility_typeid"];
                        if ([propertyDetail.facility_typeid isEqual:[NSNull null]] || [propertyDetail.facility_typeid isEqualToString:@" "]) {
                            propertyDetail.facility_typeid = @"";
                        }
                        
                        // TODO : uncomment this code
                        //                    propertyDetail.facility = [dict[@"facility"] isEqual:[NSNull null]] ? @[@""] : [dict[@"facility"] componentsSeparatedByString:@","] ;
                        
                        // TODO : remove this code as web service resolved
                        NSString *tempFacility = dict[@"facility"];
                        if ([tempFacility isEqual:[NSNull null]] ||[tempFacility isEqualToString:@""]) {
                            
                            propertyDetail.facility = @[@""];
                            propertyDetail.facility = nil;
                            
                        }
                        else {
                            NSString *lastString = [tempFacility substringFromIndex:[tempFacility length] - 1];
                            if ([lastString isEqualToString:@","]) {
                                tempFacility = [tempFacility substringWithRange:NSMakeRange(0,[tempFacility length] - 1)];
                            }
                            propertyDetail.facility = [tempFacility componentsSeparatedByString:@","];
                        }
                        // ----------------------------------------------
                        propertyDetail.rent = dict[@"rent"];
                        if ([propertyDetail.rent isEqual:[NSNull null]] || [propertyDetail.rent isEqualToString:@" "]) {
                            propertyDetail.rent = @"0";
                        }
                        NSString *formatted = [NSNumberFormatter localizedStringFromNumber:@([propertyDetail.rent integerValue]) numberStyle:NSNumberFormatterCurrencyStyle];
                        formatted =[formatted substringFromIndex:1];
                        if (formatted.length >= 4) {
                            formatted = [formatted substringWithRange:NSMakeRange(0,[formatted length] - 3)];
                        }
                        
                        propertyDetail.rent = formatted;
                        
                        propertyDetail.occupancy = [dict[@"occupancy"] isEqual:[NSNull null]] ? @[@""] : [dict[@"occupancy"] componentsSeparatedByString:@","];
                        
                        [_globalWishListArray addObject:propertyDetail];

                    }
                    
                    [_wishListCollectionView reloadData];
                 totalResult=_globalWishListArray.count;
                    
                }
                else {
                    NSLog(@"%@",json[@"message"]);
                }

            }
        }
    }
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    [self addData];
}

- (void)connectionFailWithError:(NSError *)error
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    NSString *strErrorMsg = [error localizedDescription];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error !" message:strErrorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)callOwner:(UIButton*)sender {
    
    //    UIButton *wishButton = (UIButton *)sender;
    //    PropertyDetailCollectionViewCell *cell = (PropertyDetailCollectionViewCell *) wishButton.superview.superview;
    //    NSIndexPath *indexPath = [_wishListCollectionView indexPathForCell:cell];
    //    PropertyDetail *propertyDetail = globalWishListArray[indexPath.item];
    //
    //    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel://%@",propertyDetail.manager_mobile]];
    //
    //    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
    //        [[UIApplication sharedApplication] openURL:phoneUrl];
    //    }
    //    else {
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Call facility is not available!!!" preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        }];
    //        [alertController addAction:cancelAction];
    //        [self presentViewController:alertController animated:YES completion:nil];
    //    }
    NSIndexPath *indexPath = [_wishListCollectionView indexPathForCell:(UICollectionViewCell *)sender.superview.superview];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"])
    {
        ContactInfoViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactInfoViewController"];
        
     //        obj.contactEnquireNo=propertyDetail.enquiryno;
//        obj.propertyDetail = propertyDetail;
        obj.selected=@"yes";
        obj.propertyDetail = _globalWishListArray[indexPath.item];
        [self.navigationController pushViewController:obj animated:YES];
    }
    else
    {
        ContactLandlordViewController *contactLandlord = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactLandlordViewController"];
        
        contactLandlord.propertyDetail=_globalWishListArray[indexPath.item];
        
        [self.navigationController pushViewController:contactLandlord animated:YES];
        
    }
}

- (IBAction)moveToPreviousScreen:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
