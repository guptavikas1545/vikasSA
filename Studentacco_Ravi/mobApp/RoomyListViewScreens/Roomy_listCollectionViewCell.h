//
//  Roomy_listCollectionViewCell.h
//  Studentacco
//
//  Created by MAG on 07/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Roomy_listCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *roomyImageView;
@property (weak, nonatomic) IBOutlet UILabel *roomyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleLable;
@property (weak, nonatomic) IBOutlet UILabel *doubleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dormLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UILabel *foodHabitNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *smokingHabitNameLabel;

@property (weak, nonatomic) IBOutlet UITextView *aboutMeTextView;

@end
