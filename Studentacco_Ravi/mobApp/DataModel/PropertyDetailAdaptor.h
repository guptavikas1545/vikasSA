//
//  PropertyDetailAdaptor.h
//  StudentAcco
//
//  Created by MAG  on 7/6/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterSelectionDetail.h"

@interface PropertyDetailAdaptor : NSObject

@property (strong, nonatomic) FilterSelectionDetail *filterData;
@property (nonatomic, strong) NSString *pageNumber;
@property (nonatomic, strong) NSString *totalResult;
@property (nonatomic, strong) NSString *localAddress;
@property (nonatomic, strong) NSString *requestFor;

- (void) fetchPropertyListData;

- (instancetype)initWithFilterObject:(FilterSelectionDetail*)filterObject withPageNumber:(NSInteger)pageCount withRequestForURL:(NSString*)requestForURL;

@end
