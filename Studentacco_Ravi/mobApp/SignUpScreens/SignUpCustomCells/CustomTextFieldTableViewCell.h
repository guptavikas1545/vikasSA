//
//  CustomTextFieldTableViewCell.h
//  StudentAcco
//
//  Created by MAG  on 6/28/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *astricLabel;
@property (weak, nonatomic) IBOutlet UITextField *userInputTextField;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImageView;


@end
