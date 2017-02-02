//
//  OuterCollectionViewCell.h
//  mobApp
//
//  Created by MAG on 06/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyDetail.h"
#import "UserDetail.h"
#import "WishListDetail.h"
@protocol OuterCollectionViewCellDelegate <NSObject>

- (void)moveToSelectedProperty :(WishListDetail *)selectedProperty;
- (void)moveToContactLandlord :(WishListDetail *)selectedProperty;
//- (void)addToWishList :(WishListDetail *)selectedProperty;
//- (void)searchButtonClicked;
- (void)CallAutocomplete:(NSString*)searchText ;
- (void)selected;
@end

@interface OuterCollectionViewCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong)WishListDetail *propertyDetail;
@property (weak, nonatomic) IBOutlet UICollectionView *innerCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, strong) NSArray *propertyDataArray;
@property (nonatomic, strong) NSMutableArray *wishListArray;
@property (nonatomic) CGFloat lastContentOffset;

@property (weak, nonatomic) id<OuterCollectionViewCellDelegate> delegate;

-(void)setUpBrandedPropertyData:(NSArray*)propertyDataList;

@end
