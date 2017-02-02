//
//  HomeCollectionViewCell.h
//  Studentacco
//
//  Created by Ravi Patel on 27/01/17.
//  Copyright © 2017 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *PropertyImage;
@property (weak, nonatomic) IBOutlet UIButton *LikeButton;
@property (weak, nonatomic) IBOutlet UILabel *brandedLabel;
@property (weak, nonatomic) IBOutlet UILabel *address1Label;
@property (weak, nonatomic) IBOutlet UILabel *address2Label;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *onwardsLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@end
