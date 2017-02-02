//
//  ProfilePictureTableViewCell.m
//  StudentAcco
//
//  Created by MAG on 28/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "ProfilePictureTableViewCell.h"

@implementation ProfilePictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _chooseImage.layer.cornerRadius = 5.0f;
    _chooseImage.layer.borderWidth = 0.5f;
    _chooseImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
