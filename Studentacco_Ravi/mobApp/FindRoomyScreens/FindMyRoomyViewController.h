//
//  FindMyRoomyViewController.h
//  Studentacco
//
//  Created by MAG on 02/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FindMyRoomyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *findMyroomyTableView;
@property (strong, nonatomic) NSMutableArray *selectedFoodHabitIndexArray;
@property (strong, nonatomic) NSMutableArray *selectedSmokngHabitIndexArray;
@property (strong, nonatomic) NSMutableArray *selectedMyAccoIndexArray;
@property (strong, nonatomic) NSMutableArray *localityArray;
@property (nonatomic) CGFloat lastContentOffset;
@property (strong, nonatomic) NSMutableArray *allAppliedFilters;
@end
