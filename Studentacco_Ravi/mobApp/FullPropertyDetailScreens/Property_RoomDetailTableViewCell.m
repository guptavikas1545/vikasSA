//
//  Property_RoomDetailTableViewCell.m
//  StudentAcco
//
//  Created by MAG on 20/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "Property_RoomDetailTableViewCell.h"
#import "RoomDetailCollectionViewCell.h"
#import "RoomDetail.h"

@implementation Property_RoomDetailTableViewCell

@synthesize occupancyTypeLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _roomDetailCollectionView.delegate = self;
    _roomDetailCollectionView.dataSource =  self;
    
    [_roomDetailCollectionView registerNib:[UINib nibWithNibName:@"RoomDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RoomDetailCollectionViewCell"];
    
    _amenitiesArray = @[@"Attached toilet", @"AC", @"Cupboard", @"Fridge", @"Bedding", @"Table/Chair", @"Geyser", @"TV"];
    _amenitiesImageArray = @[@"toilet-icon", @"ac-icon", @"cupboard-icon", @"fridge-icon", @"bedding-icon", @"chair-icon", @"geyser-icon", @"tv-icon"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpRoomDetailsWithData:(NSArray*)roomData {
    _roomDataList = roomData;
    
    CGFloat rowCount = ceil(_roomDataList.count/3.0);
    _roomDetailCollectionView.frame = CGRectMake(0, 0, self.bounds.size.width, rowCount * 40);
    [_roomDetailCollectionView layoutIfNeeded];
    [_roomDetailCollectionView reloadData];
    
}

#pragma mark - UICollectionView Delegate and DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_roomDataList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_roomDetailCollectionView.bounds.size.width/3 - 5, 28);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"RoomDetailCollectionViewCell";
    
    RoomDetailCollectionViewCell *cell = (RoomDetailCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *roomDetail = _roomDataList[indexPath.item];
    cell.roomDetailTitleLabel.text = roomDetail;
    
    NSInteger indexValue = [_amenitiesArray indexOfObject:roomDetail];
    cell.roomDetailImageView.image = [UIImage imageNamed:_amenitiesImageArray[indexValue]];
    
    return cell;
}


@end
