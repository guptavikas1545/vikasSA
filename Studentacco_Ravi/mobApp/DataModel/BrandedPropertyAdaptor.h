//
//  BrandedPropertyAdaptor.h
//  StudentAcco
//
//  Created by MAG on 01/08/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterSelectionDetail.h"


@interface BrandedPropertyAdaptor : NSObject
@property (strong, nonatomic) FilterSelectionDetail *filterData;
@property (nonatomic, strong) NSString *pageNumber;
@property (nonatomic, strong) NSString *totalResult;
@property (nonatomic, strong) NSString *localAddress;
@property (nonatomic, strong) NSString *requestFor;
- (void) fetchBrandedPropertyData;

- (instancetype)initWithFilterObject:(FilterSelectionDetail*)filterObject withPageNumber:(NSInteger)pageCount withRequestForURL:(NSString*)requestForURL;

@end
