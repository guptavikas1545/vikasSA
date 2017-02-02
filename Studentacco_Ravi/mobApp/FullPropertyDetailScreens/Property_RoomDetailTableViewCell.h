//
//  Property_RoomDetailTableViewCell.h
//  StudentAcco
//
//  Created by MAG on 20/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Property_RoomDetailTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *roomDetailCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *occupancyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentLabel;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;

@property (strong, nonatomic) NSArray *amenitiesImageArray;
@property (strong, nonatomic) NSArray *amenitiesArray;

@property (strong, nonatomic) NSArray *roomDataList;
- (void)setUpRoomDetailsWithData:(NSArray*)roomData;

@end
