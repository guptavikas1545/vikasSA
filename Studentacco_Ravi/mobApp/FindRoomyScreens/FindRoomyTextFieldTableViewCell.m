//
//  FindRoomyTextFieldTableViewCell.m
//  Studentacco
//
//  Created by MAG on 05/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "FindRoomyTextFieldTableViewCell.h"

@implementation FindRoomyTextFieldTableViewCell

- (void)awakeFromNib {
    _aboutMeTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _aboutMeTextField.layer.borderWidth=0.8;

   
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
