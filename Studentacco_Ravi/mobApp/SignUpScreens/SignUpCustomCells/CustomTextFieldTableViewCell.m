//
//  CustomTextFieldTableViewCell.m
//  StudentAcco
//
//  Created by MAG  on 6/28/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "CustomTextFieldTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomTextFieldTableViewCell
@synthesize userInputTextField;
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
//    userInputTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    userInputTextField.layer.borderWidth=0.8;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
