//
//  ListAndMapViewController.h
//  mobApp
//
//  Created by MAG on 13/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "FilterSelectionDetail.h"

@interface ListAndMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *navigationCollectionView;

@property(nonatomic,retain) NSString *localityAddress;
@property(nonatomic,retain) NSString *selectedCityValue;
@property (strong, nonatomic) NSMutableArray *selectedGenderIndexArray;
@property (strong, nonatomic) NSMutableArray *selectedAccomodationIndexArray;
@property (strong, nonatomic) NSMutableArray *selectedAmenitiesIndexArray;
@property (strong, nonatomic) NSMutableArray *selectedHouseRuleIndexArray;


- (IBAction)PropertyList:(id)sender;
- (IBAction)MapViewButton:(id)sender;
//@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)ShowMenu:(id)sender;

@property (strong, nonatomic) NSMutableArray *brandedPropertyData;

@end
