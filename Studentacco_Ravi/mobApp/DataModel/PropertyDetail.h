//
//  PropertyDetail.h
//  mobApp
//
//  Created by MAG  on 6/23/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyDetail : NSObject

@property (nonatomic, strong) NSString *shortlist_property_id;
@property (nonatomic, strong) NSString *propertyid;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *property_code;
@property (nonatomic, strong) NSString *property_name;
@property (nonatomic, strong) NSString *address_houseno;
@property (nonatomic, strong) NSString *address_galino;
@property (nonatomic, strong) NSString *address_locality;
@property (nonatomic, strong) NSString *address_street;
@property (nonatomic, strong) NSString *address_sector;
@property (nonatomic, strong) NSString *address_landmark;
@property (nonatomic, strong) NSString *address_city;
@property (nonatomic, strong) NSString *address_state;
@property (nonatomic, strong) NSString *address_country;
@property (nonatomic, strong) NSString *address_pin;
@property (nonatomic, strong) NSString *gps_lattitude;
@property (nonatomic, strong) NSString *gps_longitude;
@property (nonatomic, strong) NSString *accommodation_type;
@property (nonatomic, strong) NSString *manager_firstname;
@property (nonatomic, strong) NSString *manager_lastname;
@property (nonatomic, strong) NSString *manager_gender;
@property (nonatomic, strong) NSString *manager_mobile;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *website_url;
@property (nonatomic, strong) NSString *property_type;
@property (nonatomic, strong) NSString *property_type_other;
@property (nonatomic, strong) NSString *facility_available_for;
@property (nonatomic, strong) NSString *food_served;
@property (nonatomic, strong) NSString *food_included;
@property (nonatomic, strong) NSString *breakfast;
@property (nonatomic, strong) NSString *lunch;
@property (nonatomic, strong) NSString *dinner;
@property (nonatomic, strong) NSString *breakfast_amount;
@property (nonatomic, strong) NSString *lunch_amount;
@property (nonatomic, strong) NSString *dinner_amount;
@property (nonatomic, strong) NSString *property_verified;
@property (nonatomic, strong) NSString *date_verified;
@property (nonatomic, strong) NSString *proprety_by;
@property (nonatomic, strong) NSString *draft;
@property (nonatomic, strong) NSString *active;
@property (nonatomic, strong) NSString *archive;
@property (nonatomic, strong) NSString *deleted;
@property (nonatomic, strong) NSString *created_by;
@property (nonatomic, strong) NSString *created_date;
@property (nonatomic, strong) NSString *updated_by;
@property (nonatomic, strong) NSString *updated_date;
@property (nonatomic, strong) NSString *verified;
@property (nonatomic, strong) NSString *enquiryno;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *property_description; // description come in web service
@property (nonatomic, strong) NSString *studentacco_id;
@property (nonatomic, strong) NSString *total_student_for_college;
@property (nonatomic, strong) NSString *total_boys_for_college;
@property (nonatomic, strong) NSString *total_girls_for_college;
@property (nonatomic, strong) NSString *total_seats_for_hostel;
@property (nonatomic, strong) NSString *total_boys_for_hostel;
@property (nonatomic, strong) NSString *total_girls_for_hostel;
@property (nonatomic, strong) NSString *pg_entrytime;
@property (nonatomic, strong) NSString *noof_beds;
@property (nonatomic, strong) NSString *mark_as_branded;
@property (nonatomic, strong) NSString *show_on_home;
@property (nonatomic, strong) NSString *form_date;
@property (nonatomic, strong) NSString *to_date;
@property (nonatomic, strong) NSString *total_view;
@property (nonatomic, strong) NSString *sold_out;
@property (nonatomic, strong) NSString *rooms_available;
@property (nonatomic, strong) NSString *imagename;
@property (nonatomic, strong) NSString *facility_typeid;
@property (nonatomic, strong) NSArray  *facility;
@property (nonatomic, strong) NSString *rent;
@property (nonatomic, strong) NSArray  *occupancy;

@end
