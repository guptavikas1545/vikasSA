//
//  ListAndMapViewController.m
//  mobApp
//
//  Created by MAG on 13/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "ListAndMapViewController.h"
#import "ChildListViewController.h"
#import "PropertyDetailCollectionViewCell.h"
#import "ChildListViewController.h"
#import "MapViewController.h"
#import "FilterViewController.h"
#import "FilterSelectionDetail.h"
#import "AppConstants.h"
#import "PropertyDetailAdaptor.h"
#import "CustomLabelCollectionViewCell.h"
#import "Appdelegate.h"

NSString *requestURLFrom;
NSInteger totalPropertyCount;

@interface ListAndMapViewController ()<FilterViewControllerDelegate>
{
    NSMutableArray *titleForNavigationTitleLabelArray;
    
    __weak IBOutlet UILabel     *listViewLabel;
    __weak IBOutlet UILabel     *listViewBottomLine;
    __weak IBOutlet UIButton    *listViewButton;
    
    __weak IBOutlet UILabel     *mapViewLabel;
    __weak IBOutlet UILabel     *mapViewBottomLine;
    __weak IBOutlet UIButton    *mapViewButton;
    __weak IBOutlet UIImageView *listImageView;
    NSString *selected;
    __weak IBOutlet UIImageView *mapImageViw;
   
    NSMutableArray *selectedFilterIndexes;
    
    FilterSelectionDetail *filterSelectionObject;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) UIViewController *currentViewController;
@end

@implementation ListAndMapViewController
@synthesize navigationCollectionView,containerView;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    selected=[[NSString alloc]init];
    requestURLFrom = Filter_URL;
    
    filterSelectionObject = [[FilterSelectionDetail alloc]init];
    filterSelectionObject.search_city = _selectedCityValue;
    filterSelectionObject.search_key = _localityAddress;
    
    ChildListViewController *propertyListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChildListViewControllerId"];
    propertyListViewController.filterData = filterSelectionObject;
    propertyListViewController.brandedPropertyList = _brandedPropertyData;
    self.currentViewController = propertyListViewController;
    self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
    
    titleForNavigationTitleLabelArray = [[NSMutableArray alloc]init];
    
    selectedFilterIndexes = [NSMutableArray array];
    
    listViewButton.selected = YES;
    
    [navigationCollectionView registerNib:[UINib nibWithNibName:@"CustomLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CustomLabelCollectionViewCell"];
   
    [titleForNavigationTitleLabelArray addObject:_localityAddress];
   
}

- (IBAction)moveToPreviousView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)buttonTouched:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if( [[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"icon-Locked.png"]])
    {
        [btn setImage:[UIImage imageNamed:@"icon-Unlocked.png"] forState:UIControlStateNormal];
        // other statements
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"icon-Locked.png"] forState:UIControlStateNormal];
        // other statements
    }
}


- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}

- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    [newViewController.view layoutIfNeeded];
    
    // set starting state of the transition
    newViewController.view.alpha = 0;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                     }];
}


#pragma mark - UICollectionView Delegate and DataSource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [titleForNavigationTitleLabelArray count ];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize calCulateSizze =[(NSString*)[titleForNavigationTitleLabelArray objectAtIndex:indexPath.row] sizeWithAttributes:NULL];
    
    calCulateSizze.width = calCulateSizze.width+60;
    calCulateSizze.height = calCulateSizze.height +10;
    
    return calCulateSizze;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CustomLabelCollectionViewCell";
    
    CustomLabelCollectionViewCell *cell = (CustomLabelCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
     cell.filterTitleLabel.text = titleForNavigationTitleLabelArray[indexPath.row];

    [cell.removeFromFilter addTarget:self
                             action:@selector(removeSelectedFilter:)
                   forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterViewController *obj=[self .storyboard instantiateViewControllerWithIdentifier:@"FilterViewControllerID"];
    obj.delegate = self;
    obj.lastSelectedFilterIndex = selectedFilterIndexes;
    obj.filterData = filterSelectionObject;
    obj.requestForURL = requestURLFrom;
    obj.allAppliedFilters = [NSMutableArray arrayWithArray:titleForNavigationTitleLabelArray].mutableCopy;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeSelectedFilter:(UIButton*)sender
{
    NSIndexPath *indexPath = [navigationCollectionView indexPathForCell:(UICollectionViewCell *)sender.superview.superview];
    NSString *deletedItem = titleForNavigationTitleLabelArray[indexPath.item];
    [titleForNavigationTitleLabelArray removeObjectAtIndex:indexPath.item];
    [navigationCollectionView reloadData];
    
    NSMutableArray *gender=[NSMutableArray arrayWithObjects:@"Boys",@"Girls", nil];
    NSArray *genderSelection=@[@"Male",@"Female"];
    
    NSMutableArray *accomodation=[NSMutableArray arrayWithObjects:@"Single",@"Double",@"Triple",@"Dorm", nil];
    NSArray *accomodationKeys = @[@"1",@"2",@"3",@"4"];
    
    NSMutableArray *amenities=[NSMutableArray arrayWithObjects:@"Cupboard",@"Attached toilet",@"Bedding",@"Table/Chair",@"Fridge",@"TV",@"Air-conditioned",nil];
    NSArray *amenitiesKeys = @[@"Cupboard",@"Attached toilet",@"Bedding",@"Table/Chair",@"Fridge",@"TV",@"AC"];
    
    NSMutableArray *houseRules=[NSMutableArray arrayWithObjects:@"Smoking",@"Alcohol",@"Boys Allowed",@"Girls Allowed",@"Non-veg Food",@"Admission Process Followed",nil];
    NSArray *houseRuleKeys = @[@"Smoking",@"Alcohol",@"Boys allowed",@"Girls allowed",@"Non-veg food",@"Admission process followed"];
    
    if([gender containsObject:deletedItem] && filterSelectionObject.genderSelectionArray.count > 0) {
        NSUInteger indexOfDeletedItem = [gender indexOfObject:deletedItem];
        NSUInteger indexOfItem = [filterSelectionObject.genderSelectionArray indexOfObject:genderSelection[indexOfDeletedItem]];
        [selectedFilterIndexes[0] removeObjectAtIndex:indexOfItem];
        [filterSelectionObject.genderSelectionArray removeObject:genderSelection[indexOfDeletedItem]];
        
    }
    else if([accomodation containsObject:deletedItem] && filterSelectionObject.accomodation_typeArray.count > 0) {
        NSUInteger indexOfDeletedItem = [accomodation indexOfObject:deletedItem];
        NSUInteger indexOfItem = [filterSelectionObject.accomodation_typeArray indexOfObject:accomodationKeys[indexOfDeletedItem]];
        [selectedFilterIndexes[1] removeObjectAtIndex:indexOfItem];
        [filterSelectionObject.accomodation_typeArray removeObject:accomodationKeys[indexOfDeletedItem]];
    }
    else if ([amenities containsObject:deletedItem] && filterSelectionObject.amenitiesArray.count > 0) {
        NSUInteger indexOfDeletedItem = [amenities indexOfObject:deletedItem];
        NSUInteger indexOfItem = [filterSelectionObject.amenitiesArray indexOfObject:amenitiesKeys[indexOfDeletedItem]];
        [selectedFilterIndexes[2] removeObjectAtIndex:indexOfItem];
        [filterSelectionObject.amenitiesArray removeObject:amenitiesKeys[indexOfDeletedItem]];
    }
    else if([houseRules containsObject:deletedItem] && filterSelectionObject.house_rulesArray.count > 0) {
        NSUInteger indexOfDeletedItem = [houseRules indexOfObject:deletedItem];
        NSUInteger indexOfItem = [filterSelectionObject.house_rulesArray indexOfObject:houseRuleKeys[indexOfDeletedItem]];
        [selectedFilterIndexes[3] removeObjectAtIndex:indexOfItem];
        [filterSelectionObject.house_rulesArray removeObject:houseRuleKeys[indexOfDeletedItem]];
    }
    
else {
        if ([filterSelectionObject.search_key isEqualToString:deletedItem]) {
            [self.navigationController popViewControllerAnimated:YES];
            filterSelectionObject.search_key = @"";
            
        }
    }
    
    PropertyDetailAdaptor *propertyDetailAdaptor = [[PropertyDetailAdaptor alloc]initWithFilterObject:filterSelectionObject withPageNumber:0 withRequestForURL:requestURLFrom];
    [propertyDetailAdaptor fetchPropertyListData];
    
}

#pragma mark- Property and Map Switching

- (IBAction)PropertyList:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if(!btn.isSelected)
    {
        listViewLabel.textColor = [UIColor colorWithRed:69/255.0 green:83/255.0 blue:164/255.0 alpha:1.0f];
        listImageView.image=[UIImage imageNamed:@"list-view-selected"];
        listViewBottomLine.hidden = NO;
        listViewButton.selected = YES;
        
        mapViewLabel.textColor = [UIColor lightGrayColor];
        mapImageViw.image=[UIImage imageNamed:@"map-view"];
        mapViewBottomLine.hidden = YES;
        mapViewButton.selected = NO;
        
        ChildListViewController *propertyListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChildListViewControllerId"];
        propertyListViewController.filterData = filterSelectionObject;
        propertyListViewController.brandedPropertyList = _brandedPropertyData;
        propertyListViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:propertyListViewController];
        self.currentViewController = propertyListViewController;
        
    }
}

- (IBAction)MapViewButton:(id)sender {

    UIButton *btn = (UIButton *)sender;
    
    if (!btn.isSelected) {
        listViewLabel.textColor = [UIColor lightGrayColor];
        listViewBottomLine.hidden = YES;
        listViewButton.selected = NO;
        listImageView.image=[UIImage imageNamed:@"list-view"];
        mapViewLabel.textColor = [UIColor colorWithRed:69/255.0 green:83/255.0 blue:164/255.0 alpha:1.0f];
        mapImageViw.image=[UIImage imageNamed:@"map-view-selected"];
        mapViewBottomLine.hidden = NO;
        mapViewButton.selected = YES;
        
        
        MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewControllerId"];
        mapViewController.filterData = filterSelectionObject;
        mapViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:mapViewController];
        selected= @"yes";
        self.currentViewController = mapViewController;
    }
}

- (IBAction)ShowMenu:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (IBAction)showFilterView:(id)sender {
    FilterViewController *obj=[self .storyboard instantiateViewControllerWithIdentifier:@"FilterViewControllerID"];
    obj.delegate = self;
    obj.lastSelectedFilterIndex = selectedFilterIndexes;
    obj.filterData = filterSelectionObject;
    obj.requestForURL = requestURLFrom;
    obj.allAppliedFilters = [NSMutableArray arrayWithArray:titleForNavigationTitleLabelArray].mutableCopy;
    
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark - FilterViewController Delegate

- (void) appliedFilter:(NSArray *)filterSelectedData withFilterObject:(FilterSelectionDetail*)filterDetailObject andWithSelectedFiltersIndexes:(NSArray *)selectedIndexArray withURL:(NSString*)requestURL{

    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    
    selectedFilterIndexes = selectedIndexArray.mutableCopy;
    titleForNavigationTitleLabelArray = [NSMutableArray arrayWithArray:filterSelectedData];
    filterSelectionObject = filterDetailObject;
    PropertyDetailAdaptor *propertyDetailAdaptor = [[PropertyDetailAdaptor alloc]initWithFilterObject:filterDetailObject withPageNumber:0 withRequestForURL:requestURL];
    [propertyDetailAdaptor fetchPropertyListData];
    
    [navigationCollectionView reloadData];
}

- (IBAction)sortOptionView:(id)sender {
    if ([selected isEqualToString:@"yes"]) {
        NSLog(@"hello");
    }
    else
    {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *lowToHighButton = [UIAlertAction actionWithTitle:@"PRICE(Low to High)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter]postNotificationName:SortNotification
                                                           object:@"PRICE(Low to High)"];
    }];
    UIAlertAction *highToLowButton = [UIAlertAction actionWithTitle:@"PRICE(High to Low)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter]postNotificationName:SortNotification
                                                           object:@"PRICE(High to Low)"];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheet addAction:lowToHighButton];
    [actionSheet addAction:highToLowButton];
    [actionSheet addAction:cancelAction];
    
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    }}

@end
