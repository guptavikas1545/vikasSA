//
//  BrandedPropertyCollectionViewCell.m
//  StudentAcco
//
//  Created by MAG on 30/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "BrandedPropertyCollectionViewCell.h"
#import "InnerCollectionViewCell.h"
@implementation BrandedPropertyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_brandedPropertyCollectionView registerNib:[UINib nibWithNibName:@"InnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"innerCollectionCell"];
    _brandedPropertyCollectionView.delegate = self;
    _brandedPropertyCollectionView.dataSource = self;
}

-(void)setUpBrandedPropertyData:(NSArray*)propertyDataList
{
    _propertyDataArray = [NSArray arrayWithArray:propertyDataList];
    [_brandedPropertyCollectionView reloadData];
}

#pragma mark - UICollectionView Delegate and DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _propertyDataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(300, 263);
    
    return size;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"innerCollectionCell";
    
    InnerCollectionViewCell *cell = (InnerCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    WishListDetail *propertyDetail = _propertyDataArray[indexPath.item];
    
    cell.property_nameLabel.text = propertyDetail.property_name;
    cell.rentLabel.text = propertyDetail.rent;
    
    NSMutableString *propertyAddress = [NSMutableString string];
    if (propertyDetail.address_locality.length > 0) {
        [propertyAddress appendString:[NSString stringWithFormat:@"%@,",propertyDetail.address_locality]];
    }
    if (propertyDetail.address_street.length > 0) {
        [propertyAddress appendString:[NSString stringWithFormat:@" %@,",propertyDetail.address_street]];
    }
    if (propertyDetail.address_city.length > 0) {
        [propertyAddress appendString:[NSString stringWithFormat:@" %@,",propertyDetail.address_city]];
    }
    if (propertyDetail.address_state.length > 0) {
        [propertyAddress appendString:[NSString stringWithFormat:@" %@,",propertyDetail.address_state]];
    }
    if (propertyDetail.address_country.length > 0) {
        [propertyAddress appendString:[NSString stringWithFormat:@" %@",propertyDetail.address_country]];
    }
    cell.property_addressLabel.text = propertyAddress;
    
    // for async image loading
    cell.activityLoader.hidden = NO;
    cell.brandImageView.image = nil;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",propertyDetail.imagename]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    InnerCollectionViewCell *updateCell = (id)[_brandedPropertyCollectionView cellForItemAtIndexPath:indexPath];
                    updateCell.activityLoader.hidden = YES;
                    updateCell.brandImageView.image = image;
                });
            }
        }
    }];
    [task resume];
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WishListDetail *propertyDetail = _propertyDataArray[indexPath.item];
    [self.delegate moveToSelectedProperty:propertyDetail];
}



@end
