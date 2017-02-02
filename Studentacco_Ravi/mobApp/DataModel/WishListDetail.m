//
//  WishListDetail.m
//  Studentacco
//
//  Created by MAG on 16/08/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "WishListDetail.h"

@implementation WishListDetail
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.shortlist_property_id forKey:@"shortlist_property_id"];
    [encoder encodeObject:self.propertyid forKey:@"propertyid"];
    [encoder encodeObject:self.userid forKey:@"userid"];
    
    [encoder encodeObject:self.property_code forKey:@"property_code"];
    [encoder encodeObject:self.property_name forKey:@"property_name"];
    [encoder encodeObject:self.address_houseno forKey:@"address_houseno"];
    [encoder encodeObject:self.address_galino forKey:@"address_galino"];
    
    [encoder encodeObject:self.address_locality forKey:@"address_locality"];
    [encoder encodeObject:self.address_street forKey:@"address_street"];
    [encoder encodeObject:self.address_sector forKey:@"address_sector"];
    
    [encoder encodeObject:self.address_landmark forKey:@"address_landmark"];
    [encoder encodeObject:self.address_city forKey:@"address_city"];
    [encoder encodeObject:self.address_state forKey:@"address_state"];
    
    [encoder encodeObject:self.address_country forKey:@"address_country"];
    [encoder encodeObject:self.address_pin forKey:@"address_pin"];
    [encoder encodeObject:self.gps_lattitude forKey:@"gps_lattitude"];
    [encoder encodeObject:self.gps_longitude forKey:@"gps_longitude"];
    
    [encoder encodeObject:self.accommodation_type forKey:@"accommodation_type"];
    [encoder encodeObject:self.manager_firstname forKey:@"manager_firstname"];
    [encoder encodeObject:self.manager_lastname forKey:@"manager_lastname"];
    [encoder encodeObject:self.manager_gender forKey:@"manager_gender"];
    
    [encoder encodeObject:self.manager_mobile forKey:@"manager_mobile"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.website_url forKey:@"website_url"];
    [encoder encodeObject:self.property_type forKey:@"property_type"];
    
    [encoder encodeObject:self.property_type_other forKey:@"property_type_other"];
    [encoder encodeObject:self.facility_available_for forKey:@"facility_available_for"];
    [encoder encodeObject:self.food_served forKey:@"food_served"];
    [encoder encodeObject:self.food_included forKey:@"food_included"];
    
    [encoder encodeObject:self.breakfast forKey:@"breakfast"];
    [encoder encodeObject:self.lunch forKey:@"lunch"];
    [encoder encodeObject:self.dinner forKey:@"dinner"];
    [encoder encodeObject:self.breakfast_amount forKey:@"breakfast_amount"];
    
    [encoder encodeObject:self.lunch_amount forKey:@"lunch_amount"];
    [encoder encodeObject:self.dinner_amount forKey:@"dinner_amount"];
    [encoder encodeObject:self.property_verified forKey:@"property_verified"];
    [encoder encodeObject:self.date_verified forKey:@"date_verified"];
    
    
    [encoder encodeObject:self.proprety_by forKey:@"proprety_by"];
    [encoder encodeObject:self.draft forKey:@"draft"];
    [encoder encodeObject:self.active forKey:@"active"];
    [encoder encodeObject:self.archive forKey:@"archive"];
    
    [encoder encodeObject:self.deleted forKey:@"deleted"];
    [encoder encodeObject:self.created_by forKey:@"created_by"];
    [encoder encodeObject:self.created_date forKey:@"created_date"];
    [encoder encodeObject:self.updated_by forKey:@"updated_by"];
    
    [encoder encodeObject:self.updated_date forKey:@"updated_date"];
    [encoder encodeObject:self.enquiryno forKey:@"enquiryno"];
    [encoder encodeObject:self.verified forKey:@"verified"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.keyword forKey:@"keyword"];
    
    [encoder encodeObject:self.studentacco_id forKey:@"studentacco_id"];
    [encoder encodeObject:self.total_student_for_college forKey:@"total_student_for_college"];
    [encoder encodeObject:self.total_boys_for_college forKey:@"total_boys_for_college"];
    [encoder encodeObject:self.total_girls_for_college forKey:@"total_girls_for_college"];
    
    [encoder encodeObject:self.total_seats_for_hostel forKey:@"total_seats_for_hostel"];
    [encoder encodeObject:self.total_boys_for_hostel forKey:@"total_boys_for_hostel"];
    [encoder encodeObject:self.total_girls_for_hostel forKey:@"total_girls_for_hostel"];
    [encoder encodeObject:self.pg_entrytime forKey:@"pg_entrytime"];
    
    [encoder encodeObject:self.noof_beds forKey:@"noof_beds"];
    [encoder encodeObject:self.mark_as_branded forKey:@"mark_as_branded"];
    [encoder encodeObject:self.show_on_home forKey:@"show_on_home"];
    [encoder encodeObject:self.form_date forKey:@"form_date"];
    
    [encoder encodeObject:self.total_view forKey:@"total_view"];
    [encoder encodeObject:self.sold_out forKey:@"sold_out"];
    [encoder encodeObject:self.rooms_available forKey:@"rooms_available"];
    [encoder encodeObject:self.imagename forKey:@"imagename"];
    
    [encoder encodeObject:self.facility_typeid forKey:@"facility_typeid"];
    [encoder encodeObject:self.facility forKey:@"facility"];
    [encoder encodeObject:self.rent forKey:@"rent"];
    [encoder encodeObject:self.occupancy forKey:@"occupancy"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.shortlist_property_id = [decoder decodeObjectForKey:@"shortlist_property_id"];
        self.propertyid = [decoder decodeObjectForKey:@"propertyid"];
        self.userid = [decoder decodeObjectForKey:@"userid"];
        
        self.property_code = [decoder decodeObjectForKey:@"property_code"];
        self.property_name = [decoder decodeObjectForKey:@"property_name"];
        self.address_houseno = [decoder decodeObjectForKey:@"address_houseno"];
        self.address_galino = [decoder decodeObjectForKey:@"address_galino"];
        
        self.address_locality = [decoder decodeObjectForKey:@"address_locality"];
        self.address_street = [decoder decodeObjectForKey:@"address_street"];
        self.address_sector = [decoder decodeObjectForKey:@"address_sector"];
        
        self.address_landmark = [decoder decodeObjectForKey:@"address_landmark"];
        self.address_city = [decoder decodeObjectForKey:@"address_city"];
        self.address_state = [decoder decodeObjectForKey:@"address_state"];
        
        self.address_country = [decoder decodeObjectForKey:@"address_country"];
        self.address_pin = [decoder decodeObjectForKey:@"address_pin"];
        self.gps_lattitude = [decoder decodeObjectForKey:@"gps_lattitude"];
        self.gps_longitude = [decoder decodeObjectForKey:@"gps_longitude"];
        
        self.accommodation_type = [decoder decodeObjectForKey:@"accommodation_type"];
        self.manager_firstname = [decoder decodeObjectForKey:@"manager_firstname"];
        self.manager_lastname = [decoder decodeObjectForKey:@"manager_lastname"];
        self.manager_gender = [decoder decodeObjectForKey:@"manager_gender"];
        
        self.manager_mobile = [decoder decodeObjectForKey:@"manager_mobile"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.website_url = [decoder decodeObjectForKey:@"website_url"];
        self.property_type = [decoder decodeObjectForKey:@"property_type"];
        
        self.property_type_other = [decoder decodeObjectForKey:@"property_type_other"];
        self.facility_available_for = [decoder decodeObjectForKey:@"facility_available_for"];
        self.food_served = [decoder decodeObjectForKey:@"food_served"];
        self.food_included = [decoder decodeObjectForKey:@"food_included"];
        
        self.breakfast = [decoder decodeObjectForKey:@"breakfast"];
        self.lunch = [decoder decodeObjectForKey:@"lunch"];
        self.dinner = [decoder decodeObjectForKey:@"dinner"];
        self.breakfast_amount = [decoder decodeObjectForKey:@"breakfast_amount"];
        
        self.lunch_amount = [decoder decodeObjectForKey:@"lunch_amount"];
        self.dinner_amount = [decoder decodeObjectForKey:@"dinner_amount"];
        self.property_verified = [decoder decodeObjectForKey:@"property_verified"];
        self.date_verified = [decoder decodeObjectForKey:@"date_verified"];
        
        self.proprety_by = [decoder decodeObjectForKey:@"proprety_by"];
        self.draft = [decoder decodeObjectForKey:@"draft"];
        self.active = [decoder decodeObjectForKey:@"active"];
        self.archive = [decoder decodeObjectForKey:@"archive"];
        
        self.deleted = [decoder decodeObjectForKey:@"deleted"];
        self.created_by = [decoder decodeObjectForKey:@"created_by"];
        self.created_date = [decoder decodeObjectForKey:@"created_date"];
        self.updated_by = [decoder decodeObjectForKey:@"updated_by"];
        
        self.updated_date = [decoder decodeObjectForKey:@"updated_date"];
        self.verified = [decoder decodeObjectForKey:@"verified"];
        self.enquiryno = [decoder decodeObjectForKey:@"enquiryno"];
        self.title = [decoder decodeObjectForKey:@"title"];
        
        self.keyword = [decoder decodeObjectForKey:@"keyword"];
        self.studentacco_id = [decoder decodeObjectForKey:@"studentacco_id"];
        self.total_student_for_college = [decoder decodeObjectForKey:@"total_student_for_college"];
        self.total_boys_for_college = [decoder decodeObjectForKey:@"total_boys_for_college"];
        
        self.total_girls_for_college = [decoder decodeObjectForKey:@"total_girls_for_college"];
        self.total_seats_for_hostel = [decoder decodeObjectForKey:@"total_seats_for_hostel"];
        self.total_boys_for_hostel = [decoder decodeObjectForKey:@"total_boys_for_hostel"];
        self.total_girls_for_hostel = [decoder decodeObjectForKey:@"total_girls_for_hostel"];
        
        self.pg_entrytime = [decoder decodeObjectForKey:@"pg_entrytime"];
        self.noof_beds = [decoder decodeObjectForKey:@"noof_beds"];
        self.mark_as_branded = [decoder decodeObjectForKey:@"mark_as_branded"];
        self.show_on_home = [decoder decodeObjectForKey:@"show_on_home"];
        
        self.form_date = [decoder decodeObjectForKey:@"form_date"];
        self.to_date = [decoder decodeObjectForKey:@"to_date"];
        self.total_view = [decoder decodeObjectForKey:@"total_view"];
        self.sold_out = [decoder decodeObjectForKey:@"sold_out"];
        
        self.rooms_available = [decoder decodeObjectForKey:@"rooms_available"];
        self.imagename = [decoder decodeObjectForKey:@"imagename"];
        self.facility_typeid = [decoder decodeObjectForKey:@"facility_typeid"];
        self.facility = [decoder decodeObjectForKey:@"facility"];
        
        self.rent = [decoder decodeObjectForKey:@"rent"];
        self.occupancy = [decoder decodeObjectForKey:@"occupancy"];
    }
    return self;
}

@end
