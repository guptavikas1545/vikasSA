//
//  OuterCollectionViewCell.m
//  mobApp
//
//  Created by MAG on 06/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "OuterCollectionViewCell.h"
#import "InnerCollectionViewCell.h"
#import "ListAndMapViewController.h"
#import "ViewController.h"
#import "PropertyDetailCollectionViewCell.h"
#import "AppDelegate.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "WishListDetail.h"
#import "UserDetail.h"
#import "WishListViewController.h"
#import "BannerCollectionViewCell.h"
#import "HeaderCollectionViewCell.h"
@implementation OuterCollectionViewCell
{
    UserDetail *userDetail;
    WishListDetail *wish;
    NSMutableArray *autocompleteList;
    NSString *search;
    NSString *selected;
    
}
@synthesize addButton;
- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
    
    [_innerCollectionView registerNib:[UINib nibWithNibName:@"InnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"innerCollectionCell"];
    [_innerCollectionView registerNib:[UINib nibWithNibName:@"PropertyDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"propertyDetailCollectionCell"];
    [_innerCollectionView registerNib:[UINib nibWithNibName:@"BannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BannerCollectionCell"];
    [_innerCollectionView registerNib:[UINib nibWithNibName:@"HeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"headerCollectionViewCell"];
    _innerCollectionView.delegate = self;
    _innerCollectionView.dataSource = self;
    
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
        userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
       
    }
   
}

-(void)setUpBrandedPropertyData:(NSArray*)propertyDataList
{
    _wishListArray = [[NSMutableArray alloc]init];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"PropertyDetail"]) {
        NSData *wishListData = [[NSUserDefaults standardUserDefaults] dataForKey:@"PropertyDetail"];
        _wishListArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:wishListData];
        
    }
    
    _propertyDataArray = [NSArray arrayWithArray:propertyDataList];
    [_innerCollectionView reloadData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.lastContentOffset > scrollView.contentOffset.y)
    {
        NSLog(@"Scrolling Up");
    }
    else if (self.lastContentOffset < scrollView.contentOffset.y)
    {
        [self.delegate selected];
        NSLog(@"Scrolling Down");
    }
    
    self.lastContentOffset = scrollView.contentOffset.y;
}

#pragma mark - UICollectionView Delegate and DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count;
    if (section==0) {
        count = 1;
    }
    else if (section==1)
    {
        count = 1;
    }
    else if (section==2)
    {
        count = _propertyDataArray.count;
    }
    return  count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        CGSize size = CGSizeMake(self.superview.bounds.size.width, 190);
        return size;
    }
    else if (indexPath.section==1)
    {
        CGSize size = CGSizeMake(self.superview.bounds.size.width, 30);
        return size;
    }
    else
    {
        CGSize size = CGSizeMake(self.superview.bounds.size.width,373);
        return size;
        
    }
}




-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *reusableCell;
    if (indexPath.section==0) {
        
        
        static NSString *identifier = @"BannerCollectionCell";
        
        BannerCollectionViewCell *cell = (BannerCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.seachBar.delegate=self;
        cell.seachBar.text=search;
        
        reusableCell = cell;
    }
    else if (indexPath.section==1){
        static NSString *identifier = @"headerCollectionViewCell";
        HeaderCollectionViewCell *Cell = (HeaderCollectionViewCell*)
        [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        reusableCell =  Cell;
    }
    else if (indexPath.section==2)
    {
        static NSString *identifier = @"propertyDetailCollectionCell";
        
        PropertyDetailCollectionViewCell *cell = (PropertyDetailCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        WishListDetail *propertyDetail = _propertyDataArray[indexPath.item];
        
        cell.propertyName.text = propertyDetail.property_name;
        cell.rentLabel.text = propertyDetail.rent;
        
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
        cell.propertyAddress.text = propertyAddress;
        
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
                        PropertyDetailCollectionViewCell *updateCell = (id)[_innerCollectionView cellForItemAtIndexPath:indexPath];
                        updateCell.activityLoader.hidden = YES;
                        updateCell.propertyImageView.image = image;
                    });
                }
            }
        }];
        [task resume];
        
        
        cell.wishButton.selected = NO;
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
            if ([propertyDetail.shortlist_property_id isEqualToString:propertyDetail.propertyid]) {
                cell.wishButton.selected = YES;
            }
        }
            for (int i =0; i<_wishListArray.count; i++) {
                WishListDetail *wishWithoutLogin = _wishListArray[i];
                if ([propertyDetail.propertyid isEqualToString:wishWithoutLogin.propertyid]) {
                
                    cell.wishButton.selected = YES;
            }
                    }
        
        


        [cell.callOwnerButton addTarget:self
                                 action:@selector(callOwner:)
                       forControlEvents:UIControlEventTouchUpInside];
        
        [cell.wishButton addTarget:self
                            action:@selector(addToWishList:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        reusableCell = cell;
        
    }
    return reusableCell;
}

#pragma UiSearchBar Delegate Method
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
     self.addButton.enabled = NO;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //searchBar.text=search;
    if(searchBar.text.length == 0){
        addButton.enabled = YES;
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //[self.delegate searchButtonClicked];
     addButton.enabled = [searchBar.text length] == 0;
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //search=searchBar.text;
    [self.delegate CallAutocomplete : searchBar.text];
//        if ([searchText length] == 0)
//    {
//        [searchBar performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0];
//    }
}


- (void)callOwner:(UIButton*)sender {
    NSIndexPath *indexPath = [_innerCollectionView indexPathForCell:(UICollectionViewCell *)sender.superview.superview];
    
    WishListDetail *propertyDetail = _propertyDataArray[indexPath.item];
    [self.delegate moveToContactLandlord:propertyDetail];
}

- (void)addToWishList:(UIButton*)sender {
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        UIButton *wishButton = (UIButton *)sender;
        PropertyDetailCollectionViewCell *cell = (PropertyDetailCollectionViewCell *) wishButton.superview.superview;
        NSIndexPath *indexPath = [_innerCollectionView indexPathForCell:cell];
        
        WishListDetail *propertyDetail = _propertyDataArray[indexPath.item];
        
        if ([propertyDetail.shortlist_property_id isEqualToString:@""]|| [propertyDetail.shortlist_property_id isEqual:[NSNull null]]) {
            propertyDetail.shortlist_property_id = propertyDetail.propertyid;
            selected = @"YES";
        }
        else {
            NSLog(@"%@",propertyDetail.shortlist_property_id);
            propertyDetail.shortlist_property_id = @"";
        }
        
        
        [_innerCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
        
        NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,Add_To_WishList_URL];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"property_id\":\"%@\"}",userDetail.userid, propertyDetail.propertyid];
        NSLog(@"%@",jsonRequest);
        //requestFor = Add_To_WishList_URL;
        URLConnection *connection=[[URLConnection alloc] init];
        connection.delegate=self;
        [connection getDataFromUrl:jsonRequest webService:urlString];
    }
    else{
     //UIButton *wishButton = (UIButton *)sender;
    NSIndexPath *indexPath = [_innerCollectionView indexPathForCell:(UICollectionViewCell *)sender.superview.superview];
    PropertyDetailCollectionViewCell *Cell = (PropertyDetailCollectionViewCell *) sender.superview.superview;
    WishListDetail *propertyDetail = _propertyDataArray[indexPath.item];
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
    wishListDetail.enquiryno = propertyDetail .enquiryno;
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
    NSLog(@"%lu",(unsigned long)_wishListArray.count);
    
    BOOL isPresent = NO;
    
    for(int i= 0; i< _wishListArray.count; i++)
    {
        Cell.wishButton.selected=NO;
        WishListDetail *p = _wishListArray[i];
        
        if (wishListDetail.propertyid==p.propertyid) {
            isPresent=YES;
            Cell.wishButton.selected=NO;
            [_wishListArray removeObjectAtIndex:i];
            NSData *propertyEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:_wishListArray];
            NSLog(@"%lu",(unsigned long)_wishListArray.count);
            
            [[NSUserDefaults standardUserDefaults]setObject:propertyEncodedObject forKey:@"PropertyDetail"];
            break;
        }
    }
    if (isPresent==NO) {
        Cell.wishButton.selected=YES;
        [_wishListArray addObject:wishListDetail];
        NSData *propertyEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:_wishListArray];
        NSLog(@"%lu",(unsigned long)_wishListArray.count);
       [[NSUserDefaults standardUserDefaults]setObject:propertyEncodedObject forKey:@"PropertyDetail"];
        
    }
    
    }}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        WishListDetail *propertyDetail = _propertyDataArray[indexPath.item];
        
        [self.delegate moveToSelectedProperty:propertyDetail];
    }

}


#pragma mark-URL connection delegate method

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
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    }
    else
    {
        if([[json valueForKey:@"code"]isEqualToString:@"200"])
        {
            
            }
            
        }
    
[(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
}


@end
