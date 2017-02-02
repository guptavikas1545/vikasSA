//
//  BrandedPropertyCollectionViewCell.h
//  StudentAcco
//
//  Created by MAG on 30/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishListDetail.h"
@protocol BrandedPropertyCollectionViewCellDelegate <NSObject>

- (void)moveToSelectedProperty :(WishListDetail *)selectedProperty;

@end
@interface BrandedPropertyCollectionViewCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *propertyDataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *brandedPropertyCollectionView;
@property (weak, nonatomic) id<BrandedPropertyCollectionViewCellDelegate> delegate;

-(void)setUpBrandedPropertyData:(NSArray*)propertyDataList;

@end
