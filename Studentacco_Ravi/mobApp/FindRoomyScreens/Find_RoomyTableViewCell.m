//
//  Find_RoomyTableViewCell.m
//  Studentacco
//
//  Created by MAG on 05/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "Find_RoomyTableViewCell.h"
#import "Find_RoomyCollectionViewCell.h"
#import "FindRoomyCheckBoxCollectionViewCell.h"
@implementation Find_RoomyTableViewCell
{
    NSMutableArray *globelIndexPath;
}
- (void)awakeFromNib {
    
    [_Find_RoomyCollectionView registerNib:[UINib nibWithNibName:@"Find_RoomyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"find_RoomyCollectionViewCell"];
    [_Find_RoomyCollectionView registerNib:[UINib nibWithNibName:@"FindRoomyCheckBoxCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"findRoomyCheckBoxCollectionViewCell"];
    _Find_RoomyCollectionView.delegate = self;
    _Find_RoomyCollectionView.dataSource = self;
    
    [super awakeFromNib];
    // Initialization code
}


- (void)setUp:(NSArray*)data withSelectedIndexes:(NSMutableArray*)indexArray {
    _filterArray = data;
    
    globelIndexPath=indexArray.mutableCopy;
    
    [_Find_RoomyCollectionView reloadData];
}


#pragma mark - UICollectionView Delegate and DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return _filterArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width)/2;
    CGSize layoutSize;
    layoutSize = CGSizeMake(width-1,45);
    return layoutSize;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *reuseCell = nil;

    static NSString *identifier = @"find_RoomyCollectionViewCell";
    static NSString *identifier1 = @"findRoomyCheckBoxCollectionViewCell";
    if ([_Selectedsection isEqualToString:@"yes"]) {
        FindRoomyCheckBoxCollectionViewCell *cell = (FindRoomyCheckBoxCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
        cell.checkboxNameLabel.text = _filterArray[indexPath.item];
        cell.checkBoxImageView.image=[UIImage imageNamed:@"checkbox-empty"];
        cell.checkboxNameLabel.textColor = [UIColor blackColor];
        for (int i= 0; i< globelIndexPath.count; i++) {
            NSIndexPath *tempIndex = globelIndexPath[i];
            if(tempIndex.item == indexPath.item && tempIndex.section == indexPath.section) {
                cell.checkboxNameLabel.textColor = [UIColor redColor];
                cell.checkBoxImageView.image=[UIImage imageNamed:@"checkbox-checked"];
                break;
            }}
            reuseCell=cell;
        }
    else
    {
    Find_RoomyCollectionViewCell *cell = (Find_RoomyCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.findRoomyfilterLabel.text = _filterArray[indexPath.item];
    cell.findRoomyRadioButtonImageView.image=[UIImage imageNamed:@"radio-button"];
    cell.findRoomyfilterLabel.textColor = [UIColor blackColor];
    for (int i= 0; i< globelIndexPath.count; i++) {
        NSIndexPath *tempIndex = globelIndexPath[i];
        if(tempIndex.item == indexPath.item && tempIndex.section == indexPath.section) {
            cell.findRoomyfilterLabel.textColor = [UIColor redColor];
            cell.findRoomyRadioButtonImageView.image=[UIImage imageNamed:@"radio-button-checked"];
            break;
        }}
      
        reuseCell = cell;
        
    }
    
    return reuseCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isPresent = NO;
    if ([_Selectedsection isEqualToString:@"yes"]) {
        for (int i= 0; i< globelIndexPath.count; i++) {
            NSIndexPath *tempIndex = globelIndexPath[i];
            if(tempIndex.item == indexPath.item && tempIndex.section == indexPath.section) {
                isPresent = YES;
                [globelIndexPath removeObjectAtIndex:i];
                break;
            }
        }
        if (!isPresent) {
            [globelIndexPath addObject:indexPath];
        }

    }
    else
    {
       for (int i= 0; i< globelIndexPath.count; i++) {
           isPresent = YES;
        NSIndexPath *tempIndex = globelIndexPath[i];
           if((tempIndex.item != indexPath.item)  && tempIndex.section == indexPath.section) {
                        [globelIndexPath removeObjectAtIndex:i];
               [collectionView reloadItemsAtIndexPaths:@[tempIndex]];
               [globelIndexPath addObject:indexPath];
           }
           else
           {
                [globelIndexPath removeObjectAtIndex
                 :i];
           }
    }
    if (!isPresent) {
        [globelIndexPath removeAllObjects];
        [globelIndexPath addObject:indexPath];
    }
}
    [self.delegate selectedIndexesArray:indexPath withSelectedCell:self];
[collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
