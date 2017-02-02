//
//  GenderSelectionTableViewCell.m
//  StudentAcco
//
//  Created by MAG  on 6/28/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "GenderSelectionTableViewCell.h"

@implementation GenderSelectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _maleSelectionButton.layer.cornerRadius = _maleSelectionButton.frame.size.width / 2;
    _maleSelectionButton.layer.borderWidth = 0.8f;
    _maleSelectionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _femaleSelectionButton.layer.cornerRadius = _femaleSelectionButton.frame.size.width / 2;
    _femaleSelectionButton.layer.borderWidth = 0.8f;
    _femaleSelectionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
