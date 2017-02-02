//
//  Property_AmenitiesTableViewCell.h
//  mobApp
//
//  Created by MAG on 16/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Property_AmenitiesTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *amenitiesCollectionView;
@property (strong, nonatomic) NSArray *amenitiesDataList;

- (void)setUpAmenitiesDetailsWithData:(NSArray*)amenitiesData;

@end
