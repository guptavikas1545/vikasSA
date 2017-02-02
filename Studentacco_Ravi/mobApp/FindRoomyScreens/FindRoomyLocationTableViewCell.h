//
//  FindRoomyLocationTableViewCell.h
//  Studentacco
//
//  Created by MAG on 05/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FindRoomyLocationTableViewCellDelegate <NSObject>
@required
- (void)DeletedIndex:(NSIndexPath*)index ;
@end

@interface FindRoomyLocationTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *locationTextBox;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *selectedLocationCollectionView;
@property(nonatomic, strong)NSMutableArray *localityCityName;
@property (strong, nonatomic)id<FindRoomyLocationTableViewCellDelegate>delegate;


@end
