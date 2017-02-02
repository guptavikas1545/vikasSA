//
//  FilterSelectionDetail.h
//  StudentAcco
//
//  Created by MAG  on 7/3/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterSelectionDetail : NSObject

/*
 {
 "user_id":"",
 "gender":"",
 "house_rules":"",
 "accomodation_type":"",
 "amenities":"",
 "budget_min":"",
 "budget_max":"",
 "page":"",
 "search_key":"",
 "search_city":""
 }
 */
@property (nonatomic, strong) NSMutableArray    *genderSelectionArray;
@property (nonatomic, strong) NSMutableArray    *house_rulesArray;
@property (nonatomic, strong) NSMutableArray    *accomodation_typeArray;
@property (nonatomic, strong) NSMutableArray    *amenitiesArray;
@property (nonatomic, strong) NSString          *budget_min;
@property (nonatomic, strong) NSString          *budget_max;
@property (nonatomic, strong) NSString          *search_key;
@property (nonatomic, strong) NSString          *search_city;

@end
