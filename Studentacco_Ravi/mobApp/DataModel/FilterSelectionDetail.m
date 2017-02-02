//
//  FilterSelectionDetail.m
//  StudentAcco
//
//  Created by MAG  on 7/3/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "FilterSelectionDetail.h"

@implementation FilterSelectionDetail

- (id)init
{
    if(self = [super init])
    {
        _genderSelectionArray = [NSMutableArray new];
        _house_rulesArray = [NSMutableArray new];
        _accomodation_typeArray = [NSMutableArray new];
        _amenitiesArray = [NSMutableArray new];
        
        _budget_min = @"";
        _budget_max = @"";

    }
    return self;
}

-(void)dealloc {
    
    _genderSelectionArray = nil;
    _house_rulesArray = nil;
    _accomodation_typeArray = nil;
    _amenitiesArray = nil;
    _budget_min = nil;
    _budget_max = nil;
    _search_key = nil;
    _search_city = nil;
}

@end
