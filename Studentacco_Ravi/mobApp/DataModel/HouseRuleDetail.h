//
//  HouseRuleDetail.h
//  StudentAcco
//
//  Created by MAG  on 7/19/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseRuleDetail : NSObject
/*
 "property_houseruleid": "293",
 "houseruleid": "2",
 "propertyid": "98",
 "houserule": "Non-veg food",
 "created_by": "74",
 "created_date": "2015-09-07 15:40:20"
 */

@property (nonatomic, strong) NSString *houseruleid;
@property (nonatomic, strong) NSString *propertyid;
@property (nonatomic, strong) NSString *houserule;

@end
