
//
//  FilterTableViewCell.h
//  mobApp
//
//  Created by MAG on 17/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FilterTableViewCellDelegate <NSObject>

@required

- (void) selectedIndexesArrayList:(NSIndexPath*)selectedIndex withSelectedCell:(id)filterTableCell;

@end


@interface FilterTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;

@property (weak, nonatomic) id<FilterTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSArray *filterArray;

- (void)setUp:(NSArray*)data withSelectedIndexes:(NSMutableArray*)indexArray;

@end
