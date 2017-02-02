//
//  FilterViewController.h
//  mobApp
//
//  Created by MAG on 16/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterSelectionDetail.h"

@protocol FilterViewControllerDelegate <NSObject>

//- (void) maxMinValue:(CGFloat*)selectedRange;

- (void) appliedFilter:(NSArray *)filterSelectedData withFilterObject:(FilterSelectionDetail*)filterDetailObject andWithSelectedFiltersIndexes:(NSArray *)selectedIndexArray withURL:(NSString*)requestURL;

@end


@interface FilterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (strong, nonatomic) NSArray *lastSelectedFilterIndex;
@property (strong, nonatomic) NSMutableArray *allAppliedFilters;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, retain) NSMutableArray *checkedIndexPaths;
@property (weak, nonatomic) id<FilterViewControllerDelegate> delegate;

@property (strong, nonatomic) FilterSelectionDetail *filterData;
@property (strong, nonatomic) NSString *requestForURL;
@property (strong, nonatomic) NSString *selectedFilter;
@property (strong, nonatomic) NSMutableArray *selectedGenderIndexArray;
@property (strong, nonatomic) NSMutableArray *selectedAccomodationIndexArray;
@property (strong, nonatomic) NSMutableArray *selectedAmenitiesIndexArray;
@property (strong, nonatomic) NSMutableArray *selectedHouseRuleIndexArray;
@property (nonatomic) CGFloat lastContentOffset;
@end






