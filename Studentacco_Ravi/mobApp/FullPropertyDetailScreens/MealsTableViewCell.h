//
//  MealsTableViewCell.h
//  StudentAcco
//
//  Created by MAG on 20/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *breakfastAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lunchAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dinnerAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *breakfastLabel;
@property (weak, nonatomic) IBOutlet UILabel *dinnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *lunchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *breakfastImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lunchImageView;
@property (weak, nonatomic) IBOutlet UIImageView *dinnerImageView;


@end
