//
//  FilterViewController.m
//  mobApp
//
//  Created by MAG on 16/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"
#import "FilterTableCollectionViewCell.h"
#import "CERangeSlider.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "SearchBarTableViewCell.h"
#import "AppDelegate.h"
@interface FilterViewController ()<UITableViewDelegate,UITableViewDataSource,FilterTableViewCellDelegate,UISearchBarDelegate>
{
    CERangeSlider* _rangeSlider;
    NSMutableArray *gender,*accomodation,*amenities,*houseRules;
    NSMutableArray *selectedIndexArray;
//    NSMutableArray *selectedGenderIndexArray, *selectedAccomodationIndexArray, *selectedAmenitiesIndexArray, *selectedHouseRuleIndexArray;
    UILabel *MinRangeLabel;
    UILabel *MaxRangeLabel;
    CGFloat maxRange, minRange;
    NSMutableArray *autocompleteList;
    NSString *search;
    

    
    NSMutableData *recived_serverData;
    NSMutableArray *genderSelection;
    NSArray *accomodationKeys, *amenitiesKeys, *houseRuleKeys;
    
    __weak IBOutlet UITableView *autocompleteTableView;
    
}

@end

@implementation FilterViewController
@synthesize filterTableView,addButton;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (!_filterData) {
        _filterData = [[FilterSelectionDetail alloc]init];
    }
    
    if ([_filterData.budget_min isEqualToString:@""] && [_filterData.budget_max isEqualToString:@""]) {
        _filterData.budget_min = @"2000";
        _filterData.budget_max = @"25000";
    }

    
    gender=[NSMutableArray arrayWithObjects:@"Boys",@"Girls", nil];
    genderSelection=[NSMutableArray arrayWithObjects:@"Male",@"Female", nil];
    
    accomodation=[NSMutableArray arrayWithObjects:@"Single",@"Double",@"Triple",@"Dorm", nil];
    accomodationKeys = @[@"1",@"2",@"3",@"4"];
    
    amenities=[NSMutableArray arrayWithObjects:@"Cupboard",@"Attached toilet",@"Bedding",@"Table/Chair",@"Fridge",@"TV",@"Air-conditioned",nil];
    amenitiesKeys = @[@"Cupboard",@"Attached toilet",@"Bedding",@"Table/Chair",@"Fridge",@"TV",@"AC"];
    
    houseRules=[NSMutableArray arrayWithObjects:@"Smoking",@"Alcohol",@"Boys Allowed",@"Girls Allowed",@"Non-veg Food",@"Admission Process Followed",nil];
    houseRuleKeys = @[@"Smoking",@"Alcohol",@"Boys allowed",@"Girls allowed",@"Non-veg food",@"Admission process followed"];
    
    [filterTableView registerNib:[UINib nibWithNibName:@"FilterTableViewCell" bundle:nil] forCellReuseIdentifier:@"filterTableViewCellID"];
    [filterTableView registerNib:[UINib nibWithNibName:@"SearchBarTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchBarTableViewCell"];
    [filterTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
    _selectedFilter = [[NSString alloc]init];
    _selectedGenderIndexArray = [[NSMutableArray alloc]init];
    _selectedAccomodationIndexArray = [[NSMutableArray alloc]init];
    _selectedAmenitiesIndexArray = [[NSMutableArray alloc]init];
    _selectedHouseRuleIndexArray = [[NSMutableArray alloc]init];
    
    if (_lastSelectedFilterIndex.count) {
        _selectedGenderIndexArray = [_lastSelectedFilterIndex[0] mutableCopy];
        _selectedAccomodationIndexArray = [_lastSelectedFilterIndex[1] mutableCopy];
        _selectedAmenitiesIndexArray = [_lastSelectedFilterIndex[2] mutableCopy];
        _selectedHouseRuleIndexArray = [_lastSelectedFilterIndex[3] mutableCopy];
    }
    
    MinRangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, 200, 40)];
    MaxRangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 50, 200, 40)];
    
    minRange =_filterData.budget_min.floatValue;
    maxRange =_filterData.budget_max.floatValue;
    autocompleteTableView.hidden=YES;
    autocompleteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
}

#pragma mark - UITableView Delegate & Datasource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
       return 50;

}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag==100) {
        return NULL;
    }
    else
    {

    UIView *viewForHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    viewForHeader.backgroundColor = [UIColor colorWithRed:231/255.0 green:232/255.0 blue:225/255.0 alpha:1.0f];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 40)];
    titleLabel.font=[UIFont fontWithName:@"CircularStd-Bold" size:15];
    titleLabel.textColor = [UIColor lightGrayColor
                            ];
    
    NSString *titleForHeader = @"";
    if (section == 0) {
        titleForHeader = @"BUDGET";
    }
    else if (section==1) {
        titleForHeader = @"GENDER";
    }
    else if (section==2)
    {
        titleForHeader=@"ACCOMODATION";
    }
    else if (section==3)
    {
        titleForHeader=@"AMENITIES";
    }
    else if (section==4)
    {
        titleForHeader=@"HOUSE RULES";
    }
    titleLabel.text = titleForHeader;
    
    
    [viewForHeader addSubview:titleLabel];
    
    return viewForHeader;
    }}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==2) {
        return 100;
    }
    else if (indexPath.section==3){
        return 190;
    }
    else if (indexPath.section==0){
        return 80;
    }
    else if (indexPath.section==4){
        return 190;
    }
    return 50;
    }

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //static NSString *MyIdentifier1 = @"searchBarTableViewCell";
    static NSString *MyIdentifier2 = @"filterTableViewCellID";
    static NSString *MyIdentifier4 = @"identifier";
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        UITableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier4];
        [sliderCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSUInteger margin = 30;
        MinRangeLabel.textColor=[UIColor darkGrayColor];
        MaxRangeLabel.textColor=[UIColor darkGrayColor];
        CGRect sliderFrame = CGRectMake(margin, margin+20, self.view.bounds.size.width-60, 25);
        if (!_rangeSlider) {
            _rangeSlider = [[CERangeSlider alloc] initWithFrame:sliderFrame];
            [sliderCell addSubview:_rangeSlider];
        }
        _rangeSlider.lowerValue = minRange;
        _rangeSlider.upperValue = maxRange;
        
        [_rangeSlider setLayerFrames];

        [_rangeSlider addTarget:self
                         action:@selector(slideValueChanged:)
               forControlEvents:UIControlEventValueChanged];
        [filterTableView addSubview:MinRangeLabel];
        [filterTableView addSubview:MaxRangeLabel];
        [MinRangeLabel setText:[NSString stringWithFormat:@"Min:%2.0f"@"/-", minRange]];
        [MaxRangeLabel setText:[NSString stringWithFormat:@"Max:%2.0f"@"/-", maxRange]];
        
        
        cell = sliderCell;
    }
    
    else {
        FilterTableViewCell *filterCell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier2];
        filterCell.delegate = self;
        if (indexPath.section==1) {
            [filterCell setUp:gender withSelectedIndexes:_selectedGenderIndexArray];
        }
        else if (indexPath.section==2) {
            [filterCell setUp:accomodation withSelectedIndexes:_selectedAccomodationIndexArray];
        }
        else if (indexPath.section==3) {
            [filterCell setUp:amenities withSelectedIndexes:_selectedAmenitiesIndexArray];
        }
        else if(indexPath.section==4){
            [filterCell setUp:houseRules withSelectedIndexes:_selectedHouseRuleIndexArray];
        }
        cell = filterCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    }



- (void) selectedIndexesArrayList:(NSIndexPath*)selectedIndex withSelectedCell:(id)filterTableCell {
    
    FilterTableViewCell *filterCell = (FilterTableViewCell*)filterTableCell;
    NSIndexPath *indexPath = [filterTableView indexPathForCell:filterCell];
    if (indexPath.section == 1) {
        BOOL isPresent = NO;
        
        for (int i= 0; i< _selectedGenderIndexArray.count; i++) {
            NSIndexPath *tempIndex = _selectedGenderIndexArray[i];
            if(tempIndex.item == selectedIndex.item && tempIndex.section == selectedIndex.section) {
                isPresent = YES;
                [_allAppliedFilters removeObject:gender[selectedIndex.item]];
                [_selectedGenderIndexArray removeObjectAtIndex:i];
                break;
            }
        }
        if (!isPresent) {
            [_allAppliedFilters addObject:gender[selectedIndex.item]];
            [_selectedGenderIndexArray addObject:selectedIndex];
        }
        
    }
    else if (indexPath.section == 2) {
        BOOL isPresent = NO;
        
        for (int i= 0; i< _selectedAccomodationIndexArray.count; i++) {
            NSIndexPath *tempIndex = _selectedAccomodationIndexArray[i];
            if(tempIndex.item == selectedIndex.item && tempIndex.section == selectedIndex.section) {
                isPresent = YES;
                [_allAppliedFilters removeObject:accomodation[selectedIndex.item]];
                [_selectedAccomodationIndexArray removeObjectAtIndex:i];
                break;
            }
        }
        if (!isPresent) {
            [_allAppliedFilters addObject:accomodation[selectedIndex.item]];
            [_selectedAccomodationIndexArray addObject:selectedIndex];
        }
        
    }
    else if (indexPath.section == 3) {
        BOOL isPresent = NO;
        
        for (int i= 0; i< _selectedAmenitiesIndexArray.count; i++) {
            NSIndexPath *tempIndex = _selectedAmenitiesIndexArray[i];
            if(tempIndex.item == selectedIndex.item && tempIndex.section == selectedIndex.section) {
                isPresent = YES;
                [_allAppliedFilters removeObject:amenities[selectedIndex.item]];
                [_selectedAmenitiesIndexArray removeObjectAtIndex:i];
                break;
            }
        }
        if (!isPresent) {
            [_allAppliedFilters addObject:amenities[selectedIndex.item]];
            [_selectedAmenitiesIndexArray addObject:selectedIndex];
        }
    }
    else if (indexPath.section == 4) {
        BOOL isPresent = NO;
        
        for (int i= 0; i< _selectedHouseRuleIndexArray.count; i++) {
            NSIndexPath *tempIndex = _selectedHouseRuleIndexArray[i];
            if(tempIndex.item == selectedIndex.item && tempIndex.section == selectedIndex.section) {
                isPresent = YES;
                [_allAppliedFilters removeObject:houseRules[selectedIndex.item]];
                [_selectedHouseRuleIndexArray removeObjectAtIndex:i];
                break;
            }
        }
        if (!isPresent) {
            [_allAppliedFilters addObject:houseRules[selectedIndex.item]];
            [_selectedHouseRuleIndexArray addObject:selectedIndex];
        }
    }

}

- (void)slideValueChanged:(id)control
{
    minRange =_rangeSlider.lowerValue;
    maxRange =_rangeSlider.upperValue;
    
    [MinRangeLabel setText:[NSString stringWithFormat:@"Min:%2.0f"@"/-", minRange]];
    [MaxRangeLabel setText:[NSString stringWithFormat:@"Max:%2.0f"@"/-", maxRange]];
    
}

- (IBAction)applyPropertyFilterAction:(id)sender {
    
    _filterData.budget_min = [NSString stringWithFormat:@"%2.0f",minRange];
    _filterData.budget_max = [NSString stringWithFormat:@"%2.0f",maxRange];
    
    [_filterData.genderSelectionArray removeAllObjects];
    for (int i= 0; i< _selectedGenderIndexArray.count; i++) {
        NSIndexPath *tempIndex = _selectedGenderIndexArray[i];
        if (![_filterData.genderSelectionArray containsObject:genderSelection[tempIndex.item]]) {
            [_filterData.genderSelectionArray addObject:genderSelection[tempIndex.item]];
        }
    }
    [_filterData.accomodation_typeArray removeAllObjects];
    for (int i= 0; i< _selectedAccomodationIndexArray.count; i++) {
        NSIndexPath *tempIndex = _selectedAccomodationIndexArray[i];
        if (![_filterData.accomodation_typeArray containsObject:accomodationKeys[tempIndex.item]]) {
            [_filterData.accomodation_typeArray addObject:accomodationKeys[tempIndex.item]];
        }
    }
    [_filterData.amenitiesArray removeAllObjects];
    for (int i= 0; i< _selectedAmenitiesIndexArray.count; i++) {
        NSIndexPath *tempIndex = _selectedAmenitiesIndexArray[i];
        if (![_filterData.amenitiesArray containsObject:amenitiesKeys[tempIndex.item]]) {
            [_filterData.amenitiesArray addObject:amenitiesKeys[tempIndex.item]];
        }
    }
    [_filterData.house_rulesArray removeAllObjects];
    for (int i= 0; i< _selectedHouseRuleIndexArray.count; i++) {
        NSIndexPath *tempIndex = _selectedHouseRuleIndexArray[i];
        if (![_filterData.house_rulesArray containsObject:houseRuleKeys[tempIndex.item]]) {
            [_filterData.house_rulesArray addObject:houseRuleKeys[tempIndex.item]];
        }
    }

    [self.delegate appliedFilter:_allAppliedFilters withFilterObject:_filterData  andWithSelectedFiltersIndexes:@[_selectedGenderIndexArray, _selectedAccomodationIndexArray, _selectedAmenitiesIndexArray, _selectedHouseRuleIndexArray] withURL:_requestForURL];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)moveToPreviousView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetFilter:(id)sender {
    [_selectedGenderIndexArray removeAllObjects];
    [_selectedAccomodationIndexArray removeAllObjects];
    [_selectedAmenitiesIndexArray removeAllObjects];
    [_selectedHouseRuleIndexArray removeAllObjects];
    [filterTableView reloadData];
    minRange = 2000;
    maxRange = 25000;
    
    _filterData.budget_min = [NSString stringWithFormat:@"%2.0f",minRange];
    _filterData.budget_max = [NSString stringWithFormat:@"%2.0f",maxRange];
}

#pragma Mark UISearchBar delegate method


#pragma NSURL Connection Delegate method

- (void)connectionFailWithError:(NSError *)error
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    NSString *strErrorMsg = [error localizedDescription];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error !" message:strErrorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}




@end
