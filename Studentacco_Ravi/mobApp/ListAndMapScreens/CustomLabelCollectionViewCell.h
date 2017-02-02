//
//  CustomLabelCollectionViewCell.h
//  StudentAcco
//
//  Created by MAG  on 7/7/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabelCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *filterTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeFromFilter;

@end
