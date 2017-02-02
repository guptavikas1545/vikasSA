//
//  ChildListViewController.m
//  mobApp
//
//  Created by MAG on 13/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "ChildListViewController.h"
#import "PropertyDetailCollectionViewCell.h"
#import "FullPropertyDetailsViewController.h"
#import "FilterViewController.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "WishListDetail.h"
#import "UserDetail.h"
#import "PropertyDetailAdaptor.h"
#import "BrandedPropertyAdaptor.h"
#import "ViewController.h"
#import "ContactLandlordViewController.h"
#import "InnerCollectionViewCell.h"
#import "BrandedPropertyCollectionViewCell.h"
#import "AppDelegate.h"
#import "ContactInfoViewController.h"
#import "WishListDetail.h"
extern NSInteger totalPropertyCount;
extern NSString *requestURLFrom;

@interface ChildListViewController ()<BrandedPropertyCollectionViewCellDelegate>
{
    NSMutableArray *globalPropertyListArray;
    UserDetail *userDetail;
    NSInteger pageNumber;
    NSString *requestFor;
    NSInteger totalResult;
    NSString *sortType;
    NSArray *amenitiesImageArray;
    NSArray *amenitiesArray;
    NSInteger sizeCount;
    NSMutableArray *filteredPropertyList;
    
}
@end

@implementation ChildListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_listViewCollectionView registerNib:[UINib nibWithNibName:@"PropertyDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"propertyDetailCollectionCell"];
    [_listViewCollectionView registerNib:[UINib nibWithNibName:@"BrandedPropertyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"brandedPropertyCollectionViewCell"];
    requestURLFrom = Filter_URL;
    
    if (!_filterData) {
        _filterData = [[FilterSelectionDetail alloc]init];
        _filterData.genderSelectionArray = [NSMutableArray new];
        _filterData.house_rulesArray = [NSMutableArray new];
        _filterData.accomodation_typeArray = [NSMutableArray new];
        _filterData.amenitiesArray = [NSMutableArray new];
        
        _filterData.budget_min = @"2000";
        _filterData.budget_max = @"25000";
    }
    
    filteredPropertyList = [[NSMutableArray alloc]init];
    globalPropertyListArray = [[NSMutableArray alloc]init];
    pageNumber = 0;
    
    amenitiesArray = @[@"Attached toilet", @"AC", @"Cupboard", @"Fridge", @"Bedding", @"Table/Chair", @"Geyser", @"TV"];
    amenitiesImageArray = @[@"toilet-icon", @"ac-icon", @"cupboard-icon", @"fridge-icon", @"bedding-icon", @"chair-icon", @"geyser-icon", @"tv-icon"];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"PropertyDetail"]) {
        NSData *wishListData = [[NSUserDefaults standardUserDefaults] dataForKey:@"PropertyDetail"];
        _wishListArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:wishListData];
        
    }
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
        userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    [self fetchPropertyListData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(fetchPropertyList:)
                                                name:FilterNotificationForList
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(failureResponseHandle:)
                                                name:FailureNotificationForList
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(shortPropertyArray:)
                                                name:SortNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouched) name:@"touchStatusBarClick" object:nil];
    
    _listViewCollectionView.scrollsToTop =NO;
    
    
}

-(void) statusBarTouched
{
    [_listViewCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionTop
                                            animated:YES];
}  
#pragma mark - NSNotification Callback

- (void)fetchPropertyList:(NSNotification*) notification {
    
    NSArray *tempArray = (NSArray*) notification.object;
    
    pageNumber = [tempArray[2] integerValue];
    
    if (pageNumber == 0) {
        [globalPropertyListArray removeAllObjects];
    }
    
    [globalPropertyListArray addObjectsFromArray:tempArray[0]];
    
    if ([sortType isEqualToString:@"PRICE(High to Low)"]){
        filteredPropertyList = [[globalPropertyListArray reverseObjectEnumerator] allObjects].mutableCopy;
    }
    else {
        filteredPropertyList = globalPropertyListArray;
    }
    
    totalResult = [tempArray[1] integerValue];
    
    totalPropertyCount = totalResult;
    
    [_listViewCollectionView reloadData];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
}

- (void) shortPropertyArray:(NSNotification*) notification {
    sortType = (NSString*) notification.object;
    
    if ([sortType isEqualToString:@"PRICE(High to Low)"]){
        filteredPropertyList = [[globalPropertyListArray reverseObjectEnumerator] allObjects].mutableCopy;
    }
    else {
        filteredPropertyList = globalPropertyListArray;
    }
    [_listViewCollectionView reloadData];
    [_listViewCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
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

#pragma mark- All WebService Actions

- (void) fetchPropertyListData {
    PropertyDetailAdaptor *propertyDetailAdaptor = [[PropertyDetailAdaptor alloc]initWithFilterObject:_filterData withPageNumber:pageNumber withRequestForURL:Filter_URL];
    [propertyDetailAdaptor fetchPropertyListData];
}

- (void)addToWishList:(id)sender {

    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        UIButton *wishButton = (UIButton *)sender;
        PropertyDetailCollectionViewCell *cell = (PropertyDetailCollectionViewCell *) wishButton.superview.superview;
        NSIndexPath *indexPath = [_listViewCollectionView indexPathForCell:cell];
        
        WishListDetail *propertyDetail = filteredPropertyList[indexPath.item];
        
        if ([propertyDetail.shortlist_property_id isEqualToString:@""]) {
            propertyDetail.shortlist_property_id = propertyDetail.propertyid;
        }
        else {
            propertyDetail.shortlist_property_id = @"";
        }
        
        [filteredPropertyList replaceObjectAtIndex:indexPath.item withObject:propertyDetail];
        
        [_listViewCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
        
        NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,Add_To_WishList_URL];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"property_id\":\"%@\"}",userDetail.userid, propertyDetail.propertyid];
        NSLog(@"%@",jsonRequest);
        requestFor = Add_To_WishList_URL;
        URLConnection *connection=[[URLConnection alloc] init];
        connection.delegate=self;
        [connection getDataFromUrl:jsonRequest webService:urlString];
    }
    else
    {
    
        UIButton *wishButton = (UIButton *)sender;
        PropertyDetailCollectionViewCell *cell = (PropertyDetailCollectionViewCell *) wishButton.superview.superview;
        NSIndexPath *indexPath = [_listViewCollectionView indexPathForCell:cell];
        
        WishListDetail *propertyDetail = filteredPropertyList[indexPath.item];
    
        WishListDetail *wishListDetail = [[WishListDetail alloc]init];
    
    wishListDetail.shortlist_property_id = propertyDetail.shortlist_property_id;
    wishListDetail.propertyid = propertyDetail.propertyid;
    wishListDetail.userid = propertyDetail.userid;
    wishListDetail.property_code = propertyDetail.property_code;
    wishListDetail.property_name = propertyDetail.property_name;
    wishListDetail.address_houseno = propertyDetail.address_houseno;
    wishListDetail.address_galino = propertyDetail.address_galino;
    wishListDetail.address_locality = propertyDetail.address_locality;
    wishListDetail.address_street = propertyDetail.address_street;
    wishListDetail.address_sector = propertyDetail.address_sector;
    wishListDetail.address_landmark = propertyDetail.address_landmark;
    wishListDetail.address_city = propertyDetail.address_city;
    wishListDetail.address_state = propertyDetail.address_state;
    wishListDetail.address_country = propertyDetail.address_country;
    wishListDetail.address_pin = propertyDetail.address_pin;
    wishListDetail.gps_lattitude = propertyDetail.gps_lattitude;
    wishListDetail.gps_longitude = propertyDetail.gps_longitude;
    wishListDetail.accommodation_type = propertyDetail.accommodation_type;
    wishListDetail.manager_firstname = propertyDetail.manager_firstname;
    wishListDetail.manager_lastname = propertyDetail.manager_lastname;
    wishListDetail.manager_gender = propertyDetail.manager_gender;
    wishListDetail.manager_mobile = propertyDetail.manager_mobile;
    wishListDetail.phone = propertyDetail.phone;
    wishListDetail.website_url = propertyDetail.website_url;
    wishListDetail.property_type = propertyDetail.property_type;
    wishListDetail.property_type_other = propertyDetail.property_type_other;
    wishListDetail.facility_available_for = propertyDetail.facility_available_for;
    wishListDetail.food_served = propertyDetail.food_served;
    wishListDetail.food_included = propertyDetail.food_included;
    wishListDetail.breakfast = propertyDetail.breakfast;
    wishListDetail.lunch = propertyDetail.lunch;
    wishListDetail.dinner = propertyDetail.dinner;
    wishListDetail.breakfast_amount = propertyDetail.breakfast_amount;
    wishListDetail.lunch_amount = propertyDetail.lunch_amount;
    wishListDetail.dinner_amount = propertyDetail.dinner_amount;
    wishListDetail.property_verified = propertyDetail.property_verified;
    wishListDetail.date_verified = propertyDetail.date_verified;
    wishListDetail.proprety_by = propertyDetail.proprety_by;
    wishListDetail.draft = propertyDetail.draft;
    wishListDetail.active = propertyDetail.active;
    wishListDetail.archive = propertyDetail.archive;
    wishListDetail.deleted = propertyDetail.deleted;
    wishListDetail.created_by = propertyDetail.created_by;
    wishListDetail.created_date = propertyDetail.created_date;
    wishListDetail.updated_by = propertyDetail.updated_by;
    wishListDetail.updated_date = propertyDetail.updated_date;
    wishListDetail.updated_by = propertyDetail.updated_by;
    wishListDetail.updated_date = propertyDetail.updated_date;
    wishListDetail.verified = propertyDetail.verified;
    wishListDetail.enquiryno = propertyDetail.enquiryno;
    wishListDetail.title = propertyDetail.title;
    wishListDetail.keyword = propertyDetail.keyword;
    wishListDetail.property_description = propertyDetail.property_description;
    wishListDetail.studentacco_id = propertyDetail.studentacco_id;
    wishListDetail.total_student_for_college = propertyDetail.total_student_for_college;
    wishListDetail.total_boys_for_college = propertyDetail.total_boys_for_college;
    wishListDetail.total_girls_for_college = propertyDetail.total_girls_for_college;
    wishListDetail.total_seats_for_hostel = propertyDetail.total_seats_for_hostel;
    wishListDetail.total_boys_for_hostel = propertyDetail.total_boys_for_hostel;
    wishListDetail.total_girls_for_hostel = propertyDetail.total_girls_for_hostel;
    wishListDetail.pg_entrytime = propertyDetail.pg_entrytime;
    wishListDetail.noof_beds = propertyDetail.noof_beds;
    wishListDetail.mark_as_branded = propertyDetail.mark_as_branded;
    wishListDetail.show_on_home = propertyDetail.show_on_home;
    wishListDetail.form_date = propertyDetail.form_date;
    wishListDetail.to_date = propertyDetail.to_date;
    wishListDetail.total_view = propertyDetail.total_view;
    wishListDetail.sold_out = propertyDetail.sold_out;
    wishListDetail.rooms_available = propertyDetail.rooms_available;
    wishListDetail.imagename = propertyDetail.imagename;
    wishListDetail.facility_typeid = propertyDetail.facility_typeid;
    wishListDetail.facility = propertyDetail.facility;
    wishListDetail.rent = propertyDetail.rent;
    wishListDetail.occupancy = propertyDetail.occupancy;
    
    NSLog(@"%ld",(unsigned long)_wishListArray.count);
    BOOL isPresent = NO;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"PropertyDetail"]) {
        NSData *wishListData = [[NSUserDefaults standardUserDefaults] dataForKey:@"PropertyDetail"];
            _wishListArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:wishListData];
    }
    for(int i= 0; i< _wishListArray.count; i++)
    {
        cell.wishButton.selected=NO;
        WishListDetail *p = _wishListArray[i];
       
        
        if (wishListDetail.propertyid==p.propertyid) {
            isPresent=YES;
            cell.wishButton.selected=NO;
            [_wishListArray removeObjectAtIndex:i];
            NSData *propertyEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:_wishListArray];
            NSLog(@"%lu",(unsigned long)_wishListArray.count);
            
            [[NSUserDefaults standardUserDefaults]setObject:propertyEncodedObject forKey:@"PropertyDetail"];
            break;
        }
    }
    if (isPresent==NO) {
        cell.wishButton.selected=YES;
        [_wishListArray addObject:wishListDetail];
        NSData *propertyEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:_wishListArray];
        NSLog(@"%lu",(unsigned long)_wishListArray.count);
        [[NSUserDefaults standardUserDefaults]setObject:propertyEncodedObject forKey:@"PropertyDetail"];
        
    }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UIColectionView header   and footer delegate method.

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(self.view.bounds.size.width,373);
    
    if (((indexPath.item + 1) % 4) == 0) {
        
        CGSize size = CGSizeMake(self.view.bounds.size.width,340);
        return size;
        
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerViewSize = CGSizeMake(self.view.bounds.size.width, 50);
    return headerViewSize;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [_listViewCollectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"headerID" forIndexPath: indexPath];
        
        [[header subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        UIImageView *starImage = [[UIImageView alloc] initWithFrame: CGRectMake(width/2-125, 15, 19, 19)];
        starImage.image=[UIImage imageNamed:@"map-marker.png"];
        [header addSubview: starImage];
        
        UIFont *labFont = [UIFont fontWithName: @"CircularStd-Medium" size: 15.0];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake((width/2-125)+22, 11, 260, 25)];
        headerLabel.textColor=[UIColor darkGrayColor];
        [headerLabel setFont: labFont];
//        NSString *str = [NSString stringWithFormat:@"%lu places found in %@",(unsigned long)totalResult, _filterData.search_city];
//        CGSize myStringSize = [str sizeWithFont:labFont];
        
        if ([_filterData.search_key length]==0) {
             headerLabel.text = [NSString stringWithFormat:@"%lu places found in %@",(unsigned long)totalResult, _filterData.search_city];
        }
        else
        {
            headerLabel.text = [NSString stringWithFormat:@"%lu places found in %@",(unsigned long)totalResult, _filterData.search_key];}
        [header addSubview: headerLabel];
        return header;
    }
    else {
        
        UICollectionReusableView *footer = [_listViewCollectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionFooter withReuseIdentifier: @"footerID" forIndexPath: indexPath];
        return footer;
    }
}

#pragma mark - UICollectionView Delegate and DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    sizeCount=(filteredPropertyList.count)/3;
    
    return filteredPropertyList.count+sizeCount;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (((indexPath.item + 1) % 4) == 0) {
        static NSString *identifier1 = @"brandedPropertyCollectionViewCell";
        
        BrandedPropertyCollectionViewCell *cell = (BrandedPropertyCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
        cell.delegate = self;
        [cell setUpBrandedPropertyData:_brandedPropertyList];
        
        
        return cell;
    }
    else {
        
    }
    static NSString *identifier2 = @"propertyDetailCollectionCell";
    PropertyDetailCollectionViewCell *cell = (PropertyDetailCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier2 forIndexPath:indexPath];
    WishListDetail *propertyDetail = nil;
    if (indexPath.item > 3 && ((indexPath.item + 1) % 4 == 1 || (indexPath.item + 1) % 4 == 2 || (indexPath.item + 1) % 4 == 3)) {
        NSInteger updatedIndex = (indexPath.item + 1) /4;
        propertyDetail = filteredPropertyList[indexPath.item-updatedIndex];
    }
    else {
        propertyDetail = filteredPropertyList[indexPath.item];
    }
    
    
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
    
    cell.wishButton.selected = NO;
     if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
    if ([propertyDetail.shortlist_property_id isEqualToString:propertyDetail.propertyid]) {
        cell.wishButton.selected = YES;
    }}
    for (int i=0; i<_wishListArray.count; i++) {
        WishListDetail *wishListWithoutLogin = _wishListArray[i];
        if ([propertyDetail.propertyid isEqualToString:wishListWithoutLogin.propertyid]) {
            cell.wishButton.selected = YES;
        }
    }
    
    
    [cell.wishButton addTarget:self
                        action:@selector(addToWishList:)
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
    
    // for async image loading
    cell.activityLoader.hidden = NO;
    [cell.activityLoader startAnimating];
    cell.propertyImageView.image = nil;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",propertyDetail.imagename]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    PropertyDetailCollectionViewCell *updateCell = (id)[_listViewCollectionView cellForItemAtIndexPath:indexPath];
                    updateCell.activityLoader.hidden = YES;
                    updateCell.propertyImageView.image = image;
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
    if (indexPath.row == [filteredPropertyList count] + sizeCount - 1)
    {
        UIActivityIndicatorView *activity = (UIActivityIndicatorView*)[_listViewCollectionView viewWithTag:1001];
        activity.hidden = false;
        
        if (filteredPropertyList.count < totalResult) {
            pageNumber ++;
            [self fetchPropertyListData];
        }
        else {
            UIActivityIndicatorView *activity = (UIActivityIndicatorView*)[_listViewCollectionView viewWithTag:1001];
            activity.hidden = true;
        }
    }
    else {
        UIActivityIndicatorView *activity = (UIActivityIndicatorView*)[_listViewCollectionView viewWithTag:1001];
        activity.hidden = true;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WishListDetail *propertyDetail;
    if (indexPath.item > 3 && ((indexPath.item + 1) % 4 == 1 || (indexPath.item + 1) % 4 == 2 || (indexPath.item + 1) % 4 == 3)) {
        NSInteger updatedIndex = (indexPath.item + 1) /4;
        propertyDetail = filteredPropertyList[indexPath.item-updatedIndex];
    }
    else {
        propertyDetail = filteredPropertyList[indexPath.item];
    }

    
    FullPropertyDetailsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"FullPropertyDetailsViewControllerID"];
    obj.propertyDetail = propertyDetail;
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)callOwner:(UIButton*)sender {
    
    //    UIButton *wishButton = (UIButton *)sender;
    //    PropertyDetailCollectionViewCell *cell = (PropertyDetailCollectionViewCell *) wishButton.superview.superview;
    //    NSIndexPath *indexPath = [_listViewCollectionView indexPathForCell:cell];
    //    PropertyDetail *propertyDetail = filteredPropertyList[indexPath.item];
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
    NSIndexPath *indexPath = [_listViewCollectionView indexPathForCell:(UICollectionViewCell *)sender.superview.superview];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        ContactInfoViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactInfoViewController"];
        WishListDetail *propertyDetail = filteredPropertyList[indexPath.item];
        obj.contactEnquireNo=propertyDetail.enquiryno;              obj.propertyDetail = propertyDetail;
        
        obj.propertyDetail = filteredPropertyList[indexPath.item];
        [self.navigationController pushViewController:obj animated:YES];
        
        
    }
    else
    {
        ContactLandlordViewController *contactLandlord = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactLandlordViewController"];
        WishListDetail *propertyDetail = filteredPropertyList[indexPath.item];
        contactLandlord.propertyDetail = propertyDetail;
        [self.navigationController pushViewController:contactLandlord animated:YES];
        

    }
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
            if ([requestFor isEqualToString: Add_To_WishList_URL]) {
                NSData *propertyEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:_wishListArray];
                [[NSUserDefaults standardUserDefaults] setObject:propertyEncodedObject forKey:@"PropertyDetail"];
            }
            
        }
    }
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
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
#pragma mark - OuterCollectionViewCellDelegate

- (void)moveToSelectedProperty :(WishListDetail *)selectedProperty {
    
    FullPropertyDetailsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"FullPropertyDetailsViewControllerID"];
    obj.propertyDetail = selectedProperty;
    [self.navigationController pushViewController:obj animated:YES];
    
}


#pragma mark show popup


- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}


@end
