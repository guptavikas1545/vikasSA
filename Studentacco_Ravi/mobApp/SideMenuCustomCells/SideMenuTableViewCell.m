//
//  SideMenuTableViewCell.m
//  mobApp
//
//  Created by MAG on 11/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "SideMenuTableViewCell.h"

@implementation SideMenuTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:65/255.0 green:97/255.0 blue:169/255.0 alpha:1.0f]]; // set color here
    [self setSelectedBackgroundView:selectedBackgroundView];
    // Configure the view for the selected state
}

@end
