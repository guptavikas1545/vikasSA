//
//  SearchBarTableViewCell.m
//  Studentacco
//
//  Created by MAG on 17/08/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "SearchBarTableViewCell.h"

@implementation SearchBarTableViewCell

- (void)awakeFromNib {
    UITextField *txfSearchField = [_seachBar valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor whiteColor]];
    [txfSearchField setBorderStyle:UITextBorderStyleLine];
    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;
    [txfSearchField setFont:[UIFont fontWithName:@"CircularStd-Book" size:15.0f]];
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
