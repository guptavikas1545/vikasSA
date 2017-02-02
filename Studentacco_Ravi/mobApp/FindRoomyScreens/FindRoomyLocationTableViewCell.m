//
//  FindRoomyLocationTableViewCell.m
//  Studentacco
//
//  Created by MAG on 05/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "FindRoomyLocationTableViewCell.h"
#import "CityNameLabelCollectionViewCell.h"
#import "FindMyRoomyViewController.h"
@implementation FindRoomyLocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _locationTextBox.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        _locationTextBox.layer.borderWidth=0.8;
    _selectedLocationCollectionView.delegate=self;
    _selectedLocationCollectionView.dataSource=self;
    _localityCityName = [[NSMutableArray alloc]init];
    [_selectedLocationCollectionView registerNib:[UINib nibWithNibName:@"CityNameLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cityNameLabelCollectionViewCell"];
    // Initialization code
}
#pragma mark - UICollectionView Delegate and DataSource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _localityCityName.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize calCulateSizze =[(NSString*)[_localityCityName objectAtIndex:indexPath.row] sizeWithAttributes:NULL];
    
    calCulateSizze.width = calCulateSizze.width+60;
    calCulateSizze.height = calCulateSizze.height +10;
    
    return calCulateSizze;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cityNameLabelCollectionViewCell";
    
    CityNameLabelCollectionViewCell *cell = (CityNameLabelCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
     cell.nameLabel.textAlignment = NSTextAlignmentLeft;
    cell.nameLabel.text=_localityCityName[indexPath.row];
    
    [cell.removeFromList addTarget:self
                              action:@selector(removeSelectedFilter:)
                    forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)removeSelectedFilter:(UIButton*)sender
{
    FindMyRoomyViewController *obj = [[FindMyRoomyViewController alloc]initWithNibName:@"FindMyRoomyViewController" bundle:nil];
    NSIndexPath *indexPath = [_selectedLocationCollectionView indexPathForCell:(UICollectionViewCell *)sender.superview.superview];
  
    [_localityCityName removeObjectAtIndex:indexPath.item];
    [obj.localityArray addObjectsFromArray:_localityCityName];
   
    [_selectedLocationCollectionView reloadData];
    [self.delegate DeletedIndex:indexPath];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
