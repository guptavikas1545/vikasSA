//
//  WishListViewController.h
//  StudentAcco
//
//  Created by MAG on 12/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterSelectionDetail.h"

@interface WishListViewController : UIViewController<UICollectionViewDelegate>
//{
//    NSMutableArray *wishListArray;
//}
@property (weak, nonatomic) IBOutlet UICollectionView *wishListCollectionView;
//@property (strong, nonatomic) NSString *showListType;

@property (strong, nonatomic) FilterSelectionDetail *filterData;
@property (strong, nonatomic) NSMutableArray *globalWishListArray;
@end
