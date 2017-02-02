//
//  Property_AmenitiesTableViewCell.m
//  mobApp
//
//  Created by MAG on 16/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "Property_AmenitiesTableViewCell.h"
#import "AmenitieCollectionViewCell.h"
#import "AmenitiesDetail.h"

@implementation Property_AmenitiesTableViewCell
//@synthesize cupboard;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _amenitiesCollectionView.delegate = self;
    _amenitiesCollectionView.dataSource =  self;
    
    [_amenitiesCollectionView registerNib:[UINib nibWithNibName:@"AmenitieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AmenitieCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpAmenitiesDetailsWithData:(NSArray*)amenitiesData {
    _amenitiesDataList = amenitiesData;
    
    CGFloat rowCount = ceil(_amenitiesDataList.count/2.0);
    _amenitiesCollectionView.frame = CGRectMake(0, 0, self.bounds.size.width, rowCount * 40);
    [_amenitiesCollectionView layoutIfNeeded];
    [_amenitiesCollectionView reloadData];
    
}

#pragma mark - UICollectionView Delegate and DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_amenitiesDataList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_amenitiesCollectionView.bounds.size.width/2 - 5, 35);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AmenitieCollectionViewCell";
    
    AmenitieCollectionViewCell *cell = (AmenitieCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    AmenitiesDetail *amenitiesDetail = _amenitiesDataList[indexPath.item];
    
    cell.amenitieTitleLabel.text = amenitiesDetail.cfacility;
    if ([amenitiesDetail.included boolValue]) {
        cell.selectionImageView.image = [UIImage imageNamed:@"check"];
    }
    
    UIImage *amenitieImage = nil;
    
    switch ([amenitiesDetail.cfacilityid integerValue]) {
        case 1:
            amenitieImage = [UIImage imageNamed:@"Kitchen-with-burner"];
            break;
        case 2:
            amenitieImage = [UIImage imageNamed:@"Microwave"];
            break;
        case 3:
            amenitieImage = [UIImage imageNamed:@"Bike-Parking"];
            break;
        case 4:
            amenitieImage = [UIImage imageNamed:@"Housekeeping"];
            break;
        case 5:
            amenitieImage = [UIImage imageNamed:@"Laundry"];
            break;
        case 6:
            amenitieImage = [UIImage imageNamed:@"Cafeteria"];
            break;
        case 7:
            amenitieImage = [UIImage imageNamed:@"Wi-fi"];
            break;
        case 8:
            amenitieImage = [UIImage imageNamed:@"TV-Room"];
            break;
        case 9:
            amenitieImage = [UIImage imageNamed:@"Water-Purifier"];
            break;
        case 10:
            amenitieImage = [UIImage imageNamed:@"Dining-table"];
            break;
        case 11:
            amenitieImage = [UIImage imageNamed:@"Power-Backup"];
            break;
        case 12:
            amenitieImage = [UIImage imageNamed:@"Car-Parking"];
            break;
        case 14:
            amenitieImage = [UIImage imageNamed:@"Guardian-allowed"];
            break;
        case 15:
            amenitieImage = [UIImage imageNamed:@"Indoor-Sport"];
            break;
        case 16:
            amenitieImage = [UIImage imageNamed:@"Outdoor Sports"];
            break;
        case 17:
            amenitieImage = [UIImage imageNamed:@"Security-guard"];
            break;
        case 18:
            amenitieImage = [UIImage imageNamed:@"CCTV"];
            break;
        case 19:
            amenitieImage = [UIImage imageNamed:@"Doctor-on-call"];
            break;
        default:
            break;
    }
    
    cell.amenitieImageView.image = amenitieImage;

    return cell;
}

@end
