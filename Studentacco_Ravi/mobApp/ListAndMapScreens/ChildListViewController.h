//
//  ChildListViewController.h
//  mobApp
//
//  Created by MAG on 13/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterSelectionDetail.h"

@interface ChildListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *listViewCollectionView;
@property (strong, nonatomic) NSString *showListType;

@property (strong, nonatomic) FilterSelectionDetail *filterData;
@property (strong, nonatomic) NSArray *brandedList;
@property (strong, nonatomic) NSMutableArray *wishListArray;
@property (strong, nonatomic) NSMutableArray *brandedPropertyList;

@end
