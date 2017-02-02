//
//  Find_RoomyTableViewCell.h
//  Studentacco
//
//  Created by MAG on 05/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Find_RoomyTableViewCellDelegate <NSObject>

@required

- (void) selectedIndexesArray:(NSIndexPath*)selectedIndex withSelectedCell:(id)findRoomyTableCell;

@end
@interface Find_RoomyTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *Find_RoomyCollectionView;

@property(weak, nonatomic) id <Find_RoomyTableViewCellDelegate> delegate;

- (void)setUp:(NSArray*)data withSelectedIndexes:(NSMutableArray*)indexArray;

@property (nonatomic, strong) NSArray *filterArray;
@property (nonatomic,strong) NSString *Selectedsection;

@end
