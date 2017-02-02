//
//  FilterTableViewCell.m
//  mobApp
//
//  Created by MAG on 17/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "FilterTableViewCell.h"
#import "FilterTableCollectionViewCell.h"
@implementation FilterTableViewCell
{
    NSMutableArray *globelIndexPath;
}
@synthesize filterCollectionView;
- (void)awakeFromNib {
    
    [filterCollectionView registerNib:[UINib nibWithNibName:@"FilterTableCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FilterTableCollectionViewCellID"];
    filterCollectionView.delegate = self;
    filterCollectionView.dataSource = self;
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setUp:(NSArray*)data withSelectedIndexes:(NSMutableArray*)indexArray {
    _filterArray = data;
    
    globelIndexPath=indexArray.mutableCopy;
    
    [filterCollectionView reloadData];
}

#pragma mark - UICollectionView Delegate and DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _filterArray.count;
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FilterTableCollectionViewCellID";
    
    FilterTableCollectionViewCell *cell = (FilterTableCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.filterLable.text = _filterArray[indexPath.item];
    cell.checkBoxImageView.image=[UIImage imageNamed:@"checkbox-empty"];
    cell.filterLable.textColor = [UIColor blackColor];
    for (int i= 0; i< globelIndexPath.count; i++) {
        NSIndexPath *tempIndex = globelIndexPath[i];
        if(tempIndex.item == indexPath.item && tempIndex.section == indexPath.section) {
            cell.filterLable.textColor = [UIColor redColor];
            cell.checkBoxImageView.image=[UIImage imageNamed:@"checkbox-checked"];
            break;
        }
        
    }
   
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isPresent = NO;
    
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
    [self.delegate selectedIndexesArrayList:indexPath withSelectedCell:self];
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width)/2;
    CGSize layoutSize;
    layoutSize = CGSizeMake(width-1,45);
    return layoutSize;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
