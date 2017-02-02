//
//  PropertyDetailAdaptor.m
//  StudentAcco
//
//  Created by MAG  on 7/6/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "PropertyDetailAdaptor.h"
#import "FilterViewController.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "WishListDetail.h"
#import "UserDetail.h"
#import "AppDelegate.h"
@implementation PropertyDetailAdaptor

- (instancetype)initWithFilterObject:(FilterSelectionDetail*)filterObject withPageNumber:(NSInteger)pageCount withRequestForURL:(NSString*)requestForURL {
    
    _filterData = filterObject;
    _pageNumber = [NSString stringWithFormat:@"%ld",(long)pageCount];
    _requestFor = requestForURL;
    
    return self;
}

#pragma mark- All WebService Actions

- (void) fetchPropertyListData {
    
    NSString *genderSelected = [_filterData.genderSelectionArray componentsJoinedByString:@","];
    if (genderSelected == nil) {
        genderSelected = @"";
    }
    
    NSString *house_rules = [_filterData.house_rulesArray componentsJoinedByString:@","];
    if (house_rules == nil) {
        house_rules = @"";
    }
    
    NSString *accomodation_type = [_filterData.accomodation_typeArray componentsJoinedByString:@","];
    if (accomodation_type == nil) {
        accomodation_type = @"";
    }
    
    NSString *amenities = [_filterData.amenitiesArray componentsJoinedByString:@","];
    if (amenities == nil) {
        amenities = @"";
    }
    
    UserDetail *userDetail = [[UserDetail alloc]init];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
        userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }

    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,_requestFor];
    
    NSString *jsonRequest = nil;
    
    if ([_requestFor isEqualToString:BrandedList_URL]) {
        jsonRequest = [NSString stringWithFormat:@"{\"user_id\":\"%@\"}",userDetail.userid];
    }
    else {
        jsonRequest = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"gender\":\"%@\",\"house_rules\":\"%@\",\"accomodation_type\":\"%@\",\"amenities\":\"%@\",\"budget_min\":\"%@\",\"budget_max\":\"%@\",\"page\":\"%@\",\"search_key\":\"%@\",\"search_city\":\"%@\"}",userDetail.userid, genderSelected, house_rules, accomodation_type, amenities, _filterData.budget_min, _filterData.budget_max, _pageNumber, _filterData.search_key, _filterData.search_city];
    }
    
    NSLog(@"urlString ## %@",urlString);
    NSLog(@"jsonRequest ## %@", jsonRequest);
    
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];
}


#pragma mark connectionDelegates .. .. .. .. .. ..

- (void)connectionFinishLoading:(NSMutableData *)receiveData
{
    NSError* error;
    NSMutableDictionary* json;
    json = [NSJSONSerialization JSONObjectWithData:receiveData
                                           options:kNilOptions
                                             error:&error];
    if (json==nil)
    {
        NSLog(@"not found data");
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    }
    else
    {
        if([[json valueForKey:@"code"]isEqualToString:@"200"])
        {
            {
                NSArray *propertyListArray=[json valueForKey:@"property_list"];
                
                NSMutableArray *globalPropertyListArray = [[NSMutableArray alloc]init];
                
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
                    
                    [globalPropertyListArray addObject:propertyDetail];
                }
                
                _totalResult = [json valueForKey:@"total_results"];
                
                if ([_requestFor isEqualToString:Filter_URL]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:FilterNotificationForList
                                                                       object:@[globalPropertyListArray,_totalResult, _pageNumber]];
                }
                else if ([_requestFor isEqualToString:MapProperty_URL]){
                    [[NSNotificationCenter defaultCenter]postNotificationName:FilterNotificationForMap
                                                                       object:@[globalPropertyListArray,_totalResult]];
                }
                else if ([_requestFor isEqualToString:BrandedList_URL]){
                    [[NSNotificationCenter defaultCenter]postNotificationName:FilterNotificationForBranded
                                                                       object:@[globalPropertyListArray]];
                }
            }
        }
    }
}

- (void)connectionFailWithError:(NSError *)error
{
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    if ([_requestFor isEqualToString:Filter_URL]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:FailureNotificationForList
                                                           object:error];

    }
    else if ([_requestFor isEqualToString:MapProperty_URL]){
        [[NSNotificationCenter defaultCenter]postNotificationName:FailureNotificationForMap
                                                           object:error];

    }
    else if ([_requestFor isEqualToString:BrandedList_URL]){
        [[NSNotificationCenter defaultCenter]postNotificationName:FailureNotificationForBranded
                                                           object:error];

    }
    
}


@end
